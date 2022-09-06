import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:minka/Interfaces/securite/register.dart';
import 'package:minka/Interfaces/securite/validcode.dart';
import 'package:minka/backend/authencation.dart';

import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;

  String userPhoneNumber = "";
  onCodesend(String value, int? val) {
    Navigator.push(
      context,
      PageTransition(
        child: ValideCode(verificationId: value, phoneNumber: userPhoneNumber),
        type: PageTransitionType.fade,
      ),
    );
  }

  onSendOtp() {
    debugPrint("printing click");
    if (!loading) {
      setState(() {
        loading = true;
      });
      setState(() {});
      debugPrint("Loading $loading");
      if (userPhoneNumber.isNotEmpty) {
        authentication(
          userPhoneNumber,
          onCodeSend: onCodesend,
          onAutoVerify: onAutoVerify,
          onFailed: (e) {
            debugPrint(e.toString());
          },
          autoRetrieval: (phone) {},
        );
        setState(() {
          loading = false;
        });
      } else {
        snack(context: context, msg: "Numéro de téléphone invalide");
        setState(() {
          loading = false;
        });
      }
    }
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
              specervertical(76),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 98),
                child: Image.asset(
                  "assets/log.png",
                  height: 200,
                ),
              ),
              specervertical(39),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                ),
                child: Row(
                  children: [
                    Text(
                      "Numéro de téléphone",
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: IntlPhoneField(
                      initialCountryCode: "CM",
                      onChanged: (val) {
                        setState(() {
                          userPhoneNumber = val.completeNumber;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    )),
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
                    onPressed: () => onSendOtp(),
                    child: !loading
                        ? Text(
                            'connexion'.toUpperCase(),
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
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'vous n\'aves pas encore de comptes ? ',
                      style: styleText.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              child: const Register(),
                              type: PageTransitionType.bottomToTop),
                        );
                      },
                      child: Text(
                        "Creer mon compte",
                        style: styleText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
