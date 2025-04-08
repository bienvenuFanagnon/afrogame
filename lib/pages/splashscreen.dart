import 'dart:async';
import 'package:afroevent/pages/share/messageView.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/authController.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  AuthController authController=Get.find();
  late Animation<double> _scaleAnimation;

  int app_version_code=5;
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  checkUser() async {

  await  authController.getAppData().then((appdata) async {
      if (app_version_code== appdata.app_version) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        printVm("user token:  ${prefs.getString("token")}");

        if(prefs.getString("token")!=null){

            await  authController.getUserById(prefs.getString("token")!).then((users) {
              if(users.isNotEmpty){
                authController.userLogged=users.first;
                // printVm("user logged:  ${authController.userLogged.toJson()}");
              }
            },);

        }
        goToPage(context, HomePage(),withReplace: true);


      }else{
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info,color: Colors.red,),
                      Text(
                        'Nouvelle mise à jour disponible!',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Une nouvelle version de l\'application est disponible. Veuillez télécharger la mise à jour pour profiter des dernières fonctionnalités et améliorations.',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          _launchUrl(Uri.parse('${appdata.app_link}'));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Ionicons.ios_logo_google_playstore,color: Colors.white,),
                            SizedBox(width: 5,),
                            Text('Télécharger sur le play store',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

      }

    },);


  }


  @override
  void initState() {
    super.initState();

    // // Contrôleur pour la rotation
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 2), // Durée d'une rotation
    // )..repeat(); // Répète l'animation en boucle

    // Initialisation de l'AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Durée totale de l'animation
      vsync: this,
    )..repeat(reverse: true); // Répète l'animation avec effet "reverse"

    // Création d'une animation de mise à l'échelle
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    // Timer pour naviguer après 3 secondes

    Timer(const Duration(seconds: 2), () {
checkUser();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF055588), // Couleur de fond
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Image.asset('assets/afrogame_logo_rbg.png'), // Remplacez avec votre image
        ),
      ),

    );
  }
}



