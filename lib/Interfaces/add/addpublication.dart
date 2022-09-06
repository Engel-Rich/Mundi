import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minka/models/publication.dart';

import 'package:minka/variable.dart';

class AddPublication extends StatefulWidget {
  const AddPublication({Key? key}) : super(key: key);

  @override
  State<AddPublication> createState() => _AddPublicationState();
}

class _AddPublicationState extends State<AddPublication> {
  TextEditingController controller = TextEditingController();

  File? file;
  bool loading = false;
  bool imagview = false;
  sendImage() async {
    ImagePicker picker = ImagePicker();

    String imegeUrl = "";
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
                                file = File(value.path);
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
                                file = File(value.path);
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
                    child: Image.file(file!)),
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
                      onPressed: () {
                        Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const FaIcon(Icons.close)),
        title: Text(
          'Ajouter Une Publication',
          style: styleText.copyWith(
            letterSpacing: 1.5,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: !loading
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Center(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: controller,
                      minLines: 5,
                      maxLines: 8,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade200.withOpacity(.5),
                          hintStyle: styleText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText:
                              "Quoi de neuf Aujourdhui ${auth.currentUser!.displayName} ? "),
                    ),
                    specervertical(20),
                    file != null
                        ? SizedBox(
                            child: Image.file(file!, width: 150, height: 150),
                          )
                        : const SizedBox(
                            height: 150,
                          ),
                    specervertical(20),
                    ListTile(
                        title: Text('Ajouter une Image',
                            style: styleText.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        leading: const FaIcon(Icons.add_photo_alternate_rounded,
                            size: 30),
                        tileColor: Colors.blue.shade200.withOpacity(.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onTap: () => sendImage())
                  ],
                ),
              ),
            )
          : const Center(
              child: Spink(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Publication publication = Publication(
              uid: utilisateurApp!.uid,
              date: DateTime.now(),
              texte: controller.text.isNotEmpty ? controller.text : " ");
          try {
            setState(() {
              loading = true;
            });
            if (file != null) {
              await publication.save(file: file);
            } else {
              await publication.save();
            }
            debugPrint("publication réussite");
            setState(() {
              controller.clear();
              file = null;
              loading = false;
            });
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } catch (e) {
            debugPrint(e.toString());
            setState(() {
              loading = false;
            });
          }
        },
        icon: const Icon(Icons.arrow_forward_ios),
        label: Text(
          'Publier',
          style: styleText.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
