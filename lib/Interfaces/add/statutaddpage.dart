// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minka/Interfaces/app/home.dart';
import 'package:minka/main.dart';
import 'package:minka/models/storie.dart';
import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';

class StatuAdd extends StatefulWidget {
  const StatuAdd({Key? key}) : super(key: key);

  @override
  State<StatuAdd> createState() => _StatuAddState();
}

TextEditingController controller = TextEditingController();

class _StatuAddState extends State<StatuAdd> {
  File? image;
  bool imagview = false;
  sendImage(UserApp userApp) {
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
                              sendImage(userApp);
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
                              sendImage(userApp);
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
                        sendImage(userApp);
                      },
                      child: Text("Changer",
                          style: styleText.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600))),
              (imagview)
                  ? TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: StatutImage(
                                    image: image!, userApp: userApp),
                                type: PageTransitionType.fade));
                      },
                      child: Text("envoyer",
                          style: styleText.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                  : Container()
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserApp>(
        stream: UserApp.userLogin(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(62, 139, 134, 1),
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 100, horizontal: 30),
                      height: taille(context).height,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(62, 139, 134, 1),
                      ),
                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          style: styleText.copyWith(
                              fontSize: 40,
                              color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ecrivez un statut",
                            hintStyle: styleText.copyWith(
                                fontSize: 35,
                                color: Colors.white.withOpacity(0.4)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          sendImage(snapshot.data!);
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.photo, size: 30),
                        ),
                        label: Text('publier une image',
                            style: styleText.copyWith(color: Colors.white))),
                  ],
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Storie storie = Storie(
                      userstoreie: snapshot.data!,
                      texte: controller.text,
                      image: " ",
                      debut: DateTime.now(),
                      idStorie:
                          DateTime.now().millisecondsSinceEpoch.toString());
                  storie.save();
                  setState(() {
                    controller.clear();
                    Navigator.of(context).pop();
                  });
                } else {
                  snack(
                    context: context,
                    msg: "le champ d'entrer est vide",
                  );
                }
              },
              child: const Icon(Icons.send,
                  color: Color.fromRGBO(62, 139, 134, 1)),
            ),
          );
        });
  }
}

class StatutImage extends StatefulWidget {
  final File image;
  final UserApp userApp;
  const StatutImage({Key? key, required this.image, required this.userApp})
      : super(key: key);

  @override
  State<StatutImage> createState() => _StatutImageState();
}

class _StatutImageState extends State<StatutImage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(62, 139, 134, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close, size: 30)),
      ),
      body: Center(
        child: !loading
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(widget.image,
                    width: double.infinity, fit: BoxFit.cover))
            : const Spink(
                couleur: Colors.white,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          setState(() {
            loading = true;
          });
          Storie storie = Storie(
            userstoreie: widget.userApp,
            texte: " ",
            image: " ",
            debut: DateTime.now(),
            idStorie: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          final ref = FirebaseStorage.instance
              .ref("Stories")
              .child(widget.userApp.userId)
              .child(storie.idStorie);
          try {
            await ref.putFile(widget.image).whenComplete(() async {
              final url = await ref.getDownloadURL();
              storie.image = url;
              print(storie.toMap());
              storie.save();
              setState(() {
                loading = false;
              });
            });
          } catch (e) {
            print(e.toString());
          }
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(PageTransition(
              child: const HomePage(), type: PageTransitionType.fade));
        },
        child: const Icon(Icons.send, color: Color.fromRGBO(62, 139, 134, 1)),
      ),
    );
  }
}
