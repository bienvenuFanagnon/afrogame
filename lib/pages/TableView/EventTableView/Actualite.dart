import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/authController.dart';
import '../../../../models/event_models.dart';
import '../../auth/login.dart';
import '../../details/eventDetail.dart';
import '../../share/DateWidget.dart';
import '../../share/EventWidgetView.dart';
import '../../share/FonctionWidget.dart';
import '../../share/messageRequireWidget.dart';
import '../../share/messageView.dart';
import '../../share/navPage.dart';

class ActualitePage extends StatefulWidget {
  final String sousCategorie;
  ActualitePage(this.sousCategorie);
  @override
  _ActualitePageState createState() => _ActualitePageState();
}

class _ActualitePageState extends State<ActualitePage> {
  final AuthController authController = Get.find();
  final StreamController<List<EventData>> _streamController = StreamController<List<EventData>>();

  @override
  void initState() {
    super.initState();
  }

  void _loadInitialData() {
    authController.getEventDatasImagesByCatAndTypeJeu(100,widget.sousCategorie,"ACTUALITE").listen((data) {
      _streamController.add(data);
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadInitialData();

    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async{
        _loadInitialData();

      },
      child: Scaffold(
        body: StreamBuilder<List<EventData>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement'));
            }
            final events = snapshot.data ?? [];
            // final gbovianEvents = events.where((e) => e.typeJeu == TypeJeu.GAMESTORY.name).toList();
            // final eventsDatas = events.where((e) => e.typeJeu == TypeJeu.GAMESTORY.name&&e.sousCategorie == 'Basket').toList();

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('Actualités'),
                  floating: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final event = events[index];
                      return _buildEventCard(event, size);
                    },
                    childCount: events.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventCard(EventData event, Size size) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section média (image/vidéo)
          _buildMediaSection(event, size),

          // Contenu de l'événement
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.titre!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 4),
                    DateWidget(dateInMicroseconds: event.date!),
                    Spacer(),
                    Icon(Icons.people_alt, size: 16),
                    SizedBox(width: 4),
                    Text('${0}'),
                  ],
                ),
              ],
            ),
          ),

          // Barre d'actions
          _buildActionBar(event),
        ],
      ),
    );
  }

  Widget _buildMediaSection(EventData event, Size size) {
    return GestureDetector(
      onTap: () async {
        if(authController.userLogged.id!=null){
          // if(!isIdInList(authController.userLogged.id!,event.usersVues==null?[]:event.usersVues!)){
          //
          //   if(event.usersVues!=null){
          //     event.usersVues!.add(authController.userLogged.id!);
          //
          //   }
          //
          // }
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

      },
      child: Container(
          height: size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
      child: event.medias.isNotEmpty
      ? buildMediaPreview(event, height: 250)
          : Placeholder(),
      ),
    );
    }

  Widget _buildActionBar(EventData event) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.favorite ,
            count: event.like!,
            // color:  Colors.red ,
            onPressed: () => _toggleLike(event),
          ),
          _buildActionButton(
            icon: Icons.comment,
            count: event.commentaire??0,
            onPressed: () => _showComments(event),
          ),
          _buildActionButton(
            icon: Icons.visibility,
            count: event.vue!,
            onPressed: () {},
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareEvent(event),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    Color? color,
    required Function() onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: color ?? Colors.grey[600]),
      label: Text('$count', style: TextStyle(color: Colors.grey[600])),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Future<void> _toggleLike(EventData event) async {
    if(authController.userLogged.id!=null){
      if(!isIdInList(authController.userLogged.id!,event.userslikes== null?[]:event.userslikes!)){
        if(event.userslikes!=null){
          event.userslikes!.add(authController.userLogged.id!);

        }
        event.like=event.like!+1;
        await authController.updateEvent(event);
        setState(() {

        });
      }

    }else {
      showLoginRequiredDialog(context, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));
      },);
    }
    // authController.toggleEventLike(event.id!);
    // setState(() {
    //   event.isLiked = !event.isLiked;
    //   event.like += event.isLiked ? 1 : -1;
    // });
  }

  void _showComments(EventData event) {
    if(authController.userLogged.id!=null){
      // if(!isIdInList(authController.userLogged.id!,event.usersVues==null?[]:event.usersVues!)){
      //
      //   if(event.usersVues!=null){
      //     event.usersVues!.add(authController.userLogged.id!);
      //
      //   }
      //
      // }
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
    }   }

  void _shareEvent(EventData event) {
    if(authController.userLogged.id!=null){
      // if(!isIdInList(authController.userLogged.id!,event.usersVues==null?[]:event.usersVues!)){
      //
      //   if(event.usersVues!=null){
      //     event.usersVues!.add(authController.userLogged.id!);
      //
      //   }
      //
      // }
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
  }
}