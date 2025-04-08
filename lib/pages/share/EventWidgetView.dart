import 'dart:typed_data';

import 'package:afroevent/controllers/authController.dart';
import 'package:afroevent/pages/details/eventDetail.dart';
import 'package:afroevent/pages/share/DateWidget.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:afroevent/pages/share/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';
import 'package:get/get.dart';

import '../../models/event_models.dart';
import '../auth/login.dart';
import 'FonctionWidget.dart';
import 'messageRequireWidget.dart';

class EventCard extends StatefulWidget {
  final EventData event;
  final UserData user;

  const EventCard({Key? key, required this.event, required this.user}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  AuthController authController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du titre avec coins arrondis
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                UserProfileWidget(user: widget.event.user!,avatarSize: 20,iconSize: 12,textSize: 12,),

                GestureDetector(
                        onTap: () async {
                          if(authController.userLogged.id!=null){
                            if(!isIdInList(widget.user.id!,widget.event.usersVues==null?[]:widget.event.usersVues!)){
                              if(widget.event.usersVues!=null){
                                widget.event.usersVues!.add(widget.user.id!);

                              }

                            }
                            widget.event.vue=widget.event.vue!+1;
                            await authController.updateEvent(widget.event).then((value) {
                              setState(() {

                              });
                            },);

                            goToPage(context, DetailsEventPage(event: widget.event!));
                          }else{
                            showLoginRequiredDialog(context, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

                            },);
                          }

                  },
                  child: Column(
                    children: [
                      Text(
                        widget.event.titre!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Image du poste
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.event.urlMedia!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Description
                      Text(
                        widget.event.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Date et icônes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Date
                          DateWidget(dateInMicroseconds: widget.event.date!),
                          Row(
                            children: [
                              // Icône vues
                              Row(
                                children: [
                                  const Icon(Icons.visibility, size: 16),
                                  const SizedBox(width: 4),
                                  Text(widget.event.vue.toString()),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // Icône likes
                              GestureDetector(
                                onTap: () async {

                                  if(authController.userLogged.id!=null){
                                    if(!isIdInList(widget.user.id!,widget.event.userslikes== null?[]:widget.event.userslikes!)){
                                      if(widget.event.userslikes!=null){
                                        widget.event.userslikes!.add(widget.user.id!);

                                      }
                                      widget.event.like=widget.event.like!+1;
                                      await authController.updateEvent(widget.event);
                                      setState(() {

                                      });
                                    }

                                  }else{
                                    showLoginRequiredDialog(context, () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

                                    },);
                                  }

                                },
                                child: Row(
                                  children: [
                                     Icon(Icons.thumb_up, size: 16,color:isIdInList(widget.user.id!,widget.event.userslikes==null?[]:widget.event.userslikes!!)? Colors.green:Colors.black,),
                                    const SizedBox(width: 4),
                                    Text(widget.event.like.toString()),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Icône commentaires
                              Row(
                                children: [
                                  const Icon(Icons.comment, size: 16),
                                  const SizedBox(width: 4),
                                  Text(widget.event.commentaire.toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}



Widget buildMediaPreview(EventData event, {required double height}) {
  final media = event.medias?.firstWhere(
        (m) => m['type'] == 'image',
    orElse: () => event.medias?.first ?? {},
  );

  if (media?['type'] == 'image') {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.network(
        media!['url']!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => buildVideoPreview(event, height),
      ),
    );
  }
  return buildVideoPreview(event, height);
}

Widget buildVideoPreview(EventData event, double height) {
  final video = event.medias?.firstWhere(
        (m) => m['type'] == 'video',
    orElse: () => {},
  );

  if (video?.isEmpty ?? true) return SizedBox.shrink();

  return FutureBuilder<Uint8List?>(
    future: FlutterVideoThumbnailPlus.thumbnailData(
      video: video!['url']!,
      imageFormat: ImageFormat.jpeg,
      maxWidth: 300,
    ),
    builder: (context, snapshot) {
      return       GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsEventPage(event: event),));
        },
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            image: snapshot.hasData
                ? DecorationImage(
                image: MemoryImage(snapshot.data!),
                fit: BoxFit.cover)
                : null,
          ),
          child: Center(
            child: Icon(Icons.play_circle_filled,
                size: 50,
                color: Colors.white.withOpacity(0.8)),
          ),
        ),
      );
    },
  );
}
final Color primaryColor = Color(0xFF2E7D32);
final Color accentColor = Color(0xFF81C784);
Widget buildEventOverlay(EventData event) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.titre ?? '',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, color: accentColor, size: 16),
              SizedBox(width: 8),
              DateWidget(dateInMicroseconds: event.date!),
              Spacer(),
              Icon(Icons.visibility, color: accentColor, size: 16),
              SizedBox(width: 4),
              Text('${event.vue}',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildEventInfo(EventData event) {
  return Padding(
    padding: EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(event.titre ?? '',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor)),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.sports, color: accentColor, size: 16),
            SizedBox(width: 8),
            Text(event.sousCategorie ?? '',
                style: TextStyle(color: Colors.grey[700])),
            Spacer(),
            DateWidget(dateInMicroseconds: event.date!),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, color: accentColor, size: 16),
            SizedBox(width: 8),
            Expanded(child: Text('${event.ville}, ${event.pays}',
                style: TextStyle(color: Colors.grey[700]))),
            Icon(Icons.visibility, color: accentColor, size: 16),
            SizedBox(width: 4),
            Text('${event.vue}', style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ],
    ),
  );
}


class EventMenuModal extends StatefulWidget {
  final EventData event;

  EventMenuModal({super.key, required this.event});

  @override
  State<EventMenuModal> createState() => _EventMenuModalState();
}

class _EventMenuModalState extends State<EventMenuModal> {
  final AuthController _authController = Get.find();

  void _showEditDialog(BuildContext context) {
    final titreController = TextEditingController(text: widget.event.titre);
    final descriptionController = TextEditingController(text: widget.event.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier l\'événement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titreController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
            ),
            onPressed: () async {
              final updatedEvent = widget.event
                ..titre = titreController.text
                ..description = descriptionController.text
                ..updatedAt = DateTime.now().millisecondsSinceEpoch;

              final success = await _authController.updateEvent(updatedEvent);
              if (success && context.mounted) {
                Navigator.pop(context);
                Get.snackbar('Succès', 'Événement modifié');
              }
            },
            child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'Confirmer la suppression',
      content: const Text('Voulez-vous vraiment supprimer cet événement ?'),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () async {
          final updatedEvent = widget.event
            ..statut = EventStatus.supprimer.name
            ..updatedAt = DateTime.now().millisecondsSinceEpoch;

          final success = await _authController.updateEvent(updatedEvent);
          if (success) {
            Get.back();
            Get.snackbar('Succès', 'Événement supprimé');
          }

        },
        child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Annuler'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Colors.green[800]),
            title: Text('Modifier', style: TextStyle(color: Colors.green[800])),
            onTap: () {
              Navigator.pop(context);
              _showEditDialog(context);
            },
          ),
          Divider(color: Colors.green[100]),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red[800]),
            title: Text('Supprimer', style: TextStyle(color: Colors.red[800])),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete();
            },
          ),
        ],
      ),
    );
  }
}