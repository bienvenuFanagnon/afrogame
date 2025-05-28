import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/operation_model.dart';

class CreationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Championnat> championnats = <Championnat>[].obs;
  final RxString selectedChampionnatId = ''.obs;
  final RxBool isCreatingChampionnat = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChampionnats();
  }

  Future<void> loadChampionnats() async {
    // try {
    //   final snapshot = await _firestore.collection('championnats').get();
    //   championnats.value = snapshot.docs
    //       .map((doc) => Championnat.fromJson(doc.data()..['id'] = doc.id))
    //       .toList();
    // } catch (e) {
    //   Get.snackbar('Erreur', 'Impossible de charger les championnats');
    // }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('championnats/${DateTime.now().microsecondsSinceEpoch}');
      await ref.putData(await image.readAsBytes());
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de l\'upload de l\'image');
      return null;
    }
  }

  Future<void> createChampionnat({
    required String nom,
    XFile? logo,
  }) async {
    try {
      final nomNettoye = nom.trim();

      // Vérification existence
      final existant = await _firestore.collection('championnats')
          .where('titre', isEqualTo: nomNettoye)
          .get();

      if (existant.docs.isNotEmpty) {
        throw 'Un championnat avec ce nom existe déjà';
      }

      String? logoUrl;
      if (logo != null) {
        logoUrl = await _uploadImage(logo);
      }

      final championnat = Championnat(
        titre: nomNettoye,
        logoUrl: logoUrl,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        updatedAt: DateTime.now().microsecondsSinceEpoch,
      );

      // await _firestore.collection('championnats').add(championnat.toJson());
      await loadChampionnats();
      Get.back();
      Get.snackbar('Succès', 'Championnat créé');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<void> createSaison({
    required String nom,
    required int dateDebut,
    required int dateFin,
  }) async {
    try {
      if (selectedChampionnatId.isEmpty) {
        throw 'Veuillez sélectionner un championnat';
      }

      // final saison = Saison(
      //   championnatId: selectedChampionnatId.value,
      //   nom: nom.trim(),
      //   dateDebut: dateDebut,
      //   dateFin: dateFin,
      //   createdAt: DateTime.now().microsecondsSinceEpoch,
      //   updatedAt: DateTime.now().microsecondsSinceEpoch,
      // );
      //
      // await _firestore.collection('saisons').add(saison.toJson());
      // Get.back();
      // Get.snackbar('Succès', 'Saison créée');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }
}