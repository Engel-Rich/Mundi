// ignore_for_file: use_key_in_widget_constructors

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:minka/Interfaces/Views/profile.dart';
import 'package:minka/models/like.dart';
import 'package:minka/models/publication.dart';
import 'package:minka/models/storie.dart';
import 'package:minka/models/userapp.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

Size taille(BuildContext context) => MediaQuery.of(context).size;
Widget specervertical(double taille) => SizedBox(height: taille);

TextStyle styleText = GoogleFonts.poppins();
final auth = FirebaseAuth.instance;

snack(
    {required BuildContext context, required String msg, Function()? valide}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: styleText),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      onVisible: valide));
}

drawerelement(
    {required Function()? ontap,
    IconData? icon,
    required String nom,
    Widget? icones}) {
  return Container(
    margin: const EdgeInsets.only(top: 15.0),
    padding: const EdgeInsets.all(0.0),
    child: ListTile(
      onTap: ontap,
      leading:
          icon != null ? FaIcon(icon, size: 30.0, color: Colors.white) : icones,
      title: Text(
        nom,
        style: styleText.copyWith(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ),
  );
}

class Spink extends StatefulWidget {
  final double? size;
  final Color? couleur;
  const Spink({Key? key, this.size, this.couleur}) : super(key: key);

  @override
  State<Spink> createState() => _SpinkState();
}

class _SpinkState extends State<Spink> with TickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1250));
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitSpinningLines(
        size: widget.size ?? 70,
        color: widget.couleur ?? const Color.fromRGBO(62, 139, 134, 1),
        controller: controller,
      ),
    );
  }
}

final backColors = const Color.fromRGBO(62, 139, 134, 1);
final utilisateurApp = auth.currentUser;
final pubCollection = FirebaseFirestore.instance.collection("Publications");
final userCollection = FirebaseFirestore.instance.collection("Users");
final chatCollection = FirebaseFirestore.instance.collection('Messages');
final storiCollection = FirebaseFirestore.instance.collection("Storie");
final friendCollection = FirebaseFirestore.instance.collection("Friends");
final messagesRealtimeCollection = FirebaseDatabase.instance.ref('Messages');
final chatRealtimeCollection = FirebaseDatabase.instance.ref('Chats');
final likeRealtime = FirebaseDatabase.instance.ref("Liks");
List<CameraDescription>? cameradescription;

