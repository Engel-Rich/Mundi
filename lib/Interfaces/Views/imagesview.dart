import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final Image image;
  const ImageView({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 30),
          onPressed: () {},
        ),
      ),
    );
  }
}
