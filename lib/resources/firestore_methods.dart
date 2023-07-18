import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_reader/models/post.dart';
import 'package:ebook_reader/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

// import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost({
    required String title,
    required String work,
    required String uid,
    required String username,
    required String lang,
    required String type,
    required String genre,
    required String audience,
    required String profImage,
  }) async {
    String res = "Some error occured";
    try {
      // String photoUrl =
      // await StorageMethods()
      //     .uploadImageTostorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = await Post(
        title: title,
        work: work,
        uid: uid,
        username: username,
        lang: lang,
        type: type,
        genre: genre,
        audience: audience,
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likePost({required String postId, required String uid, required List likes}) async {
    if (likes.contains(uid)) {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
  Future<bool> isLiked({required String postId, required String uid, required List likes}) async {
    if (likes.contains(uid)) {
      print('tl');
      return true;
    }
    else{
      print('fl');
      return false;
    }
  }

  Future<void> commentOnPost(String postId, String uid, String name,
      String comment, String profilePic) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'postId': postId,
          'text': comment,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        print('Text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likeComment(
      String postId, String uid, String commentId, List commentLikes) async {
    if (commentLikes.contains(uid)) {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
