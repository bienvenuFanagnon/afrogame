import 'dart:async';
import 'dart:math';

import 'package:afroevent/controllers/authController.dart';
import 'package:afroevent/models/event_models.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertagger/fluttertagger.dart';
import 'package:get/get.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/postProvider.dart';
import '../../controllers/userProvider.dart';
import '../Widgets/constColors.dart';
import '../Widgets/hashtag/textHashTag/views/view_models/search_view_model.dart';
import '../Widgets/hashtag/textHashTag/views/widgets/comment_text_field.dart';
import '../Widgets/hashtag/textHashTag/views/widgets/search_result_overlay.dart';
import '../Widgets/sizeText.dart';
import '../Widgets/textwidget.dart';
import '../share/LogoText.dart';
import '../share/messageView.dart';


class EventComments extends StatefulWidget {
  final EventData post;
  const EventComments({super.key, required this.post});

  @override
  State<EventComments> createState() => _EventCommentsState();
}

class _EventCommentsState extends State<EventComments> with TickerProviderStateMixin{
  String token = '';
  bool dejaVuPub = true;

  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();
  GlobalKey btnKey4 = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthController authProvider = Get.find();
  late UserProvider userProvider =Get.find();
  int imageIndex = 0;
  PostComment commentSelectedToReply = PostComment();
  late PostProvider postProviders =Get.find();
  TextEditingController commentController = TextEditingController();
  String formaterDateTime2(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Si la date est aujourd'hui, afficher seulement l'heure et la minute
      return DateFormat.Hm().format(dateTime);
    } else {
      // Sinon, afficher la date complète
      return DateFormat.yMd().add_Hms().format(dateTime);
    }
  }

  String formaterDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays < 1) {
      // Si c'est le même jour
      if (difference.inHours < 1) {
        // Si moins d'une heure
        if (difference.inMinutes < 1) {
          return "publié il y a quelques secondes";
        } else {
          return "publié il y a ${difference.inMinutes} minutes";
        }
      } else {
        return "publié il y a ${difference.inHours} heures";
      }
    } else if (difference.inDays < 7) {
      // Si la semaine n'est pas passée
      return "publié ${difference.inDays} jours plus tôt";
    } else {
      // Si le jour est passé
      return "publié depuis ${DateFormat('dd MMMM yyyy').format(dateTime)}";
    }
  }


  _showCommentMenuModalDialog(PostComment postComment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Menu'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
      
                Visibility(
                  visible: postComment.user!.id == authProvider.userLogged.id||authProvider.userLogged.role == UserRole.ADM.name,
                  child: ListTile(
                    onTap: () async {
                      if (authProvider.userLogged.role == UserRole.ADM.name) {
                        postComment.status = PostStatus.SUPPRIMER.name;
                        await postProviders.updateComment(postComment).then(
                              (value) {
                            if (value) {
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'commentaire supprimé !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {

                              });
                            } else {
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'échec !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        );
                      } else
                        if (postComment.user!.id == authProvider.userLogged.id) {
                          postComment.status = PostStatus.SUPPRIMER.name;
                          await postProviders.updateComment(postComment).then(
                                (value) {
                              if (value) {
                                SnackBar snackBar = SnackBar(
                                  content: Text(
                                    'commentaire supprimé !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                setState(() {

                                });
                              } else {
                                SnackBar snackBar = SnackBar(
                                  content: Text(
                                    'échec !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          );
                        }


                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: authProvider.userLogged.role == UserRole.ADM.name
                        // ? Text('Bloquer')
                        ? Text('Supprimer')
                        : Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showResponseCommentMenuModalDialog(PostComment postComment,ResponsePostComment response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Menu'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Visibility(
                //   visible: postComment.user!.id != authProvider.userLogged.id,
                //   child: ListTile(
                //     onTap: () async {
                //       postComment.status = PostStatus.SIGNALER.name;
                //       await postProviders.updateComment(postComment).then(
                //             (value) {
                //           if (value) {
                //             SnackBar snackBar = SnackBar(
                //               content: Text(
                //                 'Post signalé !',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(color: Colors.green),
                //               ),
                //             );
                //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //           } else {
                //             SnackBar snackBar = SnackBar(
                //               content: Text(
                //                 'échec !',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(color: Colors.red),
                //               ),
                //             );
                //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //           }
                //           Navigator.pop(context);
                //         },
                //       );
                //       setState(() {});
                //     },
                //     leading: Icon(
                //       Icons.flag,
                //       color: Colors.blueGrey,
                //     ),
                //     title: Text(
                //       'Signaler',
                //     ),
                //   ),
                // ),
                /*
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.edit,color: Colors.blue,),
                  title: Text('Modifier'),
                ),

                 */
                Visibility(
                  visible: postComment.user!.id == authProvider.userLogged.id||authProvider.userLogged.role == UserRole.ADM.name,
                  child: ListTile(
                    onTap: () async {
                      if (authProvider.userLogged.role == UserRole.ADM.name) {
                        response.status = PostStatus.SUPPRIMER.name;
                     int indexResponse=   postComment.responseComments!.indexOf(response);
                        postComment.responseComments!.elementAt(indexResponse).status= PostStatus.SUPPRIMER.name;


                        await postProviders.updateComment(postComment).then(
                              (value) {
                            if (value) {
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'commentaire supprimé !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'échec !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        );
                      } else
                      if (postComment.user!.id == authProvider.userLogged.id) {
                        response.status = PostStatus.SUPPRIMER.name;
                        int indexResponse=   postComment.responseComments!.indexOf(response);
                        // postComment.responseComments![indexResponse]=response;
                        postComment.responseComments!.elementAt(indexResponse).status= PostStatus.SUPPRIMER.name;

                        await postProviders.updateComment(postComment).then(
                              (value) {
                            if (value) {
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'commentaire supprimé !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'échec !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        );
                      }


                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: authProvider.userLogged.role == UserRole.ADM.name
                    // ? Text('Bloquer')
                        ? Text('Supprimer')
                        : Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }







  late bool replying = false;
  late UserData commentRecever = UserData();
  late String replyingTo = '';
  late String replyUser_pseudo = '';
  late String replyUser_id = '';
  //late List<Widget> actions;
  late TextEditingController _textController = TextEditingController();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  bool sendMessageTap = false;
  double siveBoxLastmessage = 10;
  String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return "${number / 1000} k";
    } else if (number < 1000000000) {
      return "${number / 1000000} m";
    } else {
      return "${number / 1000000000} b";
    }
  }

  late AnimationController _animationController;
  late Animation<Offset> _animation;

  double overlayHeight = 380;

  // late final homeViewModel = HomeViewModel();
  late final _controller = FlutterTaggerController(
    //Initial text value with tag is formatted internally
    //following the construction of FlutterTaggerController.
    //After this controller is constructed, if you
    //wish to update its text value with raw tag string,
    //call (_controller.formatTags) after that.
    text:
    "",
  );
  late final _focusNode = FocusNode();

  void _focusListener() {
    if (!_focusNode.hasFocus) {
      _controller.dismissOverlay();
    }
  }
  // ScrollController _controller = ScrollController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Declare
  FlutterListViewController fluttercontroller = FlutterListViewController();
  // FocusNode _focusNode = FocusNode();
  Widget commentAndResponseListWidget(
      List<PostComment> pcms,
      double width,
      double height,
      ) {
    return SingleChildScrollView(
      child: Column(
        children: pcms.map((pcm) {
          return CommentTreeWidget<PostComment, ResponsePostComment>(
            pcm,
            pcm.responseComments!,
            treeThemeData: TreeThemeData(
              lineColor: Colors.green, // Ligne entre parent et enfant
              lineWidth: 2,
            ),
            avatarRoot: (context, data) => PreferredSize(
              preferredSize: Size.fromRadius(18),
              child: GestureDetector(
                onTap: () async {
                  await  authProvider.getUserById(data.user!.id!).then((users) async {
                    if(users.isNotEmpty){
                      // showUserDetailsModalDialog(users.first, width, height,context);

                    }
                  },);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(data.user!.urlImage ?? ''),
                  onBackgroundImageError: (_, __) => AssetImage('assets/images/404.png'),
                ),
              ),
            ),
            contentRoot: (context, data) => _buildCommentContent(data, width, height),
            avatarChild: (context, data) => PreferredSize(
              preferredSize: Size.fromRadius(18),
              child: GestureDetector(
                onTap: () async {
                  await  authProvider.getUserById(data.user_id!).then((users) async {
                    if(users.isNotEmpty){
                      //showUserDetailsModalDialog(users.first, width, height,context);

                    }
                  },);
                },
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: NetworkImage(data.user_logo_url ?? ''),
                ),
              ),
            ),
            contentChild: (context, data) => _buildReplyContent(pcm,data, width, height),
          );
        }).toList(),
      ),
    );
  }

  /// **Widget pour afficher un commentaire principal**
  Widget _buildCommentContent(PostComment pcm, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 2,
                children: [
                  Text("@${pcm.user!.pseudo!}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Visibility(
                    visible: pcm.user!.isVerify!,
                    child: Card(
                      child: const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: width*0.5, // Définir la largeur maximale souhaitée
                  ),
                  child: HashTagText(

                    text: "${pcm.status==PostStatus.SUPPRIMER.name?"Supprimé":pcm.message}",
                    decoratedStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,

                      color: Colors.green,
                      fontFamily: 'Nunito', // Définir la police Nunito
                    ),
                    basicStyle: TextStyle(
                      fontSize: SizeText.homeProfileTextSize,
                      color: pcm.status==PostStatus.SUPPRIMER.name?Colors.red:ConstColors.textColors,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Nunito', // Définir la police Nunito
                    ),
                    textAlign: TextAlign.left, // Centrage du texte
                    maxLines: null, // Permet d'afficher le texte sur plusieurs lignes si nécessaire
                    softWrap: true, // Assure que le texte se découpe sur plusieurs lignes si nécessaire
                    // overflow: TextOverflow.ellipsis, // Ajoute une ellipse si le texte dépasse
                    onTap: (text) {
                      _handleTagClick(text,width,height);
                    },
                    decorateAtSign: true,

                  ),
                ),
              ),
              // HashTagText(
              //   text: pcm.status == PostStatus.SUPPRIMER.name ? "Supprimé" : pcm.message!,
              //   decoratedStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
              //   basicStyle: TextStyle(color: Colors.black),
              //   onTap: (text) => _handleTagClick(text),
              // ),
              Text(
                "${formaterDateTime(DateTime.fromMicrosecondsSinceEpoch(pcm.createdAt!))}",
                style: TextStyle(fontSize: 1, color: Colors.grey),
              ),
            ],
          ),
          IconButton(onPressed: () {
            setState(() {
              commentSelectedToReply = PostComment();
              commentSelectedToReply = pcm;
              commentRecever=commentSelectedToReply.user!;

              replyUser_id=commentSelectedToReply.user!.id!;
              replyUser_pseudo=commentSelectedToReply.user!.pseudo!;

              replyingTo = "@${commentSelectedToReply.user!.pseudo}";
              replying = true;
            });


          }, icon: Icon(Icons.reply_all,color: Colors.green,size: 15,)),
          IconButton(onPressed: () {
            setState(() {

              _showCommentMenuModalDialog(pcm);

            });


          }, icon: Icon(Icons.more_horiz,color: Colors.green,size: 15,)),

        ],
      ),
    );
  }

  /// **Widget pour afficher une réponse à un commentaire**
  Widget _buildReplyContent(PostComment pcm,ResponsePostComment rpc, double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("@${rpc.user_pseudo}", style: TextStyle(fontWeight: FontWeight.bold)),
              // HashTagText(
              //   text: rpc.status == PostStatus.SUPPRIMER.name ? "Supprimé" : rpc.message!,
              //   decoratedStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
              //   basicStyle: TextStyle(color: Colors.black),
              //   onTap: (text) => _handleTagClick(text),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: width*0.45, // Définir la largeur maximale souhaitée
                  ),
                  child: HashTagText(

                    text: "➡️ ${rpc.user_reply_pseudo??''} ${rpc.status==PostStatus.SUPPRIMER.name?"Supprimé":rpc.message}",
                    decoratedStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,

                      color: Colors.green,
                      fontFamily: 'Nunito', // Définir la police Nunito
                    ),
                    basicStyle: TextStyle(
                      fontSize: SizeText.homeProfileTextSize,
                      color: rpc.status==PostStatus.SUPPRIMER.name?Colors.red:ConstColors.textColors,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Nunito', // Définir la police Nunito
                    ),
                    textAlign: TextAlign.left, // Centrage du texte
                    maxLines: null, // Permet d'afficher le texte sur plusieurs lignes si nécessaire
                    softWrap: true, // Assure que le texte se découpe sur plusieurs lignes si nécessaire
                    // overflow: TextOverflow.ellipsis, // Ajoute une ellipse si le texte dépasse
                    onTap: (text) {
                      _handleTagClick(text,width,height);
                    },
                    decorateAtSign: true,

                  ),
                ),
              ),
              Text(
                "${formaterDateTime(DateTime.fromMicrosecondsSinceEpoch(rpc.createdAt!))}",
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
          IconButton(onPressed: () {
            printVm("****** response pcm selected");

            setState(() {
              // printVm("****** response pcm **** : ${pcm.toJson()}");

              commentSelectedToReply = PostComment();
              commentSelectedToReply = pcm;
              commentRecever=pcm.user!;

              printVm('rpc data ${rpc.toJson()}');
              replyUser_id=rpc.user_id!;
              replyUser_pseudo=pcm.user!.pseudo!;

              replyingTo = "@${rpc!.user_pseudo}";
              replying = true;
            });


          }, icon: Icon(Icons.reply_all,color: Colors.green,size: 14,)),
          IconButton(onPressed: () {

            _showResponseCommentMenuModalDialog(pcm,rpc);



          }, icon: Icon(Icons.more_horiz,color: Colors.green,size: 14,)),

        ],
      ),
    );
  }

  /// **Fonction pour gérer les interactions avec les hashtags et mentions**
  Future<void> _handleTagClick(String text,double width, height) async {
    print("Tag cliqué: ${text.replaceFirst('@', '')}");
if(users.isNotEmpty){
  var user= users.firstWhere((element) => element.pseudo==text.replaceFirst('@', ''),);
  if(user!=null){
    await  authProvider.getUserById(user.id!).then((users) async {
      if(users.isNotEmpty){
        // showUserDetailsModalDialog(users.first, width, height,context);

      }
    },);
  }
}

    // Recherchez l'utilisateur associé et affichez les détails si nécessaire
  }

List<UserData> users=[];
  @override
  void initState() {
    userProvider.getAllUsers().then((users2) {
      users=users2;
    },);
    super.initState();
    _focusNode.addListener(_focusListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var insets = MediaQuery.of(context).viewInsets;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: LogoText(),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,


        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

            Container(
              child: StatefulBuilder(builder:
                      (BuildContext context, StateSetter setStateImages) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                                Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: IconButton(onPressed: () {
                          //
                          //   }, icon: Icon(Icons.arrow_back_sharp,color: Colors.green,)),
                          // ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '${widget.post.user!.urlImage!}'),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      SizedBox(
                                        //width: 100,
                                        child: TextCustomerUserTitle(
                                          titre:
                                          "@${widget.post.user!.pseudo!}",
                                          fontSize: SizeText
                                              .homeProfileTextSize,
                                          couleur:
                                          ConstColors.textColors,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextCustomerUserTitle(
                                        titre:
                                        "${widget.post.user!.userabonnements!.length} abonné(s)",
                                        fontSize: SizeText
                                            .homeProfileTextSize,
                                        couleur: ConstColors.textColors,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                // _showPostMenuModalDialog(widget.post);
                              },
                              icon: Icon(
                                Icons.more_horiz,
                                size: 30,
                                color: ConstColors.blackIconColors,
                              )),
                        ],
                      ),


                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: width * 0.9,
                                  height: 80,
                                  child:          InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: () {

                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: TextCustomerPostDescription(
                                        titre: "${widget.post.description}",
                                        fontSize: SizeText.homeProfileTextSize,
                                        couleur: ConstColors.textColors,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextCustomerPostDescription(
                                  titre:
                                      "${formaterDateTime(DateTime.fromMicrosecondsSinceEpoch(widget.post.createdAt!))}",
                                  fontSize: SizeText.homeProfileDateTextSize,
                                  couleur: ConstColors.textColors,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Provider<PostProvider>(
                                create: (context) => PostProvider(),
                                child: SizedBox(
                                  height:height * 0.45,
                                  width: width,
                                  child: FutureBuilder<List<PostComment>>(
                                      future: postProviders
                                          .getPostCommentsNoStream(
                                          widget.post),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          List<PostComment> listcmt =snapshot.data! as List<PostComment>;
                                          widget.post.commentaire=listcmt.length;
                                          authProvider.updateEvent(widget.post);
                                          return commentAndResponseListWidget(
                                              snapshot.data!,
                                              width,height);
                                        } else if (snapshot.hasError) {
                                          return Icon(Icons.error_outline);
                                        } else {
                                          return Center(child: Container( width: 50, height: 50, child: CircularProgressIndicator()));
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
            ),
          ]),
        ),
      ),

      bottomNavigationBar: FlutterTagger(
        controller: _controller,
        animationController: _animationController,
        onSearch: (query, triggerChar) {
          if (triggerChar == "@") {
            searchViewModel.searchUser(query,users);
          }
          if (triggerChar == "#") {
            searchViewModel.searchHashtag(query);
          }
        },
        triggerCharacterAndStyles: const {
          "@": TextStyle(color: Colors.pinkAccent),
          "#": TextStyle(color: Colors.green),
        },
        tagTextFormatter: (id, tag, triggerCharacter) {
          return "$triggerCharacter$id#$tag#";
        },
        overlayHeight: overlayHeight,
        overlay: SearchResultOverlay(
          animation: _animation,
          tagController: _controller,
        ),
        builder: (context, containerKey) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (replying && replyingTo != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.reply, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Réponse à ${replyingTo!}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            replying = false;
                            replyingTo = "";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              CommentTextField(
                focusNode: _focusNode,
                containerKey: containerKey,
                insets: insets,
                controller: _controller,
                onSend: () async {
                  printVm("***************send comment;");
                  setState(() {
                    sendMessageTap = true;

                  });

                  String textComment=_controller.text;
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                  List<UserData> userNames=[];
                  List<String> userOneSignalIds=[];

                  if (textComment.isNotEmpty) {
                    // _controller.text="";
                    if (replying) {

                      printVm("****** reply ++++response sended user id **** : ${replyUser_id}");
                      printVm('monetisation reply 1');

                      ResponsePostComment comment =
                      ResponsePostComment(user_id: authProvider.userLogged!.id);
                      comment.user_id =
                          authProvider.userLogged!.id;
                      comment.user_logo_url =
                          authProvider.userLogged!.urlImage;
                      comment.user_pseudo =
                          authProvider.userLogged!.pseudo;
                      comment.post_comment_id =
                          commentSelectedToReply.id;
                      comment.user_reply_pseudo = replyingTo;

                      comment.message =
                          textComment;
                      comment.createdAt = DateTime.now()
                          .microsecondsSinceEpoch;
                      comment.updatedAt = DateTime.now()
                          .microsecondsSinceEpoch;
                      commentSelectedToReply
                          .responseComments!
                          .add(comment);
                      postProviders
                          .updateComment(
                          commentSelectedToReply)
                          .then(
                            (value) async {
                          if (value) {
                            // _textController.text = "";
                            printVm("****** response sended user id **** : ${replyUser_id}");
                            widget.post.commentaire =
                                widget.post.commentaire! + 1;


                            // CollectionReference userCollect =
                            // FirebaseFirestore.instance.collection('Users');
                            // // Get docs from collection reference
                            // QuerySnapshot querySnapshotUser = await userCollect.where("id",isEqualTo: widget.post.user!.id!).get();
                            // // Afficher la liste
                            // List<UserData>  listUsers = querySnapshotUser.docs.map((doc) =>
                            //     UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();
                            // if (listUsers.isNotEmpty) {
                            //
                            //   listUsers.first!.commentaire=listUsers.first!.comments!+1;
                            //   postProviders.updatePost(widget.post, listUsers.first!!,context);
                            //   await authProvider.getAppData();
                            //   authProvider.appDefaultData.nbr_comments=authProvider.appDefaultData.nbr_comments!+1;
                            //   authProvider.updateAppData(authProvider.appDefaultData);
                            // }
                            // else{
                            //   widget.post.user!.comments=widget.post.user!.comments!+1;
                            //   postProviders.updatePost(widget.post,widget.post.user!,context);
                            //   await authProvider.getAppData();
                            //
                            //   authProvider.appDefaultData.nbr_comments=authProvider.appDefaultData.nbr_comments!+1;
                            //   authProvider.updateAppData(authProvider.appDefaultData);
                            // }
                            // await authProvider.getUserById(replyUser_id).then(
                            //       (users) async {
                            //     if(users.isNotEmpty){
                            //
                            //       UserData receiver = users.first;
                            //       printVm("****** response sended user **** : ${receiver.toJson()}");
                            //       NotificationData notif=NotificationData();
                            //       notif.id=firestore
                            //           .collection('Notifications')
                            //           .doc()
                            //           .id;
                            //       notif.titre="Commentaire 💬";
                            //       notif.media_url=authProvider.userLogged.imageUrl;
                            //       notif.type=NotificationType.POST.name;
                            //       notif.description="@${authProvider.userLogged.pseudo!} a repondu à votre commentaire 💬";
                            //       notif.users_id_view=[];
                            //       notif.user_id=authProvider.userLogged.id;
                            //       notif.receiver_id=receiver!.id!;
                            //       notif.post_id=widget.post!.id!;
                            //       notif.post_data_type=PostDataType.COMMENT.name!;
                            //
                            //       notif.updatedAt =
                            //           DateTime.now().microsecondsSinceEpoch;
                            //       notif.createdAt =
                            //           DateTime.now().microsecondsSinceEpoch;
                            //       notif.status = PostStatus.VALIDE.name;
                            //
                            //       // users.add(pseudo.toJson());
                            //
                            //       await firestore.collection('Notifications').doc(notif.id).set(notif.toJson());
                            //
                            //       await authProvider.sendNotification(
                            //           userIds: [receiver!.oneIgnalUserid!],
                            //           smallImage: "${authProvider.userLogged.imageUrl!}",
                            //           send_user_id: "${authProvider.userLogged.id!}",
                            //           recever_user_id: "${receiver!.id!}",
                            //           message: "📢 @${authProvider.userLogged.pseudo!} a repondu à votre commentaire 💬",
                            //           type_notif: NotificationType.POST.name,
                            //           post_id: "${widget.post!.id!}",
                            //           post_type: PostDataType.COMMENT.name, chat_id: ''
                            //       );
                            //       // Expression régulière pour trouver les noms commençant par @
                            //       RegExp regExp = RegExp(r'@\w+');
                            //
                            //       // Trouver toutes les correspondances
                            //       Iterable<Match> matches = regExp.allMatches(textComment);
                            //
                            //       // Extraire les noms trouvés
                            //       List<String> usernames = matches.map((match) => match.group(0)!).toList();
                            //
                            //
                            //       // Afficher les noms trouvés
                            //       if(usernames.isNotEmpty){
                            //         usernames.forEach((username) {
                            //           print("username @ : ${username}");
                            //           var user= users.firstWhere((element) => element.pseudo!.contains(username.replaceFirst('@', '')),);
                            //           userNames.add(user);
                            //           userOneSignalIds.add(user.oneIgnalUserid!);
                            //         });
                            //
                            //         await authProvider.sendNotification(
                            //             userIds: userOneSignalIds,
                            //             smallImage: "${authProvider.userLogged.imageUrl!}",
                            //             send_user_id: "${authProvider.userLogged.id!}",
                            //             recever_user_id: "",
                            //             message: "📢 @${authProvider.userLogged.pseudo!} a parlé de vous dans un look ! !💬",
                            //             type_notif: NotificationType.POST.name,
                            //             post_id: "${widget.post!.id!}",
                            //             post_type: PostDataType.COMMENT.name, chat_id: ''
                            //         );
                            //         userNames.forEach((user) async {
                            //
                            //           NotificationData notif2=NotificationData();
                            //           notif.id=firestore
                            //               .collection('Notifications')
                            //               .doc()
                            //               .id;
                            //           notif.titre="Tagué 💬";
                            //           notif.media_url=authProvider.userLogged.imageUrl;
                            //           notif.type=NotificationType.POST.name;
                            //           notif.description="@${authProvider.userLogged.pseudo!} a parlé de vous dans un look !💬";
                            //           notif.users_id_view=[];
                            //           notif.user_id=authProvider.userLogged.id;
                            //           notif.receiver_id=user!.id!;
                            //           notif.post_id=widget.post!.id!;
                            //           notif.post_data_type=PostDataType.COMMENT.name!;
                            //
                            //           notif.updatedAt =
                            //               DateTime.now().microsecondsSinceEpoch;
                            //           notif.createdAt =
                            //               DateTime.now().microsecondsSinceEpoch;
                            //           notif.status = PostStatus.VALIDE.name;
                            //
                            //           // users.add(pseudo.toJson());
                            //
                            //           await firestore.collection('Notifications').doc(notif2.id).set(notif2.toJson());
                            //
                            //
                            //         });
                            //       }
                            //
                            //
                            //
                            //     }
                            //   },
                            // );
                            await authProvider.updateEvent(widget.post);
                            sendMessageTap = false;

                            // _focusNode.unfocus();
                            _textController.text = "";

                            setState(() {
                              replying = false;
                            });
                          } else {
                            printVm(
                                "erreru sender response");

                            sendMessageTap = false;
                          }

                          sendMessageTap = false;
                        },
                      );

                    } else {
                      printVm('monetisation 2');
                      PostComment comment = PostComment();
                      comment.user_id =
                          authProvider.userLogged.id;
                      comment.user =
                          authProvider.userLogged;
                      comment.post_id = widget.post.id;
                      comment.users_like_id = [];
                      comment.responseComments = [];
                      comment.message =
                          textComment;
                      comment.loves = 0;
                      comment.likes = 0;
                      comment.comments = 0;
                      comment.createdAt = DateTime.now()
                          .microsecondsSinceEpoch;
                      comment.updatedAt = DateTime.now()
                          .microsecondsSinceEpoch;

                   await   postProviders.newComment(comment).then(
                            (value) async {
                          if (value) {

                            widget.post.commentaire =
                                widget.post.commentaire! + 1;
                           await authProvider.updateEvent(widget.post);




                            await authProvider.sendNotification(
                                userIds: [widget.post.user!.oneIgnalUserid!],
                                smallImage: "${authProvider.userLogged.urlImage!}",
                                send_user_id: "${authProvider.userLogged.id!}",
                                recever_user_id: "",
                                message: "📢 @${authProvider.userLogged.pseudo!} a commenté 💬 votre post",
                                type_notif: NotificationType.COMMENT.name,
                                post_id: "${widget.post!.id!}",
                                // post_type: PostDataType.COMMENT.name,
                                // chat_id: ''
                            );

                            NotificationData notif=NotificationData();
                            notif.id=firestore
                                .collection('Notifications')
                                .doc()
                                .id;
                            notif.titre="Commentaire 💬";
                            notif.media_url=authProvider.userLogged.urlImage;
                            notif.type=NotificationType.POST.name;
                            notif.description="@${authProvider.userLogged.pseudo!} a commenté 💬 votre look";
                            notif.users_id_view=[];
                            notif.user_id=authProvider.userLogged.id;
                            notif.receiver_id=widget.post!.user!.id!;
                            notif.post_id=widget.post!.id!;
                            notif.post_data_type=PostDataType.COMMENT.name!;

                            notif.updatedAt =
                                DateTime.now().microsecondsSinceEpoch;
                            notif.createdAt =
                                DateTime.now().microsecondsSinceEpoch;
                            notif.status = PostStatus.VALIDE.name;

                            // users.add(pseudo.toJson());

                            await firestore.collection('Notifications').doc(notif.id).set(notif.toJson());


                            _textController.text = "";
                            printVm("commment envoyer");
                            _focusNode.unfocus();
                            postProviders.listConstpostsComment
                                .add(comment);

                            postProviders.listConstpostsComment
                                .sort((a, b) => b
                                .createdAt!
                                .compareTo(
                                a.createdAt!));

                            // Expression régulière pour trouver les noms commençant par @
                            RegExp regExp = RegExp(r'@\w+');

                            // Trouver toutes les correspondances
                            Iterable<Match> matches = regExp.allMatches(textComment);

                            // Extraire les noms trouvés
                            List<String> usernames = matches.map((match) => match.group(0)!).toList();

                            // Afficher les noms trouvés
                            if(usernames.isNotEmpty){
                              usernames.forEach((username) {
                                print("username @ : ${username}");
                                var user= users.firstWhere((element) => element.pseudo!.contains(username.replaceFirst('@', '')),);
                                userNames.add(user);
                                userOneSignalIds.add(user.oneIgnalUserid!);
                              });

                              await authProvider.sendNotification(
                                  userIds: userOneSignalIds,
                                  smallImage: "${authProvider.userLogged.urlImage!}",
                                  send_user_id: "${authProvider.userLogged.id!}",
                                  recever_user_id: "",
                                  message: "📢 @${authProvider.userLogged.pseudo!} a parlé de vous dans un look ! !💬",
                                  type_notif: NotificationType.COMMENT.name,
                                  post_id: "${widget.post!.id!}",
                                  // post_type: PostDataType.COMMENT.name, chat_id: ''
                              );
                              if(userNames.isNotEmpty){
                                for(var user in userNames){
                                  NotificationData notif2=NotificationData();
                                  notif.id=firestore
                                      .collection('Notifications')
                                      .doc()
                                      .id;
                                  notif.titre="Tagué 💬";
                                  notif.media_url=authProvider.userLogged.urlImage;
                                  notif.type=NotificationType.POST.name;
                                  notif.description="@${authProvider.userLogged.pseudo!} a parlé de vous dans un look !💬";
                                  notif.users_id_view=[];
                                  notif.user_id=authProvider.userLogged.id;
                                  notif.receiver_id=user!.id!;
                                  notif.post_id=widget.post!.id!;
                                  notif.post_data_type=PostDataType.COMMENT.name!;

                                  notif.updatedAt =
                                      DateTime.now().microsecondsSinceEpoch;
                                  notif.createdAt =
                                      DateTime.now().microsecondsSinceEpoch;
                                  notif.status = PostStatus.VALIDE.name;

                                  // users.add(pseudo.toJson());

                                  await firestore.collection('Notifications').doc(notif2.id).set(notif2.toJson());

                                }

                              }
                              // userNames.forEach((user) async {
                              //
                              //
                              //
                              // });
                            }





                            sendMessageTap = false;

                            _focusNode.unfocus();

                          } else {
                            printVm("erreru commment");

                            sendMessageTap = false;
                          }

                          sendMessageTap = false;
                        },
                      );

                    }
                  }
                  setState(() {
                    sendMessageTap = false;

                  });

                  // _controller.clear();
                },
              ),
            ],
          );
        },
      ),

    );
  }
}
