import 'package:afroevent/models/event_models.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:afroevent/pages/user/profil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserProfileWidget extends StatelessWidget {
  final UserData user;
  final double avatarSize;
  final double textSize;
  final double iconSize;

  const UserProfileWidget({
    Key? key,
    required this.user,

    this.avatarSize = 30.0,
    this.textSize = 20.0,
    this.iconSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          goToPage(context, ProfilePage(userId: user.id!));
        },
        child: Row(
          children: [
            // Avatar circulaire
            user.urlImage!=null? CircleAvatar(
              radius: avatarSize,
              backgroundImage: NetworkImage(
                user.urlImage!=null ? user.urlImage! : "https://via.placeholder.com/150",
              ),
            ):Icon((Icons.person)),
            const SizedBox(width: 5),
            // Informations utilisateur
            Text(
              '@${user.pseudo!=null ? user.pseudo! : ""}',
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
