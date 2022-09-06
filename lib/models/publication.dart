import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:minka/variable.dart';

class Publication {
  final String uid;
  final String? texte;
  final DateTime date;
  String? images;

  Publication({
    required this.uid,
    required this.date,
    this.images,
    this.texte,
  });

  toMap() => {
        "uid": uid,
        "date": Timestamp.fromDate(date),
        "texte": texte,
        "images": images
      };

  factory Publication.fromMap(Map<String, dynamic> map) => Publication(
        uid: map['uid'],
        date: (map['date'] as Timestamp).toDate(),
        images: map['images'],
        texte: map['texte'],
      );
  save({File? file}) async {
    final publicationcollection = pubCollection.doc();
    if (file != null) {
      final ref = FirebaseStorage.instance.ref("Plublication/Images");
      await ref.child(publicationcollection.id).putFile(file);
      String url = await ref.child(publicationcollection.id).getDownloadURL();
      images = url;
    }
    publicationcollection.set(toMap());
  }

  // factory Publication.fromquerySnapshot(
  //         QueryDocumentSnapshot<Map<String, dynamic>> querySnapshot) =>
  //     Publication.fromMap(querySnapshot.data());
  // // .map((snapshot) => Publication.fromMap(snapshot.data()));

  // streù lsit

  static Stream<List<Publication>> publications() =>
      pubCollection.orderBy("date", descending: true).snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (pub) => Publication.fromMap(
                    pub.data(),
                  ),
                )
                .toList(),
          );

  static Stream<List<Publication>> publicationsUser(String uid) => pubCollection
      .where("uid", isEqualTo: uid)
      .orderBy("date", descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (pub) => Publication.fromMap(
                pub.data(),
              ),
            )
            .toList(),
      );
}
