

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ConfirmUser extends StatefulWidget {
  const ConfirmUser({Key? key}) : super(key: key);

  @override
  State<ConfirmUser> createState() => _ConfirmUserState();
}

class _ConfirmUserState extends State<ConfirmUser> {
  bool onTap=false;
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // late UserAuthProvider authProvider =
  // Provider.of<UserAuthProvider>(context, listen: false);


  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Confirmation'),
        title: const Text('Changement de mot de passe',style: TextStyle(fontSize: 18),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Un lien pour réinitialiser votre mot de passe vous sera envoyer "
                    "Veuillez vérifier votre boîte de réception (et éventuellement vos spams).",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.green,
                validator: (value)  {
                  if (value!.isEmpty) {
                    return 'Le champ "Email" est obligatoire.';
                  }
                  if (!isValidEmail(value)) {
                    return 'Email invalide';
                  }
                  return null;
                },
                onSaved: (email) {},
                decoration: const InputDecoration(
                  focusColor: Colors.green,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Email",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.email),
                  ),
                ),
              ),
              // IntlPhoneField(
              //   //controller: telephoneController,
              //   // invalidNumberMessage:'numero invalide' ,
              //   onTap: () {
              //
              //   },
              //
              //   cursorColor: kPrimaryColor,
              //   decoration: InputDecoration(
              //     hintText: 'Téléphone',
              //     focusColor: kPrimaryColor,
              //     focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: kPrimaryColor)),
              //
              //   ),
              //   initialCountryCode: 'TG',
              //   onChanged: (phone) {
              //     telephoneController.text=phone.completeNumber;
              //     print(phone.completeNumber);
              //   },
              //   onCountryChanged: (country) {
              //     print('Country changed to: ' + country.name);
              //   },
              //   validator: (value) {
              //     if (value!.completeNumber.isEmpty) {
              //       return 'Le champ "Téléphone" est obligatoire.';
              //     }
              //
              //     return null;
              //   },
              //
              // ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed:onTap?() {

                }: () async {
                  setState(() {
                    onTap=true;
                  });
                  if (emailController.text.isNotEmpty) {

    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((_) {
      SnackBar snackBar = SnackBar(
        // duration: ,
        content: Text("Un email vous a été envoyé à l'adresse ${emailController.text} avec un lien pour réinitialiser votre mot de passe. "
            "Veuillez vérifier votre boîte de réception (et éventuellement vos spams).",textAlign: TextAlign.center,style: TextStyle(color: Colors.green),),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((error) {
      SnackBar snackBar = SnackBar(
        content: Text("Une erreur s'est produite lors de l'envoi de l'email de réinitialisation."
            " Veuillez réessayer ultérieurement ou contacter notre support.",textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } );
    setState(() {
      onTap=false;
    });
                  // await  authProvider.getUserByPhone( telephoneController.text).then((value) {
                  //     if (value) {
                  //       sendOtpCode();
                  //     }  else{
                  //       SnackBar snackBar = SnackBar(
                  //         content: Text("Ce compte n'existe pas",textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                  //       );
                  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //       setState(() {
                  //         onTap=false;
                  //       });
                  //     }
                  //
                  //   },);

                  }  else{
                    SnackBar snackBar = SnackBar(
                      content: Text('email est obligatoire',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      onTap=false;
                    });
                  }

                  // TODO: Implémenter la logique de confirmation
                },
                child: onTap?Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator()): Text('Confirmer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
