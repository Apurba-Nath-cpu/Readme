import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String work;
  final String uid;
  final String username;
  final String lang;
  final String type;
  final String genre;
  final String audience;
  final String postId;
  final datePublished;
  final String profImage;
  final likes;

  const Post({
    required this.title,
    required this.work,
    required this.uid,
    required this.username,
    required this.lang,
    required this.type,
    required this.genre,
    required this.audience,
    required this.postId,
    required this.datePublished,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'tcontent': work,
    'uid': uid,
    'username': username,
    'lang': lang,
    'type': type,
    'genre': genre,
    'audience': audience,
    'postId': postId,
    'datePublished': datePublished,
    'profImage': profImage,
    'likes': likes,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      title: snapshot['title'],
      work: snapshot['work'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      lang: snapshot['lang'],
      type: snapshot['type'],
      genre: snapshot['genre'],
      audience: snapshot['audience'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
