import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/authController.dart';
import '../../models/event_models.dart';
import '../share/LogoText.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.green),
        title: LogoText(),

      ),
      body: FutureBuilder<List<UserData>>(
        future: _authController.getUserById(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Utilisateur non trouvé'));
          }

          final user = snapshot.data!.first;
          return _buildProfileContent(user);
        },
      ),
    );
  }

  Widget _buildProfileContent(UserData user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(user),
          _buildStatsSection(user),
          const SizedBox(height: 20),
          _buildSubscribeButton(user),
          const SizedBox(height: 20),
// Dans votre écran de profil ou menu
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          onPressed: () => _confirmLogout(),
          icon: const Icon(Icons.logout, size: 20),
          label: const Text('Déconnexion',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

// Fonction de confirmation


// Dans AuthController
        ],
      ),
    );
  }
  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Confirmer la déconnexion',
      titleStyle: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold),
      content: const Text('Voulez-vous vraiment vous déconnecter ?'),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
        ),
        onPressed: () async {
          logout();
        },
        child: const Text('Oui', style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Non'),
      ),
    );
  }
  Future<void> logout() async {
    try {
      // Suppression du token et des données utilisateur
      await FirebaseAuth.instance.signOut();
      await SharedPreferences.getInstance().then((prefs) {
        prefs.remove('token');
        // prefs.remove('userId');
      });
      _authController.userLogged=UserData();
      Navigator.pop(context);
      Navigator.pop(context);


      Get.snackbar(
        'Déconnexion réussie',
        'À bientôt sur Afrogame !',
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de la déconnexion: ${e.toString()}');
    }
  }

  Widget _buildProfileHeader(UserData user) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[800]!, Colors.green[400]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              GestureDetector(
                onTap: _editProfileImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.urlImage != null
                          ? CachedNetworkImageProvider(user.urlImage!)
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.pseudo ?? '${user.prenom} ${user.nom}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (user.isVerify == true)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.verified, color: Colors.white, size: 20),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(UserData user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Abonnés', user.userabonnements?.length.toString() ?? '0'),
          _buildStatItem('Note', user.note?.toStringAsFixed(1) ?? '0.0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscribeButton(UserData user) {
    final isSubscribed = user.userabonnements?.contains(_authController.userLogged?.id) ?? false;


      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubscribed ? Colors.grey : Colors.green[800],
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => _toggleSubscription(user),
        child: Text(
          isSubscribed ? 'Abonné' : 'S\'abonner',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  }

  void _toggleSubscription(UserData user) async {
    final currentUserId = _authController.userLogged?.id;
    if (currentUserId == null) return;

    final updatedSubscriptions = List<String>.from(user.userabonnements ?? []);
    if (updatedSubscriptions.contains(currentUserId)) {
      updatedSubscriptions.remove(currentUserId);
    } else {
      updatedSubscriptions.add(currentUserId);
    }

    final updatedUser = user..userabonnements = updatedSubscriptions;
    final success = await _authController.updateUser(updatedUser);

    if (success) {
      setState(() {

      });
      Get.snackbar(
        'Succès',
        updatedSubscriptions.contains(currentUserId)
            ? 'Abonnement réussi !'
            : 'Désabonnement effectué',
        backgroundColor: Colors.green[100],
      );
    }
  }

  void _editProfileImage() {
    // Implémenter la logique de modification d'image
  }

  void _editProfileInfo(UserData user) {
    final pseudoController = TextEditingController(text: user.pseudo);

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pseudoController,
              decoration: InputDecoration(
                labelText: 'Pseudo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.green[800]),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
              ),
              onPressed: () async {
                final updatedUser = user..pseudo = pseudoController.text;
                final success = await _authController.updateUser(updatedUser);
                if (success) {
                  Get.back();
                  Get.snackbar('Succès', 'Profil mis à jour');
                }
              },
              child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}