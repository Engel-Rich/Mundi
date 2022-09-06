// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minka/main.dart';

import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';

class SetUserInfos extends StatefulWidget {
  final User user;
  const SetUserInfos({Key? key, required this.user}) : super(key: key);

  @override
  State<SetUserInfos> createState() => _SetUserInfosState();
}

class _SetUserInfosState extends State<SetUserInfos> {
  TextEditingController nomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String profile = "";
  TextEditingController phoneController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  File? image;
  bool imagview = false;
  bool isloadin = false;
  bool emailValid(email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  sendImage() async {
    ImagePicker picker = ImagePicker();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Selectionnez un Image",
              style:
                  styleText.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: (!imagview)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await picker
                              .pickImage(source: ImageSource.camera)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                image = File(value.path);
                                imagview = true;
                              });
                              Navigator.of(context).pop();
                              sendImage();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.camera,
                          size: 30,
                          color: Color.fromRGBO(40, 173, 193, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      IconButton(
                        onPressed: () async {
                          await picker
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                image = File(value.path);
                                imagview = true;
                              });
                              Navigator.of(context).pop();
                              sendImage();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.photo,
                          size: 30,
                          color: Color.fromRGBO(40, 173, 193, 1),
                        ),
                      )
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image!)),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      imagview = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Annuler",
                      style: styleText.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600))),
              (!imagview)
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          imagview = false;
                          // image = null;
                        });
                        Navigator.of(context).pop();
                        sendImage();
                      },
                      child: Text("Changer",
                          style: styleText.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600))),
              (imagview)
                  ? TextButton(
                      onPressed: () async {
                        if (image != null) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Valider",
                          style: styleText.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                  : Container()
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(children: [
                specervertical(100),
                Text("Complettez vos informations",
                    style: styleText.copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                specervertical(30),
                Stack(
                  children: [
                    ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(217, 217, 217, 1),
                          radius: 90,
                          child: image == null
                              ? Image.asset(
                                  "assets/profile.png",
                                )
                              : Image.file(image!),
                        )),
                    Positioned(
                      top: -0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          sendImage();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          radius: 22,
                          child: FaIcon(
                            Icons.edit,
                            size: 40,
                            color: Color.fromRGBO(62, 139, 134, 1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                specervertical(30),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: nomController,
                      validator: (val) {
                        return val!.trim().isEmpty && val.trim().length < 2
                            ? "Veillez saisr le nom"
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: "Eenter le nom",
                        hintStyle: styleText,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                specervertical(20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.trim().isNotEmpty) {
                          if (emailValid(val) == false) {
                            return 'Verifier votre email';
                          }
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Eenter l'email",
                        hintStyle: styleText,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                specervertical(60),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(40, 173, 193, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (!isloadin) {
                          debugPrint('cliquable');
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              isloadin = !true;
                            });
                            debugPrint('valeur de isloading : $isloadin');
                            String photourl = "";
                            if (image != null) {
                              final ref =
                                  FirebaseStorage.instance.ref("Profiles/");
                              try {
                                await ref
                                    .child("${widget.user.uid}/Image")
                                    .putFile(image!);
                                String url = await ref
                                    .child("${widget.user.uid}/Image")
                                    .getDownloadURL();
                                debugPrint('Url de Profile $url');
                                await widget.user.updatePhotoURL(url);
                                photourl = url;
                              } catch (e) {
                                debugPrint("Erreur de modification $e");
                              }
                            }
                            await widget.user
                                .updateDisplayName(nomController.text);
                            if (emailController.text.isNotEmpty) {
                              widget.user.updateEmail(emailController.text);
                            }
                            final usr = UserApp(
                                userId: widget.user.uid,
                                userEmail: emailController.text,
                                userPhoneNumber: widget.user.phoneNumber,
                                userName: nomController.text,
                                userProfile: photourl);
                            // final utili = await UserApp.userapp(usr.userId);

                            await usr.register();

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Mundi()));
                          }
                        }
                      },
                      child: !isloadin
                          ? Text(
                              'Enrégistrer mes informations'.toUpperCase(),
                              style: styleText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Spink(
                              couleur: Colors.white,
                              size: 45,
                            ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
