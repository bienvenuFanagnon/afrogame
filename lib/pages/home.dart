
import 'package:afroevent/models/event_models.dart';
import 'package:afroevent/pages/accueil.dart';
import 'package:afroevent/pages/share/ButtonWidget.dart';
import 'package:afroevent/pages/share/LogoText.dart';
import 'package:afroevent/pages/share/messageRequireWidget.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../controllers/authController.dart';
import 'Custom/Menu.dart';
import 'TableView/EventFilList.dart';
import 'TableView/otherEvent.dart';
import 'auth/login.dart';
import 'new/newEvent.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen
  AuthController authController=Get.find();

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  // Liste des widgets correspondant à chaque page
  final List<Widget> pages = [
    Center(child: AccueilPage()),
    Center(child: EventFilListPage("Basket")),
    // Center(child: EventFilListPage("Football")),
    // Center(child: EventFilListPage("Handball")),
    Center(child: EventFilListPage("Karate")),
    // Center(child: EventFilListPage("Volleyball")),
    Center(child: EventFilListPage("Tennis")),
  ];
  final iconList = <IconData>[
    Entypo.home,            // Accueil
    // Ionicons.football,      // Football
    Ionicons.basketball,    // Basket
    // MaterialIcons.sports_handball, // Handball (approximatif)
    MaterialCommunityIcons.karate, // Karate
    // MaterialIcons.sports_volleyball,   // Volleyball
    MaterialIcons.sports_tennis,       // Tennis
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LogoText(),
        leading: Builder( // Wrap avec Builder
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Maintenant le contexte est bon
              },
            );
          },
        ),

        actions: [
          Visibility(
            visible: authController.userLogged.id!=null&& authController.userLogged.role==UserRole.ADM.name? true:false,
            child: IconButton(
              onPressed: () {
                if(authController.userLogged.id!=null){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventPage(),));

                }else{

                  showLoginRequiredDialog(context, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

                  },);

                }

              },
              icon: Icon(color: Colors.redAccent,Ionicons.ios_add_circle),
              //params
            ),
          ),
          IconButton(onPressed: () {
setState(() {

});
          }, icon: Icon(Icons.notifications_active,color: Colors.green,)),
        ],
      ),
      body: IndexedStack(
        index: _bottomNavIndex, // Affiche la page correspondant à l'index actuel
        children: pages,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EventFilListPage("Football"),));

          // if(authController.userLogged.id!=null){
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventPage(),));
          //
          // }else{
          //
          //   showLoginRequiredDialog(context, () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => EventFilListPage("Football"),));
          //
          //   },);
          //
          // }

        },
        child: Icon(color: Colors.white,Ionicons.football),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        iconSize: 30,
        activeColor: Colors.green,
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 0, // ✅ corrigé ici
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}