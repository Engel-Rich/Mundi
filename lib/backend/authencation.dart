// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';

void authentication(String userPhoneNumber,
    {required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAutoVerify,
    required Function(FirebaseAuthException exception) onFailed,
    required Function(String value) autoRetrieval}) async {
  await auth.verifyPhoneNumber(
    phoneNumber: userPhoneNumber,
    verificationCompleted: onAutoVerify,
    verificationFailed: onFailed,
    codeSent: onCodeSend,
    codeAutoRetrievalTimeout: autoRetrieval,
  );
}

// ignore: non_constant_identifier_names
ValidateOPT(
    {required String smsCode,
    required String verificationId,
    String? nomUser}) async {
  final credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );
  final user = await auth.signInWithCredential(credential);
  if (nomUser != null) {
    final utilisateur = user.user;
    await utilisateur?.updateDisplayName(nomUser);
    final userapp = UserApp(
        userId: utilisateur!.uid,
        userName: nomUser,
        userPhoneNumber: utilisateur.phoneNumber,
        userProfile: utilisateur.photoURL,
        userEmail: utilisateur.email);
    await userapp.register();
  }
  return;
}

logOut(BuildContext context) async {
  await auth.signOut();
  // Navigator.pushReplacement(
  //     context,
  //     PageTransition(
  //         child: const MyApp(), type: PageTransitionType.bottomToTop));
  // return;
}

onAutoVerify(PhoneAuthCredential phoneAuthCredential) async {
  await auth.signInWithCredential(phoneAuthCredential);
}
