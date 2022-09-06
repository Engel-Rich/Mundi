import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:minka/Interfaces/app/imagepreview.dart';
import 'package:minka/variable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  Future<void>? cameraValue;

  takeImage(BuildContext context) async {
    final path =
        join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    await _cameraController.takePicture();
    final file = File(path);
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ImagePreview(file: file);
    }));
  }

  @override
  void initState() {
    _cameraController =
        CameraController(cameradescription![0], ResolutionPreset.max);
    cameraValue = _cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: taille(context).height,
        child: Stack(children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.done)
                    ? Flexible(child: CameraPreview(_cameraController))
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: taille(context).width,
              color: Colors.red,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.flash_off)),
                    IconButton(
                        onPressed: () {
                          takeImage(context);
                        },
                        icon: const Icon(Icons.panorama_fish_eye, size: 70)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.flip_camera_ios)),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
