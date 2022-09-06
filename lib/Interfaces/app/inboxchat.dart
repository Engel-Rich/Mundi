import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minka/models/messages.dart';

import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';

class InboxTchat extends StatefulWidget {
  final UserApp sender;
  final UserApp destinataire;
  const InboxTchat({Key? key, required this.destinataire, required this.sender})
      : super(key: key);

  @override
  State<InboxTchat> createState() => _InboxTchatState();
}

class _InboxTchatState extends State<InboxTchat> {
  File? image;
  bool imagview = false;
  sendMessage() async {
    final sender = widget.sender.userId;
    final dest = widget.destinataire.userId;
    if (messageController.text.trim().isNotEmpty) {
      Message message = Message(
        idMessage: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: sender,
        destId: dest,
        image: '',
        text: messageController.text,
      );

      await message.sendRealTime();
    }
  }

  sendImage() {
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
                      onPressed: () {},
                      child: Text("envoyer",
                          style: styleText.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                  : Container()
            ],
          );
        });
  }

  TextEditingController messageController = TextEditingController();
  late ScrollController controller;

  var list = ["Un Message"];
  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.portrait
          ? AppBar(
              title: ListTile(
                title: Text(
                  widget.destinataire.userName,
                  style: styleText.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                leading: widget.destinataire.userProfile != null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.destinataire.userProfile!),
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"),
                        backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                      ),
                subtitle: Text(
                  "En ligne",
                  style: styleText,
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          Flexible(
              child: StreamBuilder<List<Message>>(
                  stream: Message.inboxListrealTime(
                      senderId: widget.sender.userId,
                      destId: widget.destinataire.userId),
                  builder: (context, snapshot) {
                    // return snapshot.hasError
                    //     ? Center(
                    //         child: Text(
                    //           snapshot.error.toString(),
                    //           style: styleText.copyWith(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 18,
                    //               color: Colors.red),
                    //         ),
                    //       )
                    return (snapshot.hasData && snapshot.data!.isNotEmpty)
                        ? ListView.builder(
                            reverse: true,
                            controller: controller,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Wrap(
                                alignment: widget.sender.userId ==
                                        snapshot.data![index].senderId
                                    ? WrapAlignment.end
                                    : WrapAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: widget.sender.userId ==
                                            snapshot.data![index].senderId
                                        ? EdgeInsets.only(
                                            left: taille(context).width * 0.25,
                                            top: 3,
                                            bottom: 3,
                                            right: 20)
                                        : EdgeInsets.only(
                                            left: 20,
                                            top: 3,
                                            bottom: 3,
                                            right:
                                                taille(context).width * 0.25),
                                    decoration: BoxDecoration(
                                        color: widget.sender.userId ==
                                                snapshot.data![index].senderId
                                            ? const Color.fromRGBO(
                                                40, 173, 193, 1)
                                            : const Color.fromRGBO(
                                                222, 220, 220, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      snapshot.data![index].text,
                                      style: styleText.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: widget.sender.userId ==
                                                  snapshot.data![index].senderId
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            })
                        : (snapshot.hasData && snapshot.data!.isEmpty)
                            ? Center(
                                child: Text(
                                  'Commencer une conversation',
                                  style: styleText.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator());
                  })),
          Container(
            height: 117,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 225, 247, 250)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10, right: 3, top: 8),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 3,
                            minLines: 1,
                            style: styleText,
                            controller: messageController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 12.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: "Tapez votre message",
                                hintStyle: styleText.copyWith(
                                    color: const Color.fromARGB(
                                        255, 185, 196, 198)),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(130, 255, 255, 255),
                                suffixIcon: const Icon(
                                  Icons.emoji_emotions_rounded,
                                  color: Color.fromARGB(255, 185, 196, 198),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () {
                            if (messageController.text.trim().isNotEmpty) {
                              sendMessage();
                              setState(() {
                                messageController.clear();
                              });
                              controller.addListener(() {});
                            }
                          },
                          child: const FaIcon(Icons.send,
                              color: Color.fromRGBO(40, 173, 193, 1), size: 30),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(Icons.video_call,
                                color: Color.fromRGBO(40, 173, 193, 1),
                                size: 30)),
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(Icons.call,
                                color: Color.fromRGBO(40, 173, 193, 1),
                                size: 30)),
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(Icons.alternate_email,
                                color: Color.fromRGBO(40, 173, 193, 1),
                                size: 30)),
                        IconButton(
                            onPressed: () {
                              sendImage();
                            },
                            icon: const FaIcon(Icons.camera_alt_sharp,
                                color: Color.fromRGBO(40, 173, 193, 1),
                                size: 30)),
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(Icons.mic,
                                color: Color.fromRGBO(40, 173, 193, 1),
                                size: 30))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
