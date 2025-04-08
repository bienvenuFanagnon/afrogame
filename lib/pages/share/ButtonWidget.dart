import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;
  final Color color;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed as void Function()?, // Assurez-vous que la fonction est bien callable
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        // onPrimary: Colors.white, // Texte blanc
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(10.0), // Ajustez le rayon si besoin
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,color: Colors.green,),
            const SizedBox(width: 8.0),
            Text(text,style: TextStyle(color: Colors.green,fontSize:12,fontWeight: FontWeight.w900 ),),
          ],
        ),
      ),
    );
  }
}