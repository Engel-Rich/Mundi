import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:minka/Interfaces/securite/validcode.dart';
import 'package:minka/backend/authencation.dart';
import 'package:minka/variable.dart';
import 'package:page_transition/page_transition.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // les varibles et fonctions

  TextEditingController nomController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  // final validator = null;

  String userPhoneNumber = "";
  oncodeSend(String value, int? value1) {
    Navigator.push(
      context,
      PageTransition(
        child: ValideCode(
            verificationId: value,
            userName: nomController.text,
            phoneNumber: userPhoneNumber),
        type: PageTransitionType.fade,
      ),
    );
  }

  sendCodeOTP() {
    if (userPhoneNumber.isNotEmpty) {
      authentication(userPhoneNumber,
          onCodeSend: oncodeSend,
          onAutoVerify: onAutoVerify, onFailed: (excep) {
        debugPrint(excep.code.toString());
      }, autoRetrieval: (phone) {});
      setState(() {
        loading = false;
      });
    }
  }

  // end  variable
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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                specervertical(68),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 98),
                  child: Image.asset(
                    "assets/log.png",
                    height: 150,
                  ),
                ),
                specervertical(20),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IntlPhoneField(
                        initialCountryCode: "CM",
                        onChanged: (value) {
                          setState(() {
                            userPhoneNumber = value.completeNumber;
                          });
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      )),
                ),
                // Second champs du formulaire.
                specervertical(5),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Nom d'utilisateur",
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: nomController,
                      validator: (val) {
                        return val!.trim().isEmpty
                            ? "Veillez saisr le nom"
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: "Eenter le nom",
                        hintStyle: styleText,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),

                specervertical(140),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "En vous inscrivant sur la plateforme vous acceptez la politique de confidentialité et les termes d’utilisatiion",
                    style: styleText.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                specervertical(19),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                        ),
                      ),
                      onPressed: () {
                        if (!loading) {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            sendCodeOTP();
                          }
                        }
                      },
                      child: loading
                          ? const Spink(
                              size: 45,
                              couleur: Colors.white,
                            )
                          : Text(
                              'Creer mon compte'.toUpperCase(),
                              style: styleText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Vous avez déjà un compte ? ',
                        style: styleText.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Se connecter",
                          style: styleText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // fontSize: 12,
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
      ),
    );
  }
}
