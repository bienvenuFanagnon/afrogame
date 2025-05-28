import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controllers/operationController.dart';

class CreationMenu extends StatelessWidget {
  final CreationController _controller = Get.put(CreationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Création de contenu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCreationSwitch(),
            const SizedBox(height: 20),
            Expanded(child: Obx(() => _controller.isCreatingChampionnat.value
                ? _buildChampionnatForm()
                : _buildSaisonForm())),
          ],
        ),
      ),
    );
  }

  Widget _buildCreationSwitch() {
    return Obx(() => SegmentedButton(
      segments: const [
        ButtonSegment(value: true, label: Text('Nouveau Championnat')),
        ButtonSegment(value: false, label: Text('Nouvelle Saison')),
      ],
      selected: {_controller.isCreatingChampionnat.value},
      onSelectionChanged: (Set<bool> newSelection) {
        _controller.isCreatingChampionnat.value = newSelection.first;
      },
    ));
  }

  Widget _buildChampionnatForm() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nomController = TextEditingController();
    XFile? selectedImage;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nomController,
            decoration: const InputDecoration(labelText: 'Nom du championnat'),
            validator: (value) => value?.trim().isEmpty ?? true
                ? 'Champ obligatoire'
                : null,
          ),
          const SizedBox(height: 20),
          Obx(() => _controller.championnats.isEmpty
              ? const Text('Aucun championnat existant')
              : DropdownButtonFormField<String>(
            value: _controller.selectedChampionnatId.value.isEmpty
                ? null
                : _controller.selectedChampionnatId.value,
            items: _controller.championnats.map((champ) {
              return DropdownMenuItem(
                value: champ.id,
                child: Text(champ.titre),
              );
            }).toList(),
            onChanged: (value) =>
            _controller.selectedChampionnatId.value = value ?? '',
            decoration: const InputDecoration(
                labelText: 'Championnat existant'),
          )),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _controller.createChampionnat(
                    nom: nomController.text,
                    logo: selectedImage,
                  );
                }
              },
              child: const Text('Créer le championnat')),
        ],
      ),
    );
  }

  Widget _buildSaisonForm() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nomController = TextEditingController();
    DateTime? dateDebut;
    DateTime? dateFin;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nomController,
            decoration: const InputDecoration(labelText: 'Nom de la saison'),
            validator: (value) => value?.trim().isEmpty ?? true
                ? 'Champ obligatoire'
                : null,
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Date de début'),
            subtitle: Text(dateDebut != null
                ? DateFormat('dd/MM/yyyy').format(dateDebut!)
                : 'Sélectionner une date'),
            onTap: () async {
              final date = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                dateDebut = date;
                // update();
              }
            },
          ),
          // Même chose pour dateFin
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    dateDebut != null &&
                    dateFin != null) {
                  await _controller.createSaison(
                    nom: nomController.text,
                    dateDebut: dateDebut!.microsecondsSinceEpoch,
                    dateFin: dateFin!.microsecondsSinceEpoch,
                  );
                }
              },
              child: const Text('Créer la saison')),
        ],
      ),
    );
  }
}