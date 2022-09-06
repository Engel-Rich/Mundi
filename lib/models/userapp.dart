import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minka/variable.dart';

class UserApp {
  final String? userPhoneNumber;
  final String userName;
  final String? userEmail;
  final String userId;
  final String? userProfile;

  UserApp(
      {required this.userId,
      required this.userName,
      this.userEmail,
      this.userPhoneNumber,
      this.userProfile});

  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
        userId: json['userId'],
        userName: json['userName'] ?? " ",
        userEmail: json['userEmail'],
        userPhoneNumber: json['userPhoneNumber'],
        userProfile: json['userProfile'],
      );
  Map<String, dynamic> toMap() => {
        'userId': userId,
        "userName": userName,
        "userEmail": userEmail,
        "userPhoneNumber": userPhoneNumber,
        'userProfile': userProfile,
      };
  register() async {
    try {
      final doc = await userCollection.doc(userId).get();
      if (doc.exists) {
        await userCollection.doc(userId).update(toMap());
      } else {
        await userCollection.doc(userId).set(toMap());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//
  factory UserApp.fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      UserApp.fromJson(snapshot.data()!);

//
  static Stream<List<UserApp>> userList() =>
      userCollection.snapshots().map((snapshots) =>
          snapshots.docs.map((usr) => UserApp.fromJson(usr.data())).toList());
  static Future<UserApp> userLog(uid) async {
    final doc = await userCollection.doc(uid).get();
    print(doc);
    if (!doc.exists) {
      await userCollection.doc(uid).set({'userId': uid});
      print("get succes : ${UserApp.fromFirestore(doc).userId}");
    }
    return UserApp.fromFirestore(doc);
  }

//
  static update(UserApp userApp) async {
    await userCollection.doc(userApp.userId).update(userApp.toMap());
  }

//
  static Future<UserApp> userapp(String uid) async {
    final snapshot = await userCollection.doc(uid).get();
    return UserApp.fromFirestore(snapshot);
  }

  //
  static UserApp userfromfireba(User user) => UserApp(
        userId: user.uid,
        userName: user.displayName ?? " ",
        userEmail: user.email,
        userProfile: user.photoURL,
        userPhoneNumber: user.phoneNumber,
      );

  static Stream<UserApp>  userLogin() =>
      auth.authStateChanges().map((user) => UserApp.userfromfireba(user!));
  // static Future<UserApp> userapps()
  static Stream<UserApp> oneUser(uid) =>
      userCollection.where("userId", isEqualTo: uid).snapshots().map(
            (userapp) => userapp.docs
                .map(
                  (element) => UserApp(
                      userId: element.data()['userId'],
                      userName: element.data()['userName'],
                      userEmail: element.data()['userEmail'],
                      userProfile: element.data()['userProfile'],
                      userPhoneNumber: element.data()['userPhoneNumber']),
                )
                .toList()
                .first,
          );
}
