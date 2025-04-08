import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_models.dart';
import '../pages/share/messageView.dart';




class UserProvider extends GetxController {

  late int countFriends=0;
  late int countInvitations=0;
  late int mes_msg_non_lu=0;
  late List<UserData> listUsers = [];

  late List<UserData> listUserAnnonces = [];
  late List<UserData> listAllUsers = [];

  late List<String> alphabet = [];
  List<Message> usermessageList =[];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  setMessageNonLu(int nbr){
    mes_msg_non_lu=nbr;
  }

  Future<bool> updateUser(UserData user) async {
    try{



      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.id)
          .update(user.toJson());
      //printVm("user update : ${user!.toJson()}");
      return true;
    }catch(e){
      printVm("erreur update post : ${e}");
      return false;
    }
  }


  // Future<bool> sendSimpleMessage({required Message message,required String receiver_id,required String sender_id}) async {
  //   bool resp=false;
  //
  //   if(await userService.sendSimpleMessage( message: message, receiver_id: receiver_id, sender_id: sender_id,)){
  //     //registerText= ResponseText.registerSuccess;
  //     resp=true;
  //   }else{
  //     //registerText= ResponseText.registerErreur;
  //     resp=false;
  //   }
  //   notifyListeners();
  //   return resp;
  // }

  Future<bool> getUsers(String currentUserId,BuildContext context) async {

    listUsers = [];
    bool hasData=false;
    try{
      CollectionReference userCollect =
      FirebaseFirestore.instance.collection('Users');
      // Get docs from collection reference
      QuerySnapshot querySnapshotUser = await userCollect
      // .where("id",isNotEqualTo: currentUserId)
          .orderBy('popularite', descending: true)
          .limit(30)
          .get();

      // Afficher la liste
      listUsers = querySnapshotUser.docs.map((doc) =>
          UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();

      printVm('list users ${listUsers.length}');
      hasData=true;

    }catch(e){
      printVm("erreur ${e}");
      hasData=false;
    }



    //notifyListeners();
    return hasData;
  }

  Future<List<UserData>> getAllUsers() async {

    listAllUsers = [];
    bool hasData=false;
    try{
      CollectionReference userCollect =
      FirebaseFirestore.instance.collection('Users');
      // Get docs from collection reference
      QuerySnapshot querySnapshotUser = await userCollect
      // .where("id",isNotEqualTo: currentUserId)
      //     .orderBy('point_contribution', descending: true)
          .orderBy('popularite', descending: true)
          .limit(10)
          .get();

      // Afficher la liste
      listAllUsers = querySnapshotUser.docs.map((doc) =>
          UserData.fromJson(doc.data() as Map<String, dynamic>)).toList();


      // for(UserData user in listAllUsers){
      //   user.abonnes=user.userAbonnesIds==null?0:user.userAbonnesIds!.length;
      //   updateUser(user);
      //
      //
      // }


      //   printVm('list users ${listAllUsers.length}');
      hasData=true;
      return listAllUsers;
    }catch(e){
      printVm("erreur ${e}");
      hasData=false;
      return [];
    }

  }



}
