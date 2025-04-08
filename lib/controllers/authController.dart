import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/event_models.dart';
import '../pages/share/messageView.dart';

class AuthController extends GetxController {

  UserData userLogged=UserData();
  UserData registerUser=UserData();
  Future<bool> updateUser(UserData user) async {
    try{
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.id)
          .update(user.toJson());
      printVm("user update : ${user!.toJson()}");
      return true;
    }catch(e){
      printVm("erreur update post : ${e}");
      return false;
    }
  }

  Future<bool> updateEvent(EventData event) async {
    try{
      await FirebaseFirestore.instance
          .collection('EventData')
          .doc(event.id)
          .update(event.toJson());
      printVm("event update : ${event!.toJson()}");
      return true;
    }catch(e){
      printVm("erreur update event : ${e}");
      return false;
    }
  }
  Future<AppDefaultData> getAppData() async {

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection =
    FirebaseFirestore.instance.collection('AppData');
    AppDefaultData appData=AppDefaultData();
    try {
      // Obtenir les documents de la collection
      QuerySnapshot querySnapshot = await collection.get();

      // Vérifier s'il y a des documents
      if (querySnapshot.docs.isNotEmpty) {
        // Récupérer le premier document
        DocumentSnapshot premierDocument = querySnapshot.docs.first;
        appData=AppDefaultData.fromJson(premierDocument.data() as Map<String, dynamic>);

      } else {
        AppDefaultData appData=AppDefaultData();
        String id = firestore
            .collection('AppData')
            .doc()
            .id;
        appData.id =id;
        printVm("La collection est vide");
        await firestore.collection('AppData').doc(appData.id).set(appData.toJson()).then((value) {
          printVm('new app data');
        },);


      }
    } catch (e) {
      printVm("Erreur lors de la récupération du premier document : $e");

    }
    return appData;

  }


  Future<List<UserData>> getUserById(String id) async {
    //await getAppData();
    late List<UserData> list = [];
    late bool haveData = false;

    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('Users');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.where(
        "id", isEqualTo: id!).get()
        .then((value) {
      printVm(value);
      return value;
    }).catchError((onError) {

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();

    if(list.isNotEmpty){
      list.first.oneIgnalUserid=OneSignal.User.pushSubscription.id;
      updateUser( list.first);
    }


    return list;
  }
  Future<List<UserData>> getUsers() async {
    //await getAppData();
    late List<UserData> list = [];
    late bool haveData = false;

    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('Users');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get()
        .then((value) {
      printVm(value);
      return value;
    }).catchError((onError) {

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();

    if(list.isNotEmpty){
      list.first.oneIgnalUserid=OneSignal.User.pushSubscription.id;
      updateUser( list.first);
    }


    return list;
  }

  Future<void> sendNotification({required List<String> userIds,
    required String smallImage,
    required String send_user_id,
    required String recever_user_id,
    required String message,
    required String type_notif,
    required String post_id}) async {

    String oneSignalUrl = '';
    String applogo = '';
    String oneSignalAppId = ''; // Replace with your app ID
    String oneSignalAuthorization = ''; // Replace with your authorization key
    getAppData().then((app_data) async {

      printVm(
          'app  data*** ');
      printVm(app_data.toJson());
      oneSignalUrl = app_data.one_signal_app_url;
      applogo = app_data.app_logo;
      oneSignalAppId = app_data.one_signal_app_id; // Replace with your app ID
      oneSignalAuthorization = app_data.one_signal_api_key; // Replace with your authorization key
      printVm(
          'one signal url*** ');
      printVm(oneSignalUrl);
      printVm(
          'state current user data  ================================================');

      printVm(OneSignal.User.pushSubscription.id);
      final body = {
        'contents': {'en': message},
        'app_id': oneSignalAppId,

        "include_player_ids":
        // "include_subscription_ids":
        userIds, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon":smallImage.length>5?smallImage: applogo,

        "large_icon": smallImage.length>5?smallImage: applogo,

        "headings": {"en": "228SportZ"},
        //"included_segments": ["Active Users", "Inactive Users"],
        // "custom_data": {"order_id": 123, "currency": "USD", "amount": 25},
        "data": {"send_user_id": "${send_user_id}","recever_user_id": "${recever_user_id}", "type_notif": "${type_notif}", "post_id": "${post_id}","post_type": "","chat_id": ""},
        'name': '228SportZ',
      };

      final response = await http.post(
        Uri.parse(oneSignalUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Basic $oneSignalAuthorization",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        printVm('Notification sent successfully!');
        printVm('sending notification: ${response.body}');
      } else {
        printVm('Error sending notification: ${response.statusCode}');
        printVm('Error sending notification: ${response.body}');
      }
      // final body = {
      //   'contents': {'en': message},
      //   'app_id': oneSignalAppId,
      //
      //   "include_player_ids":
      //   // "include_subscription_ids":
      //   userIds, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.
      //
      //   // android_accent_color reprsent the color of the heading text in the notifiction
      //   "android_accent_color": "FF9976D2",
      //
      //   "small_icon": applogo,
      //
      //   "large_icon": applogo,
      //
      //   "headings": {"en": "konami"},
      //   //"included_segments": ["Active Users", "Inactive Users"],
      //   "data": {"foo": "bar"},
      //   'name': 'konami',
      //   'custom_data': {'order_id': 123, 'Prix': '500 fcfa'},
      // };
      //
      // final response = await http.post(
      //   Uri.parse(oneSignalUrl),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': "Basic $oneSignalAuthorization",
      //   },
      //   body: jsonEncode(body),
      // );
      //
      // if (response.statusCode == 200) {
      //   printVm('Notification sent successfully!');
      //   printVm('sending notification: ${response.body}');
      //   return true;
      // } else {
      //   printVm('Error sending notification: ${response.statusCode}');
      //   printVm('Error sending notification: ${response.body}');
      //   return false;
      //
      // }

    },);


    //printVm(OneSignal.User.pushSubscription.id);


  }

  Stream<List<EventData>> getEventDatasImages(int limite) async* {
    List<EventData> posts = [];

    try{
      // listConstposts = [];
      DateTime afterDate = DateTime(2024, 11, 06); // Date de référence
      CollectionReference postCollect = FirebaseFirestore.instance.collection('EventData');
      int todayTimestamp = DateTime.now().microsecondsSinceEpoch;

// Début de la journée actuelle (minuit)
      int startOfDay = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).microsecondsSinceEpoch;

// Fin de la journée actuelle (23:59:59)
      int endOfDay = startOfDay + Duration(hours: 23, minutes: 59, seconds: 59).inMicroseconds;
      // 1. Récupérer les publications de la journée
      Query queryToday = postCollect
      //     .where(
      //     "typeJeu", isEqualTo: '${MediaType.photo.name}'
      // )
      // .where("status", isNotEqualTo: EventDataStatus.SUPPRIMER.name)
          .where("createdAt", isGreaterThanOrEqualTo: startOfDay)
          .where("createdAt", isLessThanOrEqualTo: endOfDay)
          .where("statut", isNotEqualTo: EventStatus.supprimer.name)
          .orderBy('createdAt', descending: true)
      // .orderBy('updated_at', descending: true)
          .limit(limite);

// 2. Récupérer les publications restantes
      Query queryOthers = postCollect
      //     .where(
      //     "typeJeu", isEqualTo: '${Ty.name}'
      //
      // )
      // .where("status", isNotEqualTo: EventDataStatus.SUPPRIMER.name)
          .where("createdAt", isLessThan: startOfDay)
          .where("statut", isNotEqualTo: EventStatus.supprimer.name)
          .orderBy('updatedAt', descending: true)
          .limit(limite);

      List<DocumentSnapshot> todayEventDatas = (await queryToday.get()).docs;
      List<DocumentSnapshot> otherEventDatas = (await queryOthers.get()).docs;

      // Combiner les résultats
      List<DocumentSnapshot> querySnapshotEventDatas = [...todayEventDatas, ...otherEventDatas];
      printVm("niveau d execusion 1");
      printVm("todayEventDatas : ${todayEventDatas.length}");
      printVm("otherEventDatas : ${otherEventDatas.length}");

      // QuerySnapshot querySnapshotEventData = await query.get();

      // QuerySnapshot querySnapshotEventData = await query.get();

      // List<EventData> postList = querySnapshotEventData.docs.map((doc) {
      //   EventData post = EventData.fromJson(doc.data() as Map<String, dynamic>);
      //   return post;
      // }).where((post) =>
      // post.status != EventDataStatus.NONVALIDE.name &&
      //     post.status != EventDataStatus.SUPPRIMER.name).toList();

      // Traiter les documents progressivement
      // for (var doc in querySnapshotEventData.docs) {
      for (var doc in querySnapshotEventDatas) {
        printVm("niveau d execusion 2");

        EventData post = EventData.fromJson(doc.data() as Map<String, dynamic>);
        printVm("niveau d execusion 2");

        // Filtrer selon le statut
        // if (post.status != EventDataStatus.NONVALIDE.name &&
        //     post.status != EventDataStatus.SUPPRIMER.name) {
        // Récupérer les données utilisateur liées
        QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
            .collection('Users')
            .where("id", isEqualTo: '${post.userId}')
            .get();

        List<UserData> userList = querySnapshotUser.docs.map((doc) {
          return UserData.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        if (userList.isNotEmpty) {
          post.user = userList.first;
          // printVm("post event: ${post.toJson()}");
        }

        // Ajouter le post à la liste
        posts.add(post);
        // listConstposts.add(post);
        // Transmettre les données partiellement récupérées
        yield posts;
        //}
      }
    }catch(e){
      printVm("erreu catch ${e}");
      yield posts;

    }


  }

  Stream<List<EventData>> getEventDatasImagesByTypeJeu(int limite, String typeJeu) async* {
    List<EventData> posts = [];

    try {
      DateTime now = DateTime.now();

      // Calcul des limites du mois courant
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999, 999);

      int startOfMonthMicro = startOfMonth.microsecondsSinceEpoch;
      int endOfMonthMicro = endOfMonth.microsecondsSinceEpoch;

      CollectionReference postCollect = FirebaseFirestore.instance.collection('EventData');

      // 1. Événements du mois courant triés par création
      Query queryCurrentMonth = postCollect
          .where("createdAt", isGreaterThanOrEqualTo: startOfMonthMicro)
          .where("createdAt", isLessThanOrEqualTo: endOfMonthMicro)
          .where("typeJeu", isEqualTo: typeJeu)
          .where("statut", isNotEqualTo: EventStatus.supprimer.name)
          .orderBy('createdAt', descending: true)
          .limit(limite);

      // 2. Événements des autres mois (triés par mise à jour puis mélangés)
      Query queryOtherMonths = postCollect
          .where("createdAt", isLessThan: startOfMonthMicro)
          .where("typeJeu", isEqualTo: typeJeu)
          .where("statut", isNotEqualTo: EventStatus.supprimer.name)
          .orderBy('updatedAt', descending: true)
          .limit(limite);

      List<DocumentSnapshot> currentMonthEvents = (await queryCurrentMonth.get()).docs;
      List<DocumentSnapshot> otherMonthsEvents = (await queryOtherMonths.get()).docs;

      // Mélanger les événements des autres mois
      otherMonthsEvents.shuffle();

      // Combinaison des résultats
      List<DocumentSnapshot> allEvents = [...currentMonthEvents, ...otherMonthsEvents];

      for (var doc in allEvents) {
        EventData post = EventData.fromJson(doc.data() as Map<String, dynamic>);

        // Récupération des données utilisateur
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where("id", isEqualTo: post.userId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          post.user = UserData.fromJson(userSnapshot.docs.first.data() as Map<String, dynamic>);
        }

        posts.add(post);
        yield posts;
      }
    } catch (e) {
      print("Erreur: $e");
      yield posts;
    }
  }
  Stream<List<EventData>> getEventDatasImagesByCatAndTypeJeu(int limite,String souscategorie, String typeJeu) async* {
    List<EventData> posts = [];

    try {
      DateTime now = DateTime.now();

      // Calcul des limites du mois courant
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999, 999);

      int startOfMonthMicro = startOfMonth.microsecondsSinceEpoch;
      int endOfMonthMicro = endOfMonth.microsecondsSinceEpoch;

      CollectionReference postCollect = FirebaseFirestore.instance.collection('EventData');

      // 1. Événements du mois courant triés par création
      Query queryCurrentMonth = postCollect
          .where("createdAt", isGreaterThanOrEqualTo: startOfMonthMicro)
          .where("createdAt", isLessThanOrEqualTo: endOfMonthMicro)
          .where("typeJeu", isEqualTo: typeJeu)
          .where("sousCategorie", isEqualTo: souscategorie)
          .where("statut", isNotEqualTo: EventStatus.supprimer.name)
          .orderBy('createdAt', descending: true)
          .limit(limite);

      // 2. Événements des autres mois (triés par mise à jour puis mélangés)
      Query queryOtherMonths = postCollect
          .where("createdAt", isLessThan: startOfMonthMicro)
          .where("typeJeu", isEqualTo: typeJeu)
          .where("sousCategorie", isEqualTo: souscategorie)
          .where("statut", isNotEqualTo: EventStatus.supprimer.name)
          .orderBy('updatedAt', descending: true)
          .limit(limite);

      List<DocumentSnapshot> currentMonthEvents = (await queryCurrentMonth.get()).docs;
      List<DocumentSnapshot> otherMonthsEvents = (await queryOtherMonths.get()).docs;

      // Mélanger les événements des autres mois
      otherMonthsEvents.shuffle();

      // Combinaison des résultats
      List<DocumentSnapshot> allEvents = [...currentMonthEvents, ...otherMonthsEvents];

      for (var doc in allEvents) {
        EventData post = EventData.fromJson(doc.data() as Map<String, dynamic>);

        // Récupération des données utilisateur
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where("id", isEqualTo: post.userId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          post.user = UserData.fromJson(userSnapshot.docs.first.data() as Map<String, dynamic>);
        }

        posts.add(post);
        yield posts;
      }
    } catch (e) {
      print("Erreur: $e");
      yield posts;
    }
  }


  Future<EventData?> getEventById(String eventId) async {
    try {
      // Récupérer le document par son ID
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('EventData')
          .doc(eventId)
          .get();

      if (!eventSnapshot.exists) {
        printVm("Aucun événement trouvé avec l'ID: $eventId");
        return null;
      }

      // Convertir le document en EventData
      EventData event = EventData.fromJson(eventSnapshot.data() as Map<String, dynamic>);

      // Récupérer les données utilisateur associées
      if (event.userId != null) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where("id", isEqualTo: event.userId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          event.user = UserData.fromJson(userSnapshot.docs.first.data() as Map<String, dynamic>);
        }
      }

      return event;

    } catch (e) {
      printVm("Erreur lors de la récupération de l'événement: ${e}");
      return null;
    }
  }
}