import 'package:afroevent/controllers/postProvider.dart';
import 'package:afroevent/pages/home.dart';
import 'package:afroevent/pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'controllers/authController.dart';
import 'controllers/userProvider.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Activate app check after initialization, but before
  // usage of any Firebase services.

  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("3ac647fc-cc81-49eb-9d6e-70a4aaa45fd8");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  // updateApiHeader();
  Get.put(AuthController());
  Get.put(UserProvider());
  Get.put(PostProvider());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green, // Couleur principale : Vert (pour l'AppBar)
        scaffoldBackgroundColor: Colors.white, // Fond : Blanc

        // appBarTheme: AppBarTheme(
        //   backgroundColor: Colors.green, // Header/AppBar : Vert
        //   iconTheme: IconThemeData(color: Colors.white), // Icônes de l'AppBar : Blanc
        //   titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Titre de l'AppBar
        // ),
        // buttonTheme: ButtonThemeData(
        //   buttonColor: Colors.green, // Boutons : Vert
        //   textTheme: ButtonTextTheme.primary,
        // ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     // primary: Colors.green, // Boutons surélevés : Vert
        //     // onPrimary: Colors.white, // Texte des boutons : Blanc
        //   ),
        // ),
        // iconTheme: IconThemeData(
        //   color: Colors.green, // Icônes générales : Vert
        // ),
        // textButtonTheme: TextButtonThemeData(
        //   style: TextButton.styleFrom(
        //     backgroundColor: Colors.green, // Texte des boutons (TextButton) : Vert
        //   ),
        // ),
        // floatingActionButtonTheme: FloatingActionButtonThemeData(
        //   backgroundColor: Colors.green, // Bouton flottant : Vert
        // ),
      ),
      home: SplashScreen(),
    );
  }
}


