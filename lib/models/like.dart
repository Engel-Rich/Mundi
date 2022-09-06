import 'package:minka/models/publication.dart';
import 'package:minka/variable.dart';

class Likes {
  Publication publication;
  String userId;

  Likes({required this.userId, required this.publication});
  save() async {
    final ref = await likeRealtime.child(publication.pubid).child(userId).get();
    if (ref.exists) {
      await likeRealtime.child(publication.pubid).child(userId).remove();
    } else {
      await likeRealtime
          .child(publication.pubid)
          .child(userId)
          .set({"like": true});
    }
  }

//
  static Stream<int> contlike(Publication pub) => likeRealtime
      .child(pub.pubid)
      .onValue
      .map((event) => event.snapshot.children.length);
  static Stream<bool> likedByMe(String idu, Publication pub) => likeRealtime
      .child(pub.pubid)
      .onValue
      .map((event) => event.snapshot.child(idu).exists);

//
  remove() async {
    await likeRealtime.child(publication.pubid).child(userId).remove();
  }
}
