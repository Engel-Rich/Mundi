import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minka/Interfaces/add/addpublication.dart';
import 'package:page_transition/page_transition.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(
              FontAwesomeIcons.commentDots,
              color: Colors.black,
            ),
          ),
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
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const AddPublication(),
                  duration: const Duration(milliseconds: 1350),
                  reverseDuration: const Duration(milliseconds: 1350),
                  type: PageTransitionType.topToBottom));
            },
            child: Image.asset('assets/log.png', height: 70, width: 50)),
        backgroundColor: Colors.white,
        elevation: 2.0,
      ),
    );
  }
}
