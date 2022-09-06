import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';

class Storie {
  final UserApp userstoreie;
  DateTime debut;
  String? texte;
  String? image;
  final String idStorie;
  int total;

  Storie({
    required this.userstoreie,
    required this.debut,
    required this.idStorie,
    this.image,
    this.texte,
    this.total = 0,
  });
  save() async {
    final coll =
        storiCollection.doc(userstoreie.userId).collection("Personelle");
    await storiCollection.doc(userstoreie.userId).get().then((value) {
      if (value.exists) {
        storiCollection.doc(userstoreie.userId).update({
          "User": jsonEncode(userstoreie.toMap()),
          "date": debut,
          "texte": texte,
          "image": image,
          "idStorie": idStorie,
          "total": FieldValue.increment(1),
        });
        coll.doc(idStorie).set({
          "User": jsonEncode(userstoreie.toMap()),
          "date": debut,
          "texte": texte,
          "image": image,
          "idStorie": idStorie,
          'total': 1
        });
      } else {
        storiCollection.doc(userstoreie.userId).set({
          "User": jsonEncode(userstoreie.toMap()),
          "date": debut,
          "texte": texte,
          "image": image,
          "idStorie": idStorie,
          'total': 1
        });
        coll.doc(idStorie).set({
          "User": jsonEncode(userstoreie.toMap()),
          "date": debut,
          "texte": texte,
          "image": image,
          "idStorie": idStorie,
          'total': 1
        });
      }
    });
  }

  //
  toMap() => {
        'texte': texte,
        'image': image,
        "Utilisateur": userstoreie.toMap(),
        'id': idStorie,
        'date': debut,
      };
  //
  factory Storie.fromMap(Map<String, dynamic> map) => Storie(
        userstoreie: UserApp.fromJson(jsonDecode(map['User'])),
        debut: (map['date'] as Timestamp).toDate(),
        idStorie: map['idStorie'],
        texte: map['texte'],
        image: map['image'],
        total: map['total'],
      );

  static Stream<List<Storie>> storipersonel(UserApp userApp) {
    return storiCollection
        .doc(userApp.userId)
        .collection("Personelle")
        .snapshots()
        .map((event) => event.docs  
            .map(
              (e) => Storie.fromMap(e.data()),
            )
            .toList());
  }

  static Stream<List<Storie>> stories() {
    return storiCollection
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Storie.fromMap(e.data()),
            )
            .toList());
  }
}
