import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/resources/firestore_methods.dart';
// import 'package:ebook_reader/screens/comment_screen.dart';
import 'package:ebook_reader/utils/utils.dart';
// import 'package:ebook_reader/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:ebook_reader/models/user.dart' as model;
import '../providers/user_provider.dart';
// import '../utils/colors.dart';
import '../utils/global_variables.dart';

// MediaQ
class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool isLikeTapped = false;
  double likeSize = 0;
  int commentsNum = 0;
  // var userData = {};
  // var postData = {};
  // int postLen = 0;
  // int followers = 0;
  // int following = 0;
  // bool isFollowing = false;
  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // getComments();
    // getData();
  }
  // getData() async {
  //   print(widget.uid);
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     var userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.uid)
  //         .get();
  //     var postSnap = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('uid', isEqualTo: widget.uid)
  //         .get();
  //     var postSnap2 = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(widget.uid)
  //         .get();
  //
  //     postLen = postSnap.docs.length ?? 0;
  //     userData = userSnap.data()!;
  //     postData = postSnap2.data()!;
  //     isFollowing = userSnap
  //         .data()!['followers']
  //         .contains(FirebaseAuth.instance.currentUser!.uid);
  //     followers = userData['followers']?.length;
  //     following = userData['following']?.length;
  //     setState(() {});
  //   } catch (err) {
  //     showSnackBar(err.toString(), context);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // void getComments() async {
  //   try {
  //     QuerySnapshot comments = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(widget.snap['postId'])
  //         .collection('comments')
  //         .get();
  //     commentsNum = comments.docs.length;
  //   } catch (err) {
  //     showSnackBar(err.toString(), context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final width = Dwidth;
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    bool isAnimating = false;
    return Container(
        width: Dwidth * 0.4,
        height: Dheight * 0.6,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white60),
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75)
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${widget.snap['title']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 100, 100, 100),
              height: 210,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    widget.snap['tcontent'],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
