import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:minka/Interfaces/app/home.dart';
import 'package:minka/Interfaces/app/setusersinfos.dart';
import 'package:minka/Interfaces/securite/login.dart';
// import 'package:minka/Interfaces/securite/validpassword.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:minka/variable.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameradescription = await availableCameras();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(const Mundi());
}

class Mundi extends StatefulWidget {
  const Mundi({Key? key}) : super(key: key);

  @override
  State<Mundi> createState() => _MundiState();
}

class _MundiState extends State<Mundi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
      ),
      home: StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            return snapshot.data == null
                ? const Login()
                : (snapshot.data!.displayName == null ||
                        snapshot.data!.displayName!.trim().isEmpty)
                    ? SetUserInfos(user: snapshot.data!)
                    : const HomePage();
          }),
    );
  }
}
