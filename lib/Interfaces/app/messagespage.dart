import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minka/Interfaces/app/inboxchat.dart';
import 'package:minka/models/messages.dart';
import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class ChatUi extends StatefulWidget {
  final UserApp userApp;
  const ChatUi({Key? key, required this.userApp}) : super(key: key);

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  UserApp? userApp;
  initUser() {
    // final utilisateur = await UserApp.userapp(auth.currentUser!.uid);
    setState(() {
      userApp = widget.userApp;
    });
  }

  @override
  void initState() {
    initUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [Center(child: FaIcon(Icons.more_vert))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              children: [
                Text("Vos amis en ligne",
                    style: styleText.copyWith(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
          ),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Card(
              child: StreamBuilder<List<UserApp>>(
                  stream: UserApp.userList(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: auth.currentUser!.uid !=
                                        snapshot.data![index].userId
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageTransition(
                                              child: InboxTchat(
                                                  destinataire:
                                                      snapshot.data![index],
                                                  sender: userApp!),
                                              type: PageTransitionType.fade,
                                              // duration: const Duration(
                                              //     milliseconds: 750),
                                              // reverseDuration: const Duration(
                                              //     milliseconds: 750),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: snapshot.data![index]
                                                          .userProfile !=
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(snapshot
                                                              .data![index]
                                                              .userProfile!),
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              217, 217, 217, 1),
                                                      radius: 30,
                                                    )
                                                  : const CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          "assets/profile.png"),
                                                      backgroundColor:
                                                          // ignore: unnecessary_const
                                                          const Color.fromRGBO(
                                                              217, 217, 217, 1),
                                                      radius: 30,
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 90,
                                              child: Text(
                                                snapshot.data![index].userName,
                                                overflow: TextOverflow.ellipsis,
                                                style: styleText.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              );
                            })
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ShimmerEffet.circular(
                                    hauter: 64, largeur: 64),
                              );
                            });
                  }),
            ),
          ),
          StreamBuilder<List<Discution>>(
              stream: Discution.getdiscutionlistRealTime(widget.userApp.userId),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return discutionUi(snapshot.data![index], userApp!);
                          }));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const ShimmerEffet.circular(
                                hauter: 40, largeur: 40),
                            title: ShimmerEffet.rectangle(
                                hauter: 10,
                                largeur: taille(context).width * 0.7),
                            subtitle: ShimmerEffet.rectangle(
                                hauter: 10,
                                largeur: taille(context).width * 0.3),
                          );
                        }),
                  );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showbottom(),
        // ignore: sort_child_properties_last
        child: const Icon(FontAwesomeIcons.comment,
            size: 30, color: Color.fromARGB(255, 40, 173, 193)),
        backgroundColor: const Color.fromARGB(255, 225, 247, 250),
      ),
    );
  }

  Future showbottom() => showSlidingBottomSheet(
        context,
        builder: (context) => SlidingSheetDialog(
          cornerRadius: 20,
          avoidStatusBar: true,
          snapSpec: const SnapSpec(snappings: [.3, .4, .5, .6, .7, .8, .9, 1]),
          builder: builSheet,
          headerBuilder: (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.blue,
                height: 40,
                child: Center(
                  child: Container(
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  Widget builSheet(context, state) => Material(
        child: StreamBuilder<List<UserApp>>(
            stream: UserApp.userList(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Center(
                          child: snapshot.data![index].userId !=
                                  auth.currentUser!.uid
                              ? ListTile(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(PageTransition(
                                      child: InboxTchat(
                                          destinataire: snapshot.data![index],
                                          sender: userApp!),
                                      type: PageTransitionType.leftToRight,
                                    ));
                                  },
                                  // focusColor: Colors.red,
                                  leading: snapshot.data![index].userProfile !=
                                          null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data![index].userProfile!),
                                          backgroundColor: const Color.fromRGBO(
                                              217, 217, 217, 1),
                                        )
                                      : const CircleAvatar(
                                          backgroundImage:
                                              AssetImage("assets/profile.png"),
                                          backgroundColor:
                                              Color.fromRGBO(217, 217, 217, 1),
                                        ),
                                  title: Text(
                                    snapshot.data![index].userName,
                                    style: styleText.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                    )
                  : snapshot.hasError
                      ? Center(
                          child: Text(snapshot.error.toString(),
                              style: styleText.copyWith(color: Colors.red)))
                      : const Center(
                          child: ListTile(
                          leading:
                              ShimmerEffet.circular(hauter: 60, largeur: 60),
                          title:
                              ShimmerEffet.rectangle(hauter: 16, largeur: 20),
                          subtitle:
                              ShimmerEffet.rectangle(hauter: 16, largeur: 20),
                        ));
            }),
      );

  discutionUi(Discution discution, UserApp sender) {
    return discution.senderId == auth.currentUser!.uid
        ? StreamBuilder<UserApp>(
            stream: UserApp.oneUser(discution.destId),
            builder: (context, user) {
              return user.hasData
                  ? ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: InboxTchat(
                                destinataire: user.data!, sender: userApp!),
                            type: PageTransitionType.fade,
                            // duration: const Duration(milliseconds: 750),
                            // reverseDuration: const Duration(milliseconds: 750),
                          ),
                        );
                      },
                      title: Text(
                        user.data!.userName,
                        style: styleText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: (discution.texte != null &&
                              discution.texte!.isNotEmpty)
                          ? Text(
                              discution.texte!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleText.copyWith(),
                            )
                          : discution.senderId == auth.currentUser!.uid
                              ? Text(
                                  'vous avez reçus une image',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleText.copyWith(),
                                )
                              : Text(
                                  'vous avez envoyé une image',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleText.copyWith(),
                                ),
                      leading: (user.data!.userProfile != null &&
                              user.data!.userProfile!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 217, 217, 217),
                              backgroundImage:
                                  NetworkImage(user.data!.userProfile!),
                              radius: 25,
                            )
                          : const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 217, 217, 217),
                              backgroundImage: AssetImage("assets/persone.png"),
                            ),
                      trailing: discution.destId == auth.currentUser!.uid
                          ? CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.green,
                              child: Text(
                                discution.messagesNonLus.toString(),
                                style: styleText.copyWith(color: Colors.white),
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  : ListTile(
                      leading:
                          const ShimmerEffet.circular(hauter: 40, largeur: 40),
                      title: ShimmerEffet.rectangle(
                          hauter: 10, largeur: taille(context).width * 0.7),
                      subtitle: ShimmerEffet.rectangle(
                          hauter: 10, largeur: taille(context).width * 0.3),
                    );
            })
        : StreamBuilder<UserApp>(
            stream: UserApp.oneUser(discution.senderId),
            builder: (context, user) {
              return user.hasData
                  ? ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: InboxTchat(
                                destinataire: user.data!, sender: userApp!),
                            type: PageTransitionType.fade,
                            // duration: const Duration(milliseconds: 750),
                            // reverseDuration: const Duration(milliseconds: 750),
                          ),
                        );
                        discution.read();
                      },
                      title: Text(
                        user.data!.userName,
                        style: styleText.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: (discution.texte != null &&
                              discution.texte!.isNotEmpty)
                          ? Text(
                              discution.texte!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: styleText.copyWith(),
                            )
                          : discution.senderId == auth.currentUser!.uid
                              ? Text(
                                  'vous avez reçus une image',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleText.copyWith(),
                                )
                              : Text(
                                  'vous avez envoyé une image',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleText.copyWith(),
                                ),
                      leading: (user.data!.userProfile != null &&
                              user.data!.userProfile!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 217, 217, 217),
                              backgroundImage:
                                  NetworkImage(user.data!.userProfile!),
                              radius: 25,
                            )
                          : const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 217, 217, 217),
                              backgroundImage: AssetImage("assets/persone.png"),
                            ),
                      trailing: (discution.destId == auth.currentUser!.uid &&
                              discution.messagesNonLus != 0)
                          ? CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.green,
                              child: Text(
                                discution.messagesNonLus.toString(),
                                style: styleText.copyWith(color: Colors.white),
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  : ListTile(
                      leading:
                          const ShimmerEffet.circular(hauter: 40, largeur: 40),
                      title: ShimmerEffet.rectangle(
                          hauter: 10, largeur: taille(context).width * 0.7),
                      subtitle: ShimmerEffet.rectangle(
                          hauter: 10, largeur: taille(context).width * 0.3),
                    );
            });
  }
}
