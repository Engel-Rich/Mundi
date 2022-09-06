// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minka/models/storie.dart';
// import 'package:minka/models/userapp.dart';
import 'package:minka/variable.dart';
// import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
// import 'package:video_player/video_player.dart';

class StoriesScreen extends StatefulWidget {
  final List<Storie> stories;
  const StoriesScreen({Key? key, required this.stories}) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  PageController? pageController;
  // VideoPlayerController? videoPlayerController;
  StoryController storyController = StoryController();
  int currentIndex = 0;
  List<StoryItem?> listStory() => widget.stories.map((storie) {
        if (storie.image != null && storie.image!.trim().isNotEmpty) {
          return StoryItem.pageImage(
              duration: const Duration(seconds: 7),
              url: storie.image!,
              controller: storyController,
              caption: '');
        }
        if ((storie.texte != null && storie.texte!.isNotEmpty)) {
          return StoryItem.text(
            title: storie.texte!,
            duration: const Duration(seconds: 7),
            backgroundColor: const Color.fromRGBO(62, 139, 134, 1),
            textStyle: styleText.copyWith(
              color: Colors.white70,
              fontSize: 25,
            ),
          );
        }
      }).toList();
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final story = widget.stories[currentIndex];
    return Scaffold(
        backgroundColor: const Color.fromRGBO(62, 139, 134, 1),
        body: StoryView(
          storyItems: listStory(),
          controller: storyController,
          progressPosition: ProgressPosition.top,
          onComplete: () {
            Navigator.of(context).pop();
          },
        )
        // GestureDetector(
        //   onTapDown: (detail) => tapDown(detail, story),
        //   child: PageView.builder(
        //       physics: const NeverScrollableScrollPhysics(),
        //       itemCount: widget.stories.length,
        //       controller: pageController,
        //       itemBuilder: (context, index) {
        //         if (widget.stories[index].image != null &&
        //             widget.stories[index].image!.trim().isNotEmpty) {
        //           return Container(
        //             width: double.infinity,
        //             color: const Color.fromRGBO(62, 139, 134, 1),
        //             child: FittedBox(
        //               fit: BoxFit.contain,
        //               child: CachedNetworkImage(
        //                 imageUrl: widget.stories[index].image!,
        //                 placeholder: (context, url) => const Center(
        //                     child: SizedBox(
        //                         height: 50,
        //                         width: 50,
        //                         child: Spink(
        //                           couleur: Colors.white,
        //                           size: 45,
        //                         ))),
        //                 errorWidget: (context, url, error) => const Center(
        //                   child: Icon(Icons.error),
        //                 ),
        //               ),
        //             ),
        //           );
        //         } else {
        //           return Container(
        //               color: const Color.fromRGBO(62, 139, 134, 1),
        //               height: double.infinity,
        //               width: double.infinity,
        //               child: Center(
        //                 child: Wrap(
        //                   children: [
        //                     Text(
        //                       widget.stories[index].texte!,
        //                       style: styleText.copyWith(
        //                         color: Colors.white70,
        //                         fontSize: 25,
        //                       ),
        //                       textAlign: TextAlign.center,
        //                     ),
        //                   ],
        //                 ),
        //               ));
        //         }
        //       }),
        // ),
        );
  }

  tapDown(TapDownDetails tapDownDetails, Storie storie) {
    double largeur = taille(context).width;
    double dx = tapDownDetails.globalPosition.dx;
    if (dx < largeur / 2) {
      setState(() {
        if (currentIndex - 1 >= 0) {
          currentIndex -= 1;
        }
      });
    } else if (dx >= largeur / 2) {
      setState(() {
        if (currentIndex + 1 <= 0 * widget.stories.length) {
          currentIndex += 1;
        } else {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
