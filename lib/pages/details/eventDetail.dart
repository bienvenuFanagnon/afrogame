import 'dart:typed_data';
import 'package:afroevent/controllers/authController.dart';
import 'package:afroevent/pages/commentaire/EventComments.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../models/event_models.dart';
import '../auth/login.dart';
import '../share/DateWidget.dart';
import '../share/EventWidgetView.dart';
import '../share/FonctionWidget.dart';
import '../share/LogoText.dart';
import '../share/messageRequireWidget.dart';

class DetailsEventPage extends StatefulWidget {
  final EventData event;
  DetailsEventPage({required this.event});

  @override
  _DetailsEventPageState createState() => _DetailsEventPageState();
}

class _DetailsEventPageState extends State<DetailsEventPage> {
  final Color primaryColor = Color(0xFF2E7D32);
  final Color accentColor = Color(0xFF81C784);
  AuthController authController=Get.find();
  int _currentMediaIndex = 0;
  late CarouselSliderController  _carouselController;
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    authController.getEventById(widget.event.id!).then((value) {
      if(value!.usersVues!=null){
        widget.event.vue=widget.event.vue!+1;
        value.vue=value.vue!+1;

        value!.usersVues!.add(authController.userLogged.id!);
         authController.updateEvent(value).then((value) {
          setState(() {

          });
        },);
      }
    },);
    _carouselController = CarouselSliderController();
    _initializeVideoController(_currentMediaIndex);
  }

  void _initializeVideoController(int index) {
    final media = widget.event.medias?[index];
    if (media != null && media['type'] == 'video') {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(media['url']!)
        ..initialize().then((_) {
          setState(() {
            _videoController!.setVolume(0);
            _isVideoPlaying = false;
          });
        });
    } else {
      _videoController?.dispose();
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleVideoPlay() {
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
      _isVideoPlaying ? _videoController?.play() : _videoController?.pause();
    });
  }

  Widget _buildMediaItem(Map<String, dynamic> media, int index) {
    if (media['type'] == 'image') {
      return GestureDetector(
        onTap: () => _showFullScreenMedia(index),
        child: Image.network(media['url']!, fit: BoxFit.cover),
      );
    } else {
      return GestureDetector(
        // onTap: _handleVideoTap,
        onTap: () {
          _showFullScreenMedia(index);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<Uint8List?>(
              future: FlutterVideoThumbnailPlus.thumbnailData(
                video: media['url']!,
                imageFormat: ImageFormat.jpeg,
                maxWidth: 200,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return Container(color: Colors.black);
              },
            ),
            if (_currentMediaIndex == index)
              _buildVideoControllerWidget()
            else
              Center(
                child: Icon(Icons.play_circle_filled,
                    size: 50, color: Colors.white.withOpacity(0.8)),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildVideoControllerWidget() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController!),
          if (!_isVideoPlaying)
            Icon(Icons.play_circle_filled,
                size: 50, color: Colors.white.withOpacity(0.8)),
        ],
      ),
    );
  }

  void _handleVideoTap() {
    if (_videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      setState(() {
        _isVideoPlaying = !_isVideoPlaying;
      });
    }
  }

  Widget _buildMediaCarousel() {
    double h=MediaQuery.of(context).size.height;
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.event.medias?.length ?? 0,
      itemBuilder: (context, index, realIndex) {
        final media = widget.event.medias![index];
        return _buildMediaItem(media, index);
      },
      options: CarouselOptions(
        height: h*0.4,
        viewportFraction: 1.0,
        onScrolled: (value) {

        },
        enableInfiniteScroll: false,
        autoPlay: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentMediaIndex = index;
            _initializeVideoController(index);
          });
        },
      ),
    );
  }

  Widget _buildMediaIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.event.medias!.asMap().entries.map((entry) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentMediaIndex == entry.key
                ? primaryColor
                : Colors.white.withOpacity(0.5),
          ),
        );
      }).toList(),
    );
  }

  void _showFullScreenMedia(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenMediaView(
          medias: widget.event.medias!,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildInteractionButton(
      IconData icon, String count, Function onPressed) {
    return TextButton.icon(
      icon: Icon(icon, color: primaryColor),
      label: Text(count, style: TextStyle(color: Colors.grey[700])),
      onPressed: () => onPressed(),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _openGoogleMaps(String map) async {
    final url = Uri.encodeFull(map);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Erreur', 'Impossible d\'ouvrir Google Maps',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.green),
        title: LogoText(),


        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.green),
            onPressed: () {
              if(authController.userLogged.id==widget.event.userId||authController.userLogged.role==UserRole.ADM.name)
{
  showDialog(
    context: context,
    builder: (context) => EventMenuModal(event: widget.event),
  );
}

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildMediaCarousel(),
                Positioned(
                  bottom: 20,
                  child: _buildMediaIndicator(),
                ),
                // if (widget.event.medias?[_currentMediaIndex]?['type'] == 'video')
                //   Positioned(
                //     bottom: 50,
                //     child: IconButton(
                //       icon: Icon(
                //         _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                //         color: Colors.white,
                //         size: 30,
                //       ),
                //       onPressed: _toggleVideoPlay,
                //     ),
                //   ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.event.titre!,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      ),
                      Chip(
                        label: Text(widget.event.sousCategorie!,
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: accentColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInteractionButton(
                          Icons.remove_red_eye, '${widget.event.vue}', () {}),
                      _buildInteractionButton(
                          Icons.favorite_border, '${widget.event.like}', () async {
                        if(authController.userLogged.id!=null){
                          if(!isIdInList(authController.userLogged.id!,widget.event.userslikes== null?[]:widget.event.userslikes!)){
                            if(widget.event.userslikes!=null){
                              widget.event.userslikes!.add(authController.userLogged.id!);

                            }
                            widget.event.like=widget.event.like!+1;
                            await authController.updateEvent(widget.event);
                            setState(() {
                               authController.sendNotification(
                                userIds: [authController.userLogged.oneIgnalUserid!],
                                smallImage: "${authController.userLogged.urlImage!}",
                                send_user_id: "${authController.userLogged.id!}",
                                recever_user_id: "",
                                message: "📢 @${authController.userLogged.pseudo!} a liké un évenement",
                                type_notif: NotificationType.COMMENT.name,
                                post_id: "${widget.event!.id!}",
                                // post_type: PostDataType.COMMENT.name, chat_id: ''
                              );
                            });
                          }

                        }else{
                          showLoginRequiredDialog(context, () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

                          },);
                        }
                      }),
                      _buildInteractionButton(Icons.comment,
                          '${widget.event.commentaire}', () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EventComments(post: widget.event),));

                          }),
                    ],
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.calendar_today, color: accentColor),
                    title: DateWidget(
                        dateInMicroseconds: widget.event.date!),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: accentColor),
                    title: Text('${widget.event.ville}, ${widget.event.pays}'),
                    trailing: IconButton(
                      icon: Icon(Icons.map, color: primaryColor),
                      onPressed: () =>
                          _openGoogleMaps(widget.event.urlPosition!),
                    ),
                  ),
                  Divider(),
                  Text('Description',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(widget.event.description!,
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class FullScreenMediaView extends StatefulWidget {
  final List<Map<String, dynamic>> medias;
  final int initialIndex;

  FullScreenMediaView({required this.medias, required this.initialIndex});

  @override
  _FullScreenMediaViewState createState() => _FullScreenMediaViewState();
}

class _FullScreenMediaViewState extends State<FullScreenMediaView> {
  late int _currentIndex;
  late CarouselSliderController  _carouselController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  // final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'));
  //
  // await videoPlayerController.initialize();
  //
  // final chewieController = ChewieController(
  //   videoPlayerController: videoPlayerController,
  //   autoPlay: true,
  //   looping: true,
  // );
  //
  // final playerWidget = Chewie(
  //   controller: chewieController,
  // );

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _carouselController = CarouselSliderController();
    _initializeMediaController(_currentIndex);
  }

  void _initializeMediaController(int index) async {
    final media = widget.medias[index];

    // Dispose previous controllers
    _videoController?.dispose();
    _chewieController?.dispose();

    if (media['type'] == 'video') {
      _videoController = VideoPlayerController.network(media['url']);
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white,
          handleColor: Colors.white,
          backgroundColor: Colors.white30,
          bufferedColor: Colors.white54,
        ),
        placeholder: Container(color: Colors.black),
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Widget _buildMediaItem(BuildContext context, int index) {
    final media = widget.medias[index];

    if (media['type'] == 'image') {
      return Center(
        child: Hero(
          tag: "nonTransparent",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              media['url'],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      );

    } else {
      if (_chewieController != null &&
          _chewieController!.videoPlayerController.value.isInitialized) {
        return Chewie(controller: _chewieController!);
      }
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (details) => Navigator.pop(context),
          child: Stack(
            children: [
              SizedBox(
          width: double.infinity,
            height: double.infinity,
            // color: Colors.black, // Fond noir pour un meilleur rendu
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: widget.medias.length,
                  itemBuilder: (context, index, realIndex) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _buildMediaItem(context, index),
                    );
                  },
                  options: CarouselOptions(
                    height: double.infinity,
                    initialPage: _currentIndex,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      if (_currentIndex != index) {
                        _initializeMediaController(index);
                        setState(() => _currentIndex = index);
                      }
                    },
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.medias.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? Colors.white
                            : Colors.white54,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}