import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:minka/Interfaces/add/addpublication.dart';
// import 'package:minka/Interfaces/add/cameraspage.dart';
import 'package:minka/Interfaces/add/statutaddpage.dart';
import 'package:minka/Interfaces/app/messagespage.dart';
import 'package:minka/Interfaces/Views/profile.dart';
import 'package:minka/Interfaces/Views/storiescreen.dart';

import 'package:minka/backend/authencation.dart';
import 'package:minka/models/publication.dart';
import 'package:minka/models/storie.dart';
import 'package:minka/models/userapp.dart';

import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scafoldKey,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            StreamBuilder<UserApp>(
                stream: UserApp.userLogin(),
                builder: (context, snapshot) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).push(PageTransition(
                          child: ChatUi(
                            userApp: snapshot.data!,
                          ),
                          childCurrent: const HomePage(),
                          type: PageTransitionType.fade));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.commentDots,
                      color: Colors.black,
                    ),
                  );
                }),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              _scafoldKey.currentState!.openDrawer();
            },
            icon: Image.asset("assets/icon.png", height: 80, width: 50),
          ),
          title: InkWell(
              onTap: () {},
              child: Image.asset('assets/log.png', height: 70, width: 50)),
          backgroundColor: Colors.white,
          elevation: 2.0,
        ),
        drawer: Container(
          margin: EdgeInsets.only(right: taille(context).width * 0.25),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(92, 200, 193, 1),
                Color.fromRGBO(62, 139, 134, 1),
                Color.fromRGBO(22, 60, 57, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            children: [
              (auth.currentUser!.photoURL == null &&
                      auth.currentUser!.photoURL!.isEmpty)
                  ? const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage("assets/log.png"),
                      backgroundColor: Color.fromARGB(255, 217, 217, 217),
                    )
                  : CircleAvatar(
                      radius: 80,
                      backgroundColor: const Color.fromARGB(255, 217, 217, 217),
                      child: ClipOval(
                        child: Image.network(auth.currentUser!.photoURL!),
                      ),
                    ),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  auth.currentUser!.displayName!,
                  textAlign: TextAlign.center,
                  style: styleText.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 5,
                    fontSize: 18,
                  ),
                ),
              ),
              specervertical(10),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              specervertical(10),
              drawerelement(
                ontap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(PageTransition(
                      child: const AddPublication(),
                      // duration: const Duration(milliseconds: 1350),
                      // reverseDuration: const Duration(milliseconds: 1350),
                      type: PageTransitionType.fade));
                },
                icon: Icons.newspaper_rounded,
                nom: 'À quoi pensez vous aujourd\'hui',
              ),
              drawerelement(
                ontap: () {},
                icon: Icons.location_on,
                nom: 'Personnes à proximité',
              ),
              drawerelement(
                ontap: () {},
                icon: Icons.favorite,
                nom: 'mes amies',
              ),
              drawerelement(
                ontap: () {},
                icon: Icons.person_add,
                nom: 'demandes d\'amitié',
              ),
              drawerelement(
                ontap: () {
                  final userp = UserApp(
                    userId: auth.currentUser!.uid,
                    userName: auth.currentUser!.displayName ?? " nn",
                    userEmail: auth.currentUser!.email,
                    userPhoneNumber: auth.currentUser!.phoneNumber,
                    userProfile: auth.currentUser!.photoURL,
                  );
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      PageTransition(
                        child: ProfileUser(userApp: userp),
                        type: PageTransitionType.fade,
                      ));
                },
                icon: Icons.person,
                nom: 'mon profil',
              ),
              const Divider(
                thickness: 2,
                height: 2,
              ),
              drawerelement(
                ontap: () {},
                icon: Icons.settings,
                nom: 'Paramètres',
              ),
              drawerelement(
                ontap: () async {
                  await logOut(context);
                },
                icon: Icons.logout,
                nom: 'Deconnexion',
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            initState();
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                  height: 240,
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
                                                  snapshot.data![index]
                                                      .userstoreie),
                                              builder: (context, snaps) {
                                                return InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(PageTransition(
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
                specervertical(34),
                StreamBuilder<List<Publication>>(
                    stream: Publication.publications(),
                    builder: (context, snapshot) {
                      return snapshot.hasError
                          ? Center(
                              child: Text(
                              snapshot.error.toString(),
                              style: styleText.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red,
                                  fontSize: 18),
                            ))
                          : snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return publicationUi(
                                        context, snapshot.data![index], false);
                                  })
                              : const Center(
                                  child: Spink(),
                                );
                    }),
                specervertical(60)
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await logOut();
        //   },
        //   tooltip: 'Lo',
        //   child: const Icon(Icons.logout),
        // ),
      ),
    );
  }
}
