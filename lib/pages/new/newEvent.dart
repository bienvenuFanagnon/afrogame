import 'dart:io';
import 'dart:typed_data';
import 'package:afroevent/controllers/authController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart' as Path;
import 'package:afroevent/pages/share/messageView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/event_models.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _googleMapLinkController = TextEditingController();
  AuthController authController = Get.find();

  String selectedCategory = "Sport";
  String typejeu = "EVENEMENT";
  String selectedSubCategory = "Basket";
  String selectedCountry = "Togo";
  String selectedCity = "Lomé";

  late List<String> categories = [];
  final List<String> typesJeu = [ "EVENEMENT","ACTUALITE","GAMESTORY","PUB",];
  late Map<String, List<String>> subCategories = {};

  final List<String> countries = ["Togo", "Ghana", "Bénin"];
  final Map<String, List<String>> cities = {
    "Togo": ["Lomé", "Kara"],
    "Ghana": ["Accra", "Kumasi"],
    "Bénin": ["Cotonou", "Porto-Novo"],
  };
  late Color? generalcolors=Colors.green;
  late Color? secondecolors=Colors.green[800];

  List<File> _images = [];
  File? _video;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime? _selectedDate;
  int? _microsecondsSinceEpoch;
  bool tap = false;

  final InputDecoration _inputDecoration = InputDecoration(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green!)),
    fillColor: Colors.grey[100],
    filled: true,
  );

  @override
  void initState() {
    if (authController.userLogged.role == UserRole.ADM.name) {
      categories = ["Sport",];


    subCategories = {
        "Sport": [
          "Football",
          "Basket",
          "Handball",
          "Karate",
          "Tennis",
          "Athlétisme",
          "Judo",
          "Natation",
          "Boxe",
          "Cyclisme",
          "Volleyball",
          "Taekwondo",
          "Rugby",
          // "Escrime",
          // "Lutte",
          // "Gymnastique",
          // "Skateboard",
          // "Surf",
          // "Badminton",
          "Golf"
        ]
        ,
        "Événement": ["Concert", "Festival"],
        "AlaUne": ["Concert", "Festival", "Événement"],
      };
    } else {
      categories = ["Sport"];
      subCategories = {
        "Sport": ["Basket", "Football"],
        "Événement": ["Concert", "Festival"],
      };
    }
    super.initState();
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      if (_images.length + pickedFiles.length <= 3) {
        setState(() {
          _images.addAll(pickedFiles.map((file) => File(file.path)));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('Maximum 3 images autorisées', style: TextStyle(color: Colors.red)),
            ));
        }
        }
        }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(minutes: 5),
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length() / (1024 * 1024);

      if (fileSize > 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La vidéo ne doit pas dépasser 20 Mo',
                style: TextStyle(color: Colors.red)),
          ),
        );
        return;
      }

      setState(() {
        _video = file;
      });
    }
  }

  Future<String?> _uploadFile(File file, String type) async {
    try {
      String fileName = Path.basename(file.path);
      Reference ref = FirebaseStorage.instance.ref().child('medias/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => null);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Erreur upload: $e');
      return null;
    }
  }

  Widget _buildMediaPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_images.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Images sélectionnées:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(entry.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => setState(() => _images.removeAt(entry.key)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],
          ),
        if (_video != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vidéo sélectionnée:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              FutureBuilder<Uint8List?>(
                future: FlutterVideoThumbnailPlus.thumbnailData(
                  video: _video!.path,
                  imageFormat: ImageFormat.jpeg,
                  maxWidth: 200,
                  quality: 75,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: MemoryImage(snapshot.data!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Icon(Icons.play_circle_filled, size: 50, color: Colors.white),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => setState(() => _video = null),
                          ),
                        ),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Choisir une date', style: TextStyle(color: Colors.red)),
          ),
        );
        return;
      }

      if (_images.isEmpty && _video == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ajouter au moins une image ou une vidéo',
                  style: TextStyle(color: Colors.red)),
            ));
            return;
        }

            setState(() => tap = true);

    try {
    List<Map<String, String?>> medias = [];

    for (File image in _images) {
    String? url = await _uploadFile(image, 'image');
    if (url != null) {
    medias.add({'url': url, 'type': 'image'});
    }
    }

    if (_video != null) {
    String? url = await _uploadFile(_video!, 'video');
    if (url != null) {
    medias.add({'url': url, 'type': 'video'});
    }
    }

    EventData eventData = EventData()
    ..userId = authController.userLogged.id
    ..titre = _titleController.text
    ..description = _descriptionController.text
    ..categorie = selectedCategory
    ..typeJeu = typejeu
    ..sousCategorie = selectedSubCategory
    ..urlPosition = _googleMapLinkController.text
    ..pays = selectedCountry
    ..date = _microsecondsSinceEpoch
    ..createdAt = DateTime.now().microsecondsSinceEpoch
    ..updatedAt = DateTime.now().microsecondsSinceEpoch
    ..ville = selectedCity
    ..nombreJourAvantDisparition = 3
    ..statut = EventStatus.encours.name
    ..medias = medias;

    await postDetailsToFirestore(eventData);
    String eventBasket="➡️🏀 Nouveau match de basketball à ${eventData.ville} ! Rejoins-nous et montre tes skills ! 🔥✨";
    String eventFootball= "➡️⚽ Prépare tes crampons ! Match de football à ${eventData.ville} Viens et marque l'histoire ! 🥅⚡";
    String eventOnlineGeneral = "➡️🎉 Un nouveau événement en ligne t'attend ! 📅 Rejoins-nous pour une expérience incroyable ! 🚀✨";

    await authController.getUsers().then((users) async {
      if(users.isNotEmpty){
        List<String> listUserId=[];
        for(var user in users){
          listUserId.add(user.oneIgnalUserid!);

        }
        await authController.sendNotification(
            userIds: listUserId,
            smallImage: authController.userLogged.urlImage!,
            send_user_id: authController.userLogged.id!,
            recever_user_id: "",
            // eventData.categorie=="EVENEMENT"?eventOnlineGeneral:
            message: eventData.sousCategorie=="Basket"?eventBasket:eventData.sousCategorie=="Football"?eventFootball:eventOnlineGeneral,
            type_notif: "Annonce",
            post_id: eventData.id!);
      }

    },);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Événement créé avec succès!',
    style: TextStyle(color: Colors.green)),
    ),
    );

    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Erreur: $e', style: TextStyle(color: Colors.red)),
    ),
    );
    } finally {
    setState(() => tap = false);
    }
  }
  }

  Future<void> postDetailsToFirestore(EventData eventData) async {
    try {
      String id = firestore.collection('EventData').doc().id;
      eventData.id = id;

      await firestore.collection('EventData').doc(id).set(eventData.toJson());

    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${error}', style: TextStyle(color: Colors.red)),
          ));
          print('error ${error}');
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _microsecondsSinceEpoch = _selectedDate!.microsecondsSinceEpoch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvel Événement Sportif",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: secondecolors,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Informations de base'),
              _buildTextField(_titleController, 'Titre de l\'événement', Icons.title),
              SizedBox(height: 16),
              _buildTextField(_descriptionController, 'Description', Icons.description, maxLines: 4),
              SizedBox(height: 24),

              _buildSectionTitle('Détails sportifs'),
              _buildDropdown(selectedCategory, categories, 'Catégorie sportive', Icons.sports),
              SizedBox(height: 16),
              _buildDropdown(selectedSubCategory, subCategories[selectedCategory]!, 'Sous-catégorie', Icons.sports_score),
              SizedBox(height: 16),
              _buildDropdown(typejeu, typesJeu, 'Type de jeu', Icons.gamepad),
              SizedBox(height: 24),

              _buildSectionTitle('Localisation'),
              _buildDropdown(selectedCountry, countries, 'Pays', Icons.flag),
              SizedBox(height: 16),
              _buildDropdown(selectedCity, cities[selectedCountry]!, 'Ville', Icons.location_city),
              SizedBox(height: 16),
              _buildTextField(_googleMapLinkController, 'Lien Google Maps', Icons.map),
              SizedBox(height: 24),

              _buildSectionTitle('Date et média'),
              _buildDatePicker(),
              SizedBox(height: 16),
              _buildMediaSection(),
              SizedBox(height: 24),

              tap
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondecolors,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('PUBLIER L\'ÉVÉNEMENT',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondecolors)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration.copyWith(
        labelText: label,
        prefixIcon: Icon(icon, color: secondecolors),
      ),
      maxLines: maxLines,
      validator: (value) => value?.isEmpty ?? true ? 'Ce champ est requis' : null,
    );
  }

  Widget _buildDropdown(String value, List<String> items, String label, IconData icon) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration.copyWith(
        labelText: label,
        prefixIcon: Icon(icon, color: secondecolors),
      ),
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: (value) => setState(() {
        print("label! ${label}");

        if (label == 'Catégorie sportive') {
          selectedCategory = value!;
          selectedSubCategory = subCategories[value]!.first;
        } else if (label == 'Pays') {
          selectedCountry = value!;
          selectedCity = cities[value]!.first;
        }else if (label == 'Sous-catégorie') {
          selectedSubCategory = value!;
        }
        else if (label == 'Type de jeu') {
          typejeu = value!;
        }
        print("selectedSubCategory! ${selectedSubCategory}");
        print("typejeu! ${typejeu}");

      }),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.calendar_today, color: secondecolors),
          title: Text(_selectedDate == null
              ? 'Sélectionner une date'
              : 'Date choisie: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
          trailing: TextButton(
            onPressed: _pickDate,
            child: Text('Changer', style: TextStyle(color: secondecolors)),
          ),
          onTap: _pickDate,
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Médias', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Images (max 3)'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: secondecolors),
              onPressed: _pickImages,
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.videocam),
              label: Text('Vidéo (max 20MB)'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: secondecolors),
              onPressed: _pickVideo,
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildMediaPreview(),
      ],
    );
  }
}