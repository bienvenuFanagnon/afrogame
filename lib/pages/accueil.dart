import 'dart:async';
import 'dart:typed_data';
import 'package:afroevent/controllers/authController.dart';
import 'package:afroevent/models/event_models.dart';
import 'package:afroevent/pages/share/DateWidget.dart';
import 'package:afroevent/pages/share/FonctionWidget.dart';
import 'package:afroevent/pages/share/EventWidgetView.dart';
import 'package:afroevent/pages/share/messageRequireWidget.dart';
import 'package:afroevent/pages/share/messageView.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:afroevent/pages/share/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';

import 'auth/login.dart';
import 'details/eventDetail.dart';

class AccueilPage extends StatefulWidget {
  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final AuthController authController = Get.find();
  final StreamController<List<EventData>> _streamController = StreamController<List<EventData>>();
  final Color primaryColor = Color(0xFF2E7D32);
  final Color accentColor = Color(0xFF81C784);

  List<EventData> _allEvents = [];
  List<EventData> get _alaUneEvents => _allEvents.where((e) => e.typeJeu == "EVENEMENT"|| e.typeJeu == "PUB").toList();
  List<EventData> get _gameStories => _allEvents.where((e) => e.typeJeu == "GAMESTORY").toList();
  List<EventData> get _actuStories => _allEvents.where((e) => e.typeJeu == "ACTUALITE").toList();
  // List<EventData> get _actuStories => _allEvents;

  @override
  void initState() {
    authController.getEventDatasImages(40).listen(_streamController.add);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sport News', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [authController.userLogged==null?Icon((Icons.person)):UserProfileWidget(user: authController.userLogged)],
      ),
      body: RefreshIndicator(
        onRefresh:()async {
setState(() {
  authController.getEventDatasImages(40).listen(_streamController.add);

});
        },
        child: StreamBuilder<List<EventData>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            _allEvents = snapshot.data!;
            return CustomScrollView(
              slivers: [
                _buildAlaUneSection(_alaUneEvents,"Événements"),
                _buildAlaUneSection(_actuStories,"Actualités"),
                _textSection("Game Story"),
                _gameStories.isEmpty?_buildVideSection(): _buildGameStoriesSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator(color: primaryColor));

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.event_busy, size: 60, color: Colors.grey),
        SizedBox(height: 20),
        Text('Aucun événement disponible', style: TextStyle(color: Colors.grey)),
      ],
    ),
  );

  SliverToBoxAdapter _buildAlaUneSection(List<EventData>  alaUneEvents,String text) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            // child: Text("À la Une", style: TextStyle(
            child: Text(text, style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            )),
          ),
          alaUneEvents.isEmpty?SizedBox.shrink(): CarouselSlider(
            items: alaUneEvents.map((event) => _alaUneCard(event)).toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              viewportFraction: 0.7,
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
  SliverToBoxAdapter _textSection(String text) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(text, style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            )),
          ),
        ],
      ),
    );
  }
  SliverList _buildVideSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => SizedBox.shrink(),
        childCount: 0,
      ),
    );
  }

  SliverList _buildGameStoriesSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => _gameStoryItem(_gameStories[index]),
        childCount: _gameStories.length,
      ),
    );
  }

  Widget _alaUneCard(EventData event) {
    return GestureDetector(
      onTap: () => _handleEventTap(event),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Stack(
          children: [
            buildMediaPreview(event, height: 250),
            buildEventOverlay(event),
          ],
        ),
      ),
    );
  }

  Widget _gameStoryItem(EventData event) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _handleEventTap(event),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildMediaPreview(event, height: 180),
            buildEventInfo(event),
          ],
        ),
      ),
    );
  }


  void _handleEventTap(EventData event) async {
    if (authController.userLogged.id == null) {
      showLoginRequiredDialog(context, () =>         Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),)));;
      return;
    }
    if(authController.userLogged.id!=null){
      if(!isIdInList(authController.userLogged.id!,event.usersVues==null?[]:event.usersVues!)){
        // authController.getEventById(event.id!).then((value) {
        //   if(value!.usersVues!=null){
        //     value!.usersVues!.add(authController.userLogged.id!);
        //     authController.updateEvent(value);
        //   }
        // },);
        // if(event.usersVues!=null){
        //   event.usersVues!.add(authController.userLogged.id!);
        //
        // }

      }
      // event.vue=event.vue!+1;
      // await authController.updateEvent(event).then((value) {
      //   setState(() {
      //
      //   });
      // },);

      goToPage(context, DetailsEventPage(event: event!));
    }else{
      showLoginRequiredDialog(context, () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

      },);
    }

    //
    // await authController.markEventViewed(event);
    // Get.to(DetailsEventPage(event: event));
  }
}