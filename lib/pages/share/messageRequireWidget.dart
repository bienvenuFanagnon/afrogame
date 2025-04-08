import 'package:flutter/material.dart';

class LoginRequiredDialog extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginRequiredDialog({Key? key, required this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Connexion requise',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Pour effectuer cette opération, vous devez être connecté ou créer un compte.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
          },
          child: Text(
            'Annuler',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
            onLogin(); // Appeler l'action pour se connecter
          },
          child: Text('Se connecter'),
        ),
      ],
    );
  }
}

void showLoginRequiredDialog(BuildContext context, VoidCallback onLogin) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LoginRequiredDialog(onLogin: onLogin);
    },
  );
}
