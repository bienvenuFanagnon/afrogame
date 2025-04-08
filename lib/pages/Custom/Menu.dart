import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/authController.dart';
import '../contact/contactPage.dart';
import '../share/navPage.dart';
import '../user/profil.dart';

class CustomDrawer extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildProfileHeader(context),
            _buildMenuItems(context),
            _buildAppFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(authController.userLogged.urlImage!=null){
          goToPage(context, ProfilePage(userId: authController.userLogged.id!));

        }

      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF068A00),
              Color(0xFFECA505),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,

                  borderRadius: BorderRadius.all(Radius.circular(200))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      authController.userLogged.urlImage!=null ? authController.userLogged.urlImage! : "https://via.placeholder.com/150",
                  )
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              authController.userLogged?.pseudo ?? 'Invité',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              authController.userLogged?.email ?? 'Connectez-vous pour plus de fonctionnalités',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            if (authController.userLogged != null)
              Row(
                children: [
                  Icon(Icons.verified, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Membre VIP',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String pseudo) {
    return pseudo.isNotEmpty
        ? pseudo.trim().split(' ').map((l) => l[0]).take(2).join()
        : '??';
  }

  Widget _buildMenuItems(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.contact_support,
            title: 'Nous contacter',
            color: Color(0xFF2575FC),
            onTap: () => _contactUs(context),
          ),
          _buildMenuItem(
            icon: Icons.share,
            title: 'Partager l\'appli',
            color: Color(0xFF6A11CB),
            onTap: () => _shareApp(context),
          ),
          if (authController.userLogged != null)
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Déconnexion',
              color: Colors.redAccent,
              onTap: () {

              },
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required Function() onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: color.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey[300]),
          SizedBox(height: 15),
          Text(
            '228sportZ v2.0.1',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Votre communauté sportive au Togo',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _contactUs(BuildContext context) {
    Navigator.pop(context);
    Get.to(() => ContactPage());
  }

  void _shareApp(BuildContext context) {
    final appLink = 'https://228sportz.tg';
    Share.share(
      'Rejoins la communauté sportive togolaise sur 228sportZ ! 🏆\n$appLink',
      subject: 'Découvre 228sportZ',
    );
  }
}