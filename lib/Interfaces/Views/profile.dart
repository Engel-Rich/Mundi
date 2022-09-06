import 'package:flutter/material.dart';
import 'package:minka/Interfaces/Views/storiescreen.dart';
import 'package:minka/Interfaces/add/statutaddpage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:minka/Interfaces/add/addpublication.dart';
import 'package:minka/models/publication.dart';
import 'package:minka/models/storie.dart';
import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:page_transition/page_transition.dart';

class ProfileUser extends StatefulWidget {
  final UserApp userApp;
  const ProfileUser({Key? key, required this.userApp}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const FaIcon(
      //         FontAwesomeIcons.commentDots,
      //         color: Colors.black,
      //       ),
      //     ),
      //     IconButton(
      //       onPressed: () {},
      //       icon: const FaIcon(
      //         Icons.notifications_outlined,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ],
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: Image.asset("assets/icon.png", height: 80, width: 50),
      //   ),
      //   title: InkWell(
      //       onTap: () {
      //         Navigator.of(context).push(PageTransition(
      //             child: const AddPublication(),
      //             duration: const Duration(milliseconds: 1350),
      //             reverseDuration: const Duration(milliseconds: 1350),
      //             type: PageTransitionType.topToBottom));
      //       },
      //       child: Image.asset('assets/log.png', height: 70, width: 50)),
      //   backgroundColor: Colors.white,
      //   elevation: 2.0,
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              specervertical(50),
              widget.userApp.userProfile == null
                  ? const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                      backgroundImage: AssetImage("assets/profile.png"),
                    )
                  : CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                      backgroundImage:
                          NetworkImage(widget.userApp.userProfile!),
                    ),
              specervertical(16),
              Text(widget.userApp.userName,
                  style: styleText.copyWith(
                      fontSize: 16,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600)),
              widget.userApp.userId != utilisateurApp!.uid
                  ? Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Text('4km',
                          style: styleText.copyWith(
                            color: Colors.grey.shade400,
                          )),
                    )
                  : const Text(""),
              Text("134 amis",
                  style: styleText.copyWith(
                    color: Colors.grey.shade500,
                  )),
              widget.userApp.userId != utilisateurApp!.uid
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 40, 173, 193),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Center(
                                child: Text(
                                  'Message',
                                  style: styleText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            width: 120,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 185, 196, 198),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Center(
                                child: Text(
                                  'Suivre',
                                  style: styleText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Shorts",
                      style: styleText.copyWith(
                        fontSize: 18,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 220,
                child: StreamBuilder<List<Storie>>(
                    stream: Storie.stories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Stack(
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 5),
                                    child: Stack(
                                      children: [
                                        StreamBuilder<List<Storie>>(
                                            stream: Storie.storipersonel(
                                                snapshot
                                                    .data![index].userstoreie),
                                            builder: (context, snaps) {
                                              return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        PageTransition(
                                                            child: StoriesScreen(
                                                                stories: snaps
                                                                    .data!),
                                                            type:
                                                                PageTransitionType
                                                                    .fade));
                                                  },
                                                  child: storie(
                                                      snapshot.data![index]));
                                            }),
                                        Positioned(
                                            top: 3,
                                            right: 3,
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    Colors.blue.shade50,
                                                child: Text(snapshot
                                                    .data![index].total
                                                    .toString())))
                                      ],
                                    ));
                              },
                            ),
                            Positioned(
                              top: 2,
                              right: 3,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageTransition(
                                      child: const StatuAdd(),
                                      type: PageTransitionType.fade));
                                },
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Color.fromARGB(255, 225, 247, 250),
                                  child: Icon(
                                    Icons.add,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context).push(PageTransition(
                                child: const StatuAdd(),
                                type: PageTransitionType.fade));
                          },
                          child: Text(
                            "Add new Storie",
                            style: styleText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Spink(),
                        );
                      }
                    }),
              ),
              specervertical(10),
              StreamBuilder<List<Publication>>(
                  stream: Publication.publicationsUser(widget.userApp.userId),
                  builder: (context, snapshot) {
                    // print(snapshot.error);
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        snapshot.error.toString(),
                        style: styleText.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                            fontSize: 18),
                      ));
                    }
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return publicationUi(
                                  context, snapshot.data![index], true);
                            })
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
