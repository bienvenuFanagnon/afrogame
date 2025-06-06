import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _AidePageState();
}

class _AidePageState extends State<ContactPage> {
  List<String> attachments = [];

  String _nom = '';
  String _email = 'mykeys@my-keys.com';
  String _message = '';
  bool tap= false;

  final _formKey = GlobalKey<FormState>();

  bool isHTML = false;



  final _subjectController = TextEditingController(text: "Demande d'information");

  final _bodyController = TextEditingController();



  final _recipientController = TextEditingController(
    text: 'mykeys@my-keys.com',
  );


  Future sendEmail(String emailText) async {
    //_bodyController.text = '${_nom},  ${_bodyController.text}';
    final Email email = Email(
      body: '${_bodyController.text}',
      subject: _subjectController.text,

      recipients: [emailText],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      var response =await FlutterEmailSender.send(email);
      //print('${response.toString()}');
      platformResponse = 'success';
      _bodyController.text='';
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // duration: 2000,
          content:
          Text('Votre message a été envoyé.'),
        ),
      );

       */
    } catch (error) {
      print(error);
      platformResponse = error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // duration: 2000,
          content:
          Text('Message non envoyer',style: TextStyle(color: Colors.red),),
        ),
      );
    }

    if (!mounted) return;

  }

  Future<void> launchWhatsApp(String phone) async {
    String url = "https://wa.me/$phone";
    if (!await launchUrl(Uri.parse(url))) {
      final snackBar = SnackBar(duration: Duration(seconds: 2),content: Text("Impossible d\'ouvrir WhatsApp",textAlign: TextAlign.center, style: TextStyle(color: Colors.red),));

      // Afficher le SnackBar en bas de la page
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception('Impossible d\'ouvrir WhatsApp');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = 'mykeys@my-keys.com';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Informations de contact',
                style: TextStyle(fontSize: 18.0),
              ),

              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Afrolook',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              TextButton(

                onPressed: () {
                  sendEmail('officiel.afrolook@gmail.com');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(

                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0,right: 12,top: 8,bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.email,color: Colors.black,),

                          Text(
                            'Info générale, signaler un souci',
                            style: TextStyle(fontSize: 16.0,color: Colors.black),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '228SportZ',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              TextButton(

                onPressed: () {
                  sendEmail('officiel.afrogame@gmail.com');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(

                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0,right: 12,top: 8,bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.email,color: Colors.black,),

                          Text(
                            'Contact pour des infos',
                            style: TextStyle(fontSize: 16.0,color: Colors.black),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //
              //
              // SizedBox(height: 10),
              // TextButton(
              //
              //   onPressed: () {
              //     sendEmail('officiel.afrolook.annonce@gmail.com');
              //   },
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.all(Radius.circular(20)),
              //     child: Container(
              //
              //       color: Colors.black12,
              //       child: Padding(
              //         padding: const EdgeInsets.only(top: 8,bottom: 8),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             const Icon(Icons.email,color: Colors.black,),
              //
              //             Text(
              //               'Contact Afrolook Ads',
              //               style: TextStyle(fontSize: 16.0,color: Colors.green,fontWeight: FontWeight.w900),
              //             ),
              //
              //
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 8.0),


            ],
          ),
        ),
      ),
    );
  }
}
