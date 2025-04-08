import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates

class DateWidget extends StatelessWidget {
  final int dateInMicroseconds;

  DateWidget({required this.dateInMicroseconds});

  @override
  Widget build(BuildContext context) {
    DateTime eventDate = DateTime.fromMicrosecondsSinceEpoch(dateInMicroseconds);
    DateTime today = DateTime.now();

    // Vérifier si l'événement est aujourd'hui
    bool isToday = eventDate.year == today.year &&
        eventDate.month == today.month &&
        eventDate.day == today.day;

    // Vérifier si l'événement est dans le futur
    bool isFuture = eventDate.isAfter(today);

    // Déterminer le style et le texte à afficher
    Color textColor;
    String displayText;

    if (isToday) {
      textColor = Colors.green;
      displayText = "Aujourd'hui";
    } else if (isFuture) {
      textColor = Colors.green; // Couleur par défaut pour les dates futures
      displayText = DateFormat('dd MMM yyyy').format(eventDate);
    } else {
      textColor = Colors.red;
      displayText =
      "${DateFormat('dd MMM yyyy').format(eventDate)} -  Passé";
    }

    return Text(
      displayText,
      style: TextStyle(color: textColor, fontSize: 16,fontWeight: FontWeight.w900),
    );
  }
}
