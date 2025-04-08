

import 'package:flutter/material.dart';

class OtherEventsPage extends StatefulWidget {
  @override
  _OtherEventsPageState createState() => _OtherEventsPageState();
}

class _OtherEventsPageState extends State<OtherEventsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: 'Gbovian'),
              Tab(text: 'Match'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Container(child: Text("Fetes"),)), // Page pour le basket-ball
            Center(child: Container(child: Text("evenement"),)), // Page pour le basket-ball
          ],
        ),
      ),
    );
  }
}

