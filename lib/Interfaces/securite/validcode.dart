import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minka/backend/authencation.dart';
import 'package:minka/main.dart';
import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class ValideCode extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String? userName;
  const ValideCode({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
    this.userName,
  }) : super(key: key);

  @override
  State<ValideCode> createState() => _ValideCodeState();
}

class _ValideCodeState extends State<ValideCode> {
  final auth = FirebaseAuth.instance;
  bool resend = false;
  int count = 30;
  String inputCode = '';
  bool loading = false;
  late Timer timer;
  decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count < 1) {
        timer.cancel();
        count = 30;
        resend = true;
        setState(() {});
      }
      count--;
      setState(() {});
    });
  }

  onverifySms() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      if (widget.userName != null) {
        await ValidateOPT(
            smsCode: inputCode,
            verificationId: widget.verificationId,
            nomUser: widget.userName);
      } else {
        await ValidateOPT(
            smsCode: inputCode, verificationId: widget.verificationId);
      }
      setState(() {});
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        PageTransition(child: const Mundi(), type: PageTransitionType.fade));
  }

  validationAutomatique() async {}

  @override
  void initState() {
    decompte();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              specervertical(45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 98),
                child: Image.asset(
                  "assets/log.png",
                  height: 200,
                  // width: 242.62,
                ),
              ),
              specervertical(31),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.5),
                child: Text(
                  "Un code de confirmation a été envoyé  à votre numéro de téléphone, vueillez le saisir ci dessous",
                  style: styleText.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ),
              specervertical(32),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "code de vérification",
                      style: styleText.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Pinput(
                    onChanged: (val) {
                      setState(() {
                        inputCode = val;
                      });
                    },
                    length: 6,
                  ),
                ),
              ),
              specervertical(6),
              Row(
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                          resend ? 'renvoyer le code ' : count.toString(),
                          style: styleText)),
                ],
              ),
              specervertical(150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(40, 173, 193, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    onPressed: () {
                      onverifySms();
                      setState(() {
                        loading = false;
                      });
                    },
                    child: !loading
                        ? Text(
                            'envoyer le code'.toUpperCase(),
                            style: styleText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Spink(
                            size: 45,
                            couleur: Colors.white,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const Mundi(),
                              type: PageTransitionType.fade),
                        );
                      },
                      child: Text(
                        "REVENIR À L'ACCEUIL",
                        style: styleText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
