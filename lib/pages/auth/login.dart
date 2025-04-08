/*
  Flutter UI
  ----------
  lib/screens/simple_login.dart
*/

import 'dart:io';
import 'package:afroevent/pages/home.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;

import 'package:afroevent/pages/auth/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/authController.dart';
import '../../models/event_models.dart';
import '../share/messageView.dart';

// class SimpleLoginScreen extends StatefulWidget {
//   /// Callback for when this form is submitted successfully. Parameters are (email, password)
//   final Function(String? email, String? password)? onSubmitted;
//
//   const SimpleLoginScreen({this.onSubmitted, Key? key}) : super(key: key);
//   @override
//   State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
// }
//
// class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
//   late String email, password;
//   String? emailError, passwordError;
//   Function(String? email, String? password)? get onSubmitted =>
//       widget.onSubmitted;
//   final AuthController authController = Get.find();
//   final _auth = FirebaseAuth.instance;
//
//
//   @override
//   void initState() {
//     super.initState();
//     email = '';
//     password = '';
//
//     emailError = null;
//     passwordError = null;
//   }
//
//   void resetErrorText() {
//     setState(() {
//       emailError = null;
//       passwordError = null;
//     });
//   }
// String errorMessage="";
//   bool validate() {
//     resetErrorText();
//
//     RegExp emailExp = RegExp(
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
//
//     bool isValid = true;
//     if (email.isEmpty || !emailExp.hasMatch(email)) {
//       setState(() {
//         emailError = 'Email is invalid';
//       });
//       isValid = false;
//     }
//
//     if (password.isEmpty) {
//       setState(() {
//         passwordError = 'Please enter a password';
//       });
//       isValid = false;
//     }
//
//     return isValid;
//   }
//   signIn(String email, String password) async {
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       try {
//         await _auth
//             .signInWithEmailAndPassword(email: email, password: password)
//             .then((uid) async => {
//           //serviceProvider.getLoginUser( _auth.currentUser!.uid!,context),
//
//           await authController.getUserById(uid.user!.uid!).then((users) async {
//             //  PhoneVerification phoneverification = PhoneVerification(number:'22896198801' );
//            await prefs.setString("token", uid.user!.uid!);
//
//             //   phoneverification.sendotp('Your Otp');
//             if (users.isNotEmpty) {
//               authController.userLogged=users.first;
//               goToPage(context, HomePage());
//
//
//             }else{
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text('Erreur de Chargement',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
//               ),);
//             }
//           },),
//
//         });
//       } on FirebaseAuthException catch (error) {
//
//         switch (error.code) {
//           case "invalid-email":
//             errorMessage = "Votre numero semble être malformée.";
//             break;
//           case "wrong-password":
//             errorMessage = "Votre mot de passe est erroné.";
//             break;
//           case "user-not-found":
//             errorMessage = "L'utilisateur avec cet numero n'existe pas.";
//             break;
//           case "invalid-credential":
//             errorMessage = "information incorrecte";
//             break;
//           case "user-disabled":
//             errorMessage = "L'utilisateur avec cet numero a été désactivé.";
//             break;
//           case "too-many-requests":
//             errorMessage = "Trop de demandes";
//             break;
//           case "operation-not-allowed":
//             errorMessage =
//             "La connexion avec le numero et un mot de passe n'est pas activée.";
//             break;
//           case "network-request-failed":
//             errorMessage =
//             "erreur de connexion.";
//             break;
//           default:
//             errorMessage = "Une erreur indéfinie s'est produite.";
//         }
//         SnackBar snackBar = SnackBar(
//           content: Text(errorMessage.toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         printVm(error.code);
//
//     }
//   }
//
//   Future<void> submit() async {
//     if (validate()) {
//      await signIn(email,password);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: ListView(
//           children: [
//             SizedBox(height: screenHeight * .12),
//             const Text(
//               'Welcome,',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: screenHeight * .01),
//             Text(
//               'Sign in to continue!',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.black.withOpacity(.6),
//               ),
//             ),
//             SizedBox(height: screenHeight * .12),
//             InputField(
//               onChanged: (value) {
//                 setState(() {
//                   email = value;
//                 });
//               },
//               labelText: 'Email',
//               errorText: emailError,
//               keyboardType: TextInputType.emailAddress,
//               textInputAction: TextInputAction.next,
//               autoFocus: true,
//             ),
//             SizedBox(height: screenHeight * .025),
//             InputField(
//               onChanged: (value) {
//                 setState(() {
//                   password = value;
//                 });
//               },
//               onSubmitted: (val) => submit(),
//               labelText: 'Password',
//               errorText: passwordError,
//               obscureText: true,
//               textInputAction: TextInputAction.next,
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: screenHeight * .075,
//             ),
//             FormButton(
//               text: 'Log In',
//               onPressed: submit,
//             ),
//             SizedBox(
//               height: screenHeight * .15,
//             ),
//             TextButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const SimpleRegisterScreen(),
//                 ),
//               ),
//               child: RichText(
//                 text: const TextSpan(
//                   text: "I'm a new user, ",
//                   style: TextStyle(color: Colors.black),
//                   children: [
//                     TextSpan(
//                       text: 'Sign Up',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class SimpleLoginScreen extends StatefulWidget {
  /// Callback lorsque ce formulaire est soumis avec succès. Les paramètres sont (email, mot de passe)
  final Function(String? email, String? password)? onSubmitted;

  const SimpleLoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  late String email, password;
  String? emailError, passwordError;
  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;
  final AuthController authController = Get.find();
  final _auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    email = '';
    password = '';

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }
  String errorMessage="";

  bool tap=false;
  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'L\'email est invalide';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Veuillez entrer un mot de passe';
      });
      isValid = false;
    }

    return isValid;
  }
  signIn(String email, String password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        tap=true;
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) async => {
        //serviceProvider.getLoginUser( _auth.currentUser!.uid!,context),

        await authController.getUserById(uid.user!.uid!).then((users) async {
          //  PhoneVerification phoneverification = PhoneVerification(number:'22896198801' );
          await prefs.setString("token", uid.user!.uid!);

          //   phoneverification.sendotp('Votre Otp');
          if (users.isNotEmpty) {
            authController.userLogged=users.first;

            goToPage(context, HomePage());

          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erreur de Chargement',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
            ),);
          }
          setState(() {
            tap=false;
          });
        },),

      });
    } on FirebaseAuthException catch (error) {

      switch (error.code) {
        case "invalid-email":
          errorMessage = "Votre numéro semble être malformé.";
          break;
        case "wrong-password":
          errorMessage = "Votre mot de passe est erroné.";
          break;
        case "user-not-found":
          errorMessage = "L'utilisateur avec ce numéro n'existe pas.";
          break;
        case "invalid-credential":
          errorMessage = "Informations incorrectes";
          break;
        case "user-disabled":
          errorMessage = "L'utilisateur avec ce numéro a été désactivé.";
          break;
        case "too-many-requests":
          errorMessage = "Trop de demandes";
          break;
        case "operation-not-allowed":
          errorMessage =
          "La connexion avec le numéro et un mot de passe n'est pas activée.";
          break;
        case "network-request-failed":
          errorMessage =
          "Erreur de connexion.";
          break;
        default:
          errorMessage = "Une erreur indéfinie s'est produite.";
      }
      setState(() {
        tap=false;
      });
      SnackBar snackBar = SnackBar(
        content: Text(errorMessage.toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      printVm(error.code);

    }
  }

  Future<void> submit() async {
    if (validate()) {
      await signIn(email,password);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Text(
              'Bienvenue,',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              'Connectez-vous pour continuer !',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .12),
            InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: 'Email',
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              onSubmitted: (val) => submit(),
              labelText: 'Mot de passe',
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
           tap?SizedBox( height: 20,width: 20, child: CircularProgressIndicator()): FormButton(
              text: 'Se connecter',
              onPressed: submit,
            ),
            SizedBox(
              height: screenHeight * .15,
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SimpleRegisterScreen(),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: "Je suis un nouvel utilisateur, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'S\'inscrire',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class SimpleRegisterScreen extends StatefulWidget {
  /// Callback lorsqu'un formulaire est soumis avec succès. Les paramètres sont (email, mot de passe)
  final Function(String? email, String? password)? onSubmitted;

  const SimpleRegisterScreen({this.onSubmitted, Key? key}) : super(key: key);

  @override
  State<SimpleRegisterScreen> createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  late String email, pseudo, password, confirmPassword;
  String? emailError, pseudoError, passwordError;
  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;
  final AuthController authController = Get.find();
  File? _image; // Variable pour stocker l'image sélectionnée
  final ImagePicker _picker = ImagePicker();

  // Fonction pour sélectionner une image
  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late bool tap = false;
  late String errorMessage = '';
  final _auth = FirebaseAuth.instance;
  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (pseudo.isEmpty) {
      setState(() {
        pseudoError = 'Le pseudo est invalide';
      });
      isValid = false;
    }
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'L\'email est invalide';
      });
      isValid = false;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = 'Veuillez entrer un mot de passe';
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = 'Les mots de passe ne correspondent pas';
      });
      isValid = false;
    }

    return isValid;
  }

  void signUp(String email, String password) async {


    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
        postDetailsToFirestore(value.user!.uid!),
        setState(() {
          tap = false;
        }),
      }).catchError((e) {
        SnackBar snackBar = SnackBar(
          content: Text("Une erreur s'est produite", style: TextStyle(color: Colors.red)),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        printVm('error ${e!.message}');
        setState(() {
          tap = false;
        });
      });
      setState(() {
        tap = false;
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Votre email semble être malformé.";
          break;
        case "wrong-password":
          errorMessage = "Votre mot de passe est incorrect.";
          break;
        case "user-not-found":
          errorMessage = "Aucun utilisateur trouvé avec cet email.";
          break;
        case "user-disabled":
          errorMessage = "L'utilisateur a été désactivé.";
          break;
        case "too-many-requests":
          errorMessage = "Trop de demandes.";
          break;
        case "operation-not-allowed":
          errorMessage = "La connexion avec l'email et un mot de passe n'est pas activée.";
          break;
        default:
          errorMessage = "Une erreur indéfinie s'est produite.";
      }
      SnackBar snackBar = SnackBar(
        content: Text('$errorMessage', style: TextStyle(color: Colors.red)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      printVm(error.code);
      setState(() {
        tap = false;
      });
    }
  }

  postDetailsToFirestore(String id) async {
    authController.registerUser.role = UserRole.USER.name!;

    try {
      authController.registerUser.id = id;
      authController.registerUser.email = email;
      authController.registerUser.pseudo = pseudo;
      await firestore.collection('Users').doc(id).set(authController.registerUser.toJson());

      SnackBar snackBar = SnackBar(
        content: Text('Compte créé avec succès !', style: TextStyle(color: Colors.green)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);

    } on FirebaseException catch (error) {
      SnackBar snackBar = SnackBar(
        content: Text('$error', style: TextStyle(color: Colors.red)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      printVm('error $error');
    }
    setState(() {
      tap = false;
    });
  }

  Future<void> submit() async {
    if (validate()) {
      printVm('soumis');

      if (_image != null) {
        setState(() {
          tap = true;
        });
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('user_profile/${Path.basename(_image!.path)}');
        UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask.whenComplete(() {
          storageReference.getDownloadURL().then((fileURL) {
            printVm("url photo1");
            printVm(fileURL);

            authController.registerUser.urlImage = fileURL;
            authController.registerUser.solde = 0;
            authController.registerUser.note = 0.1;
            authController.registerUser.role = UserRole.USER.name;
            signUp(email, password);
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Choisir un avatar', style: TextStyle(color: Colors.red)),
          ),
        );
        // onSubmitted!(email, password);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    confirmPassword = '';
    emailError = null;
    passwordError = null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .12),
            const Text(
              'Créer un compte,',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              'Inscrivez-vous pour commencer !',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .12),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Ajouter un avatar"),
                ),
                _image == null
                    ? Text('Aucune image sélectionnée.')
                    : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * .025),

            InputField(
              onChanged: (value) {
                setState(() {
                  pseudo = value;
                });
              },
              labelText: 'Pseudo',
              errorText: pseudoError,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: 'Email',
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              labelText: 'Mot de passe',
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              labelText: 'Confirmer le mot de passe',
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            tap ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator()):FormButton(
              text: 'Créer un compte',
              onPressed: submit,
            ),
            SizedBox(
              height: screenHeight * .125,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: RichText(
                text: const TextSpan(
                  text: "Je suis déjà membre, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Se connecter',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


// class SimpleRegisterScreen extends StatefulWidget {
//   /// Callback for when this form is submitted successfully. Parameters are (email, password)
//   final Function(String? email, String? password)? onSubmitted;
//
//   const SimpleRegisterScreen({this.onSubmitted, Key? key}) : super(key: key);
//
//   @override
//   State<SimpleRegisterScreen> createState() => _SimpleRegisterScreenState();
// }
//
// class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
//   late String email,pseudo, password, confirmPassword;
//   String? emailError,pseudoError, passwordError;
//   Function(String? email, String? password)? get onSubmitted =>
//       widget.onSubmitted;
//   final AuthController authController = Get.find();
//   File? _image; // Variable pour stocker l'image sélectionnée
//   final ImagePicker _picker = ImagePicker();
//
//   // Fonction pour sélectionner une image
//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//     await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   void resetErrorText() {
//     setState(() {
//       emailError = null;
//       passwordError = null;
//     });
//   }
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late bool tap= false;
//   late String errorMessage='';
//   final _auth = FirebaseAuth.instance;
//   bool validate() {
//     resetErrorText();
//
//     RegExp emailExp = RegExp(
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
//
//     bool isValid = true;
//     if (pseudo.isEmpty) {
//       setState(() {
//         pseudoError = 'pseudo is invalid';
//       });
//       isValid = false;
//     }    if (email.isEmpty || !emailExp.hasMatch(email)) {
//       setState(() {
//         emailError = 'Email is invalid';
//       });
//       isValid = false;
//     }
//
//     if (password.isEmpty || confirmPassword.isEmpty) {
//       setState(() {
//         passwordError = 'Please enter a password';
//       });
//       isValid = false;
//     }
//     if (password != confirmPassword) {
//       setState(() {
//         passwordError = 'Passwords do not match';
//       });
//       isValid = false;
//     }
//
//     return isValid;
//   }
//
//   void signUp(String email, String password) async {
//     setState(() {
//       var tap= true;
//     });
//
//
//
//     try {
//       await _auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .then((value) => {
//
//         postDetailsToFirestore(value.user!.uid!),
//         setState(() {
//           tap= false;
//         }),
//       }).catchError((e) {
//
//         SnackBar snackBar = SnackBar(
//           content: Text("Une erreur s'est produite",style: TextStyle(color: Colors.red),),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         printVm('error ${e!.message}');
//         setState(() {
//           tap= false;
//         });
//
//       });
//       setState(() {
//         tap= false;
//       });
//     } on FirebaseAuthException catch (error) {
//       switch (error.code) {
//         case "invalid-email":
//           errorMessage = "Votre numero semble être malformée.";
//           break;
//         case "wrong-password":
//           errorMessage = "Votre mot de passe est erroné.";
//           break;
//         case "user-not-found":
//           errorMessage = "L'utilisateur avec cet numero n'existe pas.";
//           break;
//         case "user-disabled":
//           errorMessage = "L'utilisateur avec cet numero a été désactivé.";
//           break;
//         case "too-many-requests":
//           errorMessage = "Trop de demandes";
//           break;
//         case "operation-not-allowed":
//           errorMessage =
//           "La connexion avec le numero et un mot de passe n'est pas activée.";
//           break;
//         default:
//           errorMessage = "Une erreur indéfinie s'est produite.";
//       }
//       SnackBar snackBar = SnackBar(
//         content: Text('${errorMessage}',style: TextStyle(color: Colors.red),),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//
//       printVm(error.code);
//       setState(() {
//         tap= false;
//       });
//     }
//
//
//
//
//
//   }
//   postDetailsToFirestore(String id) async {
//
//     authController .registerUser.role = UserRole.USER.name!;
//
//     try{
//       // await verifierParrain( authController.registerUser.codeParrain!);
//
//       authController.registerUser.id =id;
//       authController.registerUser.email =email;
//       authController.registerUser.pseudo =pseudo;
//       await firestore.collection('Users').doc(id).set( authController.registerUser.toJson());
//
//
//       SnackBar snackBar = SnackBar(
//         content: Text('Compte créé avec succès !',style: TextStyle(color: Colors.green),),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // Navigator.pop(context);
//       // Navigator.pushNamed(context, '/bon_a_savoir');
//
//
//
//     } on FirebaseException catch(error){
//
//       SnackBar snackBar = SnackBar(
//         content: Text('${error}',style: TextStyle(color: Colors.red),),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       printVm('error ${error}');
//     }
//     setState(() {
//       tap= false;
//     });
//
//   }
//
//   Future<void> submit() async {
//     if (validate()) {
//
//       printVm('submited');
//
//       if (_image != null) {
//         Reference storageReference = FirebaseStorage.instance
//             .ref()
//             .child('user_profile/${Path.basename(_image!.path)}');
//         UploadTask uploadTask = storageReference.putFile(_image!);
//         await uploadTask.whenComplete((){
//
//           storageReference.getDownloadURL().then((fileURL) {
//
//             printVm("url photo1");
//             printVm(fileURL);
//
//
//             authController.registerUser.urlImage = fileURL;
//
//             authController .registerUser.solde=0;
//             authController .registerUser.note=0.1;
//             authController .registerUser.role=UserRole.USER.name;;
//             signUp(email,password);
//             Navigator.pop(context);
//
//             // Afficher une SnackBar
//             // signUp('${authController.registerUser.numeroDeTelephone!}@gmail.com',authController.registerUser.password!);
//             /*
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) {
//                                                   return SignUpFormEtap2(imageFile:  _image!,);
//                                                 },
//                                               ),
//                                             );
//
//                                  */
//
//           });
//         });
//
//       }else{
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content:
//             Text('choisir un avatar',style: TextStyle(color: Colors.red),),
//           ),
//         );
//         onSubmitted!(email, password);
//
//
//       }
//
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     email = '';
//     password = '';
//     confirmPassword = '';
//
//     emailError = null;
//     passwordError = null;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: ListView(
//           children: [
//             SizedBox(height: screenHeight * .12),
//             const Text(
//               'Create Account,',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: screenHeight * .01),
//             Text(
//               'Sign up to get started!',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.black.withOpacity(.6),
//               ),
//             ),
//             SizedBox(height: screenHeight * .12),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _pickImage,
//                   child: const Text("Ajouter un avatar"),
//                 ),
//                 _image == null
//                     ? Text('Aucune image sélectionnée.')
//                     : Container(
//                   height: 100,
//                   width: 100,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(100))
//                   ),
//                       child: Image.file(
//                                         _image!,
//
//                                         fit: BoxFit.cover,
//                                       ),
//                     ),
//               ],
//             ),
//
//             SizedBox(height: screenHeight * .025),
//
//             InputField(
//               onChanged: (value) {
//                 setState(() {
//                   pseudo = value;
//                 });
//               },
//               labelText: 'Pseudo',
//               errorText: pseudoError,
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//               autoFocus: true,
//             ),
//             SizedBox(height: screenHeight * .025),
//             InputField(
//               onChanged: (value) {
//                 setState(() {
//                   email = value;
//                 });
//               },
//               labelText: 'Email',
//               errorText: emailError,
//               keyboardType: TextInputType.emailAddress,
//               textInputAction: TextInputAction.next,
//               autoFocus: true,
//             ),
//             SizedBox(height: screenHeight * .025),
//             InputField(
//               onChanged: (value) {
//                 setState(() {
//                   password = value;
//                 });
//               },
//               labelText: 'Password',
//               errorText: passwordError,
//               obscureText: true,
//               textInputAction: TextInputAction.next,
//             ),
//             SizedBox(height: screenHeight * .025),
//             InputField(
//               onChanged: (value) {
//                 setState(() {
//                   confirmPassword = value;
//                 });
//               },
//               labelText: 'Confirm Password',
//               errorText: passwordError,
//               obscureText: true,
//               textInputAction: TextInputAction.done,
//             ),
//             SizedBox(
//               height: screenHeight * .075,
//             ),
//             tap?Container(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator()):FormButton(
//               text: 'Créer un compte',
//               onPressed: submit,
//             ),
//             SizedBox(
//               height: screenHeight * .125,
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: RichText(
//                 text: const TextSpan(
//                   text: "I'm already a member, ",
//                   style: TextStyle(color: Colors.black),
//                   children: [
//                     TextSpan(
//                       text: 'Sign In',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

