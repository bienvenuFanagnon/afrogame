

import 'dart:async';


import 'package:afroevent/pages/TableView/EventTableView/Actualite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authController.dart';
import '../../models/event_models.dart';
import '../share/EventWidgetView.dart';
import '../share/messageView.dart';
import 'EventTableView/Evenement.dart';
import 'EventTableView/GameStory.dart';

class EventFilListPage extends StatefulWidget {
  final String sousCategorie;
  EventFilListPage(this.sousCategorie);
  @override
  _EventFilListPageState createState() => _EventFilListPageState();
}

class _EventFilListPageState extends State<EventFilListPage> {
  AuthController authController=Get.find();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async {

      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,

            title: TabBar(
              tabs: [
                Tab(text: 'Événements'),
                Tab(text: 'Actualités'),
                Tab(text: 'Game Story'),
              ],
            ),
          ),
          body: TabBarView(
            children: [

              Center(child: EvenementPage(widget.sousCategorie)), // Page pour le basket-ball
              Center(child: ActualitePage(widget.sousCategorie)), // Page pour le basket-ball
              Center(child:GameStoryPage(widget.sousCategorie)
              ), // Page pour le basket-ball
            ],
          ),
        ),
      ),
    );
  }
}

