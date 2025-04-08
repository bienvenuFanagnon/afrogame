import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_models.dart';
import '../pages/share/messageView.dart';




class PostProvider extends GetxController {





  List<PostComment> listConstpostsComment = [];

  List<Message> usermessageList =[];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  Stream<NotificationData> getListNotification(String user_id) async* {
    var postStream = FirebaseFirestore.instance
        .collection('Notifications')
        .where("receiver_id", isEqualTo: user_id)
        .orderBy('created_at', descending: true)
        .limit(100)
        .snapshots();

    await for (var snapshot in postStream) {
      for (var post in snapshot.docs) {
        NotificationData notification = NotificationData.fromJson(post.data());

        // Récupérer les infos de l'utilisateur associé
        QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
            .collection('Users')
            .where("id", isEqualTo: notification.user_id)
            .get();

        List<UserData> userList = querySnapshotUser.docs.map((doc) {
          return UserData.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        if (userList.isNotEmpty) {
          notification.userData = userList.first;
        }

        // Émettre chaque notification dès qu'elle est prête
        yield notification;
      }
    }
  }




  Stream<List<NotificationData>> getListNotification2(String user_id) async* {
    var postStream = FirebaseFirestore.instance.collection('Notifications')
        .where("receiver_id",isEqualTo:'${user_id}')

        .orderBy('created_at', descending: true)
        .limit(100)

        .snapshots();
    List<NotificationData> notifications = [];
    // //listConstposts =[];
    //  UserData userData=UserData();

    await for (var snapshot in postStream) {
      notifications=[];

      for (var post in snapshot.docs) {
        //  printVm("post : ${jsonDecode(post.toString())}");
        NotificationData notification=NotificationData.fromJson(post.data());
        QuerySnapshot querySnapshotUser = await FirebaseFirestore.instance
            .collection('Users')
            .where("id", isEqualTo: '${notification.user_id}')
            .get();

        List<UserData> userList = querySnapshotUser.docs.map((doc) {
          return UserData.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        if (userList.isNotEmpty) {
          notification.userData = userList.first;
        }
        notifications.add(notification);
        // listConstposts=posts;


      }
      yield notifications;
    }
  }
  bool isIn(List<String> users_id, String userIdToCheck) {
    return users_id.any((item) => item == userIdToCheck);
  }



  Color colorFromHex(String? hexString) {
    if (hexString == null) return Colors.transparent;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }



  Future<List<PostComment>> getPostCommentsNoStream(EventData p) async{
    List<PostComment> postComment = [];
    listConstpostsComment = [];
    CollectionReference userCollect =
    FirebaseFirestore.instance.collection('PostComments');
    // Get docs from collection reference
    QuerySnapshot querySnapshotUser = await userCollect
        .where("post_id",isEqualTo:'${p.id}')
        .orderBy('created_at', descending: true)
        .get();

    // Afficher la liste
    listConstpostsComment = querySnapshotUser.docs.map((doc) =>
        PostComment.fromJson(doc.data() as Map<String, dynamic>)).toList();


    //  UserData userData=UserData();



    for (var postcmt in listConstpostsComment) {
      //  printVm("post : ${jsonDecode(post.toString())}");
      //PostComment pm=PostComment.fromJson(postcmt.data());
      CollectionReference friendCollect = await FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshotUser = await friendCollect.where("id",isEqualTo:'${postcmt.user_id}').get();
      // Afficher la liste


      List<UserData> userList = querySnapshotUser.docs.map((doc) =>
          UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();
      postcmt.user=userList.first;
      //postComment.add(pm);
      //listConstpostsComment.add(pm);


    }
    //notifyListeners();
    return listConstpostsComment;

  }


  Future<List<PostComment>> getPostComments(EventData p) async {

    CollectionReference postCollect = await FirebaseFirestore.instance.collection('PostComments');
    QuerySnapshot querySnapshotPost = await postCollect
        .where("post_id",isEqualTo:'${p.id}')
        .orderBy('created_at', descending: true)
        .get();

    List<PostComment> commentList = querySnapshotPost.docs.map((doc) =>
        PostComment.fromJson(doc.data() as Map<String, dynamic>)).toList();
    var postStream = FirebaseFirestore.instance.collection('PostComments')
        .where("post_id",isEqualTo:'${p.id}')
        .orderBy('created_at', descending: true)
        .snapshots();
    List<PostComment> postComment = [];
    listConstpostsComment = [];
    //  UserData userData=UserData();


    for (PostComment pm in commentList) {
      //  printVm("post : ${jsonDecode(post.toString())}");
      CollectionReference friendCollect = await FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshotUser = await friendCollect.where("id",isEqualTo:'${pm.user_id}').get();
      // Afficher la liste


      List<UserData> userList = querySnapshotUser.docs.map((doc) =>
          UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();
      pm.user=userList.first;
      postComment.add(pm);
      listConstpostsComment.add(pm);


    }
    return postComment;

  }

  Future<bool> updateMessage(Message message) async {
    try{



      await FirebaseFirestore.instance
          .collection('Messages')
          .doc(message.id)
          .update(message.toJson());
      //printVm("user update : ${user!.toJson()}");
      return true;
    }catch(e){
      printVm("erreur update message : ${e}");
      return false;
    }
  }


  Future<bool> newComment(PostComment comment) async {
    try{
      String cmtId = FirebaseFirestore.instance
          .collection('PostComments')
          .doc()
          .id;

      comment.id=cmtId;
      await FirebaseFirestore.instance
          .collection('PostComments')
          .doc(cmtId)
          .set(comment.toJson());
      return true;
    }catch(e){
      printVm("erreur comment : ${e}");
      return false;
    }
  }

  Future<bool> updateComment(PostComment comment) async {
    try{

      await FirebaseFirestore.instance
          .collection('PostComments')
          .doc(comment.id)
          .update(comment.toJson());
      // notifyListeners();
      return true;
    }catch(e){
      printVm("erreur comment : ${e}");
      return false;
    }
  }





}