// Stireis
//view models
// fonctions  les differntes functions ou wigets complex
Widget storie(Storie stori) {
  return Container(
    height: 224,
    width: 130,
    decoration: BoxDecoration(
      color: const Color.fromARGB(124, 62, 139, 134),
      borderRadius: BorderRadius.circular(15),
      image: stori.image!.trim().isNotEmpty
          ? DecorationImage(
              image: NetworkImage(stori.image!),
              fit: BoxFit.cover,
            )
          : null,
    ),
    child: Stack(
      children: [
        (stori.texte != null && stori.texte!.trim().isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Wrap(
                  children: [
                    Text(
                      stori.texte!,
                      textAlign: TextAlign.center,
                      style: styleText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
              )
            : const SizedBox.shrink(),
        Container(
          height: 224,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.3)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 175,
          left: 8,
          child: Row(
            children: [
              stori.userstoreie.userProfile == null ||
                      stori.userstoreie.userProfile!.isEmpty
                  ? const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage("assets/profile.png"),
                      backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                    )
                  : CircleAvatar(
                      radius: 12,
                      backgroundImage:
                          NetworkImage(stori.userstoreie.userProfile!),
                      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 5),
                child: Text(
                  stori.userstoreie.userName,
                  style: styleText.copyWith(
                      fontWeight: FontWeight.w800, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

toaster(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: const Color.fromRGBO(62, 139, 134, 1),
    );

// publication view model

publicationUi(BuildContext context, Publication publication, bool isdetail) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(
      width: .5,
      color: Colors.grey.shade500,
    )),
    child: FutureBuilder<UserApp>(
        future: UserApp.userapp(publication.uid),
        builder: (context, snapshot) {
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              snapshot.hasData
                  ? ListTile(
                      onTap: () {
                        if (isdetail) {
                          return;
                        } else {
                          Navigator.of(context).push(PageTransition(
                            child: ProfileUser(userApp: snapshot.data!),
                            type: PageTransitionType.fade,
                            // duration: const Duration(milliseconds: 1250),
                          ));
                        }
                      },
                      // focusColor: Colors.red,
                      leading: snapshot.data!.userProfile != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!.userProfile!),
                              backgroundColor:
                                  const Color.fromRGBO(217, 217, 217, 1),
                            )
                          : const CircleAvatar(
                              backgroundImage: AssetImage("assets/profile.png"),
                              backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                            ),
                      title: Text(
                        snapshot.data!.userName,
                        style: styleText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat("E d MM yyyy").format(publication.date),
                        style: styleText,
                      ),
                    )
                  : const ListTile(
                      leading: ShimmerEffet.circular(hauter: 60, largeur: 60),
                      title: ShimmerEffet.rectangle(hauter: 16, largeur: 20),
                      subtitle: ShimmerEffet.rectangle(hauter: 16, largeur: 20),
                    ),
              // specervertical(3),
              publication.texte != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 8),
                      child: ReadMoreText(
                        publication.texte!,
                        trimExpandedText: 'Moins',
                        trimCollapsedText: 'Plus',
                        trimLines: 10,
                        style: styleText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 1.5,
                          wordSpacing: 1.2,
                        ),
                      ))
                  : const SizedBox.shrink(),

              publication.images != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: InkWell(
                        onTap: () {
                          showImageViewer(
                              context, Image.network(publication.images!).image,
                              swipeDismissible: true,
                              backgroundColor: backColors,
                              useSafeArea: true);
                        },
                        onDoubleTap: () {
                          Likes likes = Likes(
                              userId: auth.currentUser!.uid,
                              publication: publication);
                          likes.save();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            publication.images!,
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress == null
                                  ? child
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: ShimmerEffet.rectangle(
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            hauter: 400,
                                            largeur: double.infinity),
                                      ),
                                    );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.amber,
                                height: 230,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Erreur de connection',
                                  style: TextStyle(fontSize: 30),
                                ),
                              );
                            },
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

              SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: InkWell(
                          splashColor: const Color.fromRGBO(62, 139, 134, 1),
                          onTap: () {
                            Likes likes = Likes(
                                userId: auth.currentUser!.uid,
                                publication: publication);
                            likes.save();
                          },
                          child: Container(
                            width: taille(context).width / 2.5,
                            decoration: BoxDecoration(
                                // color: Colors.grey.shade300.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder<bool>(
                                      stream: Likes.likedByMe(
                                          auth.currentUser!.uid, publication),
                                      builder: (context, snapshot) {
                                        return (snapshot.hasData &&
                                                snapshot.data == true)
                                            ? const Icon(Icons.thumb_up,
                                                color: Color.fromRGBO(
                                                    62, 139, 134, 1))
                                            : const Icon(
                                                Icons.thumb_up_outlined,
                                                color: Color.fromRGBO(
                                                    62, 139, 134, 1));
                                      }),
                                  StreamBuilder<int>(
                                      stream: Likes.contlike(publication),
                                      builder: (context, snapshot) {
                                        int count = snapshot.data ?? 0;
                                        return Text(count.toString(),
                                            style: styleText.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600));
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: InkWell(
                          splashColor: const Color.fromRGBO(62, 139, 134, 1),
                          onTap: () {},
                          child: Container(
                            width: taille(context).width / 2.5,
                            decoration: BoxDecoration(
                                // color: Colors.grey.shade300.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.mode_comment_outlined),
                                  Text((10).toString(),
                                      style: styleText.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: InkWell(
                          splashColor: const Color.fromRGBO(62, 139, 134, 1),
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                // color: Colors.grey.shade300.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const FaIcon(
                                    Icons.share,
                                  ),
                                  Text((2).toString(),
                                      style: styleText.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
  );
}

// shimmer effect

class ShimmerEffet extends StatelessWidget {
  final double hauter;
  final double largeur;
  final ShapeBorder shapeBorder;
  // const ShimmerEffet({Key? key}) : super(key: key);

  const ShimmerEffet.rectangle({
    required this.hauter,
    required this.largeur,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const ShimmerEffet.circular({
    required this.hauter,
    required this.largeur,
    this.shapeBorder = const CircleBorder(),
  });
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        // ignore: sort_child_properties_last
        baseColor: Colors.grey[400]!,
        direction: ShimmerDirection.ltr,

        highlightColor: Colors.grey[300]!,
        child: Container(
          height: hauter,
          width: largeur,
          decoration: ShapeDecoration(
            shape: shapeBorder,
            color: Colors.grey[400]!,
          ),
        ),
      );
}
