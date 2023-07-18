import 'package:ebook_reader/screens/profile_screen.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:ebook_reader/widgets/like_animation.dart';
import 'package:ebook_reader/resources/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:ebook_reader/models/user.dart' as model;
import 'package:velocity_x/velocity_x.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';

class FullPostCard extends StatefulWidget {
  final snap, uid;
  const FullPostCard({Key? key, required this.snap, required this.uid}) : super(key: key);

  @override
  State<FullPostCard> createState() => _FullPostCardState();
}

class _FullPostCardState extends State<FullPostCard> {
  bool isLikeTapped = false;
  bool isLikeAnimating = false;
  bool isAlreadyLiked = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkLiked(widget.snap['postId'], widget.uid, widget.snap['likes']);
  }
  void checkLiked(String PostId, String uid, List likes) async {
    print('checked');
    isAlreadyLiked = await FirestoreMethods().isLiked(postId:  PostId, uid: uid, likes: likes);
  }

  void likePost(String PostId, String uid, List likes) async {
    await FirestoreMethods().likePost(postId:  PostId, uid: uid, likes: likes);
    print('liked');
  }

  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    print(widget.snap);
    return Material(
      child:
        Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          height: Dheight * 0.8,
          width: Dwidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.circular(10.0),
                  color: Color.fromARGB(255, 60, 60, 60),
                ),
                height: Dheight * 0.08,
                width: Dwidth * 0.9,
                child: Row(
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      margin: const EdgeInsets.only(left: 5),
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              // width: Dwidth * 0.7,
                              height: Dwidth * 0.9,
                              child: Image(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  widget.snap['profImage'],
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundImage: NetworkImage(
                            widget.snap['profImage'],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(uid: widget.snap['uid'],),
                                ),
                              ),
                              child: Text(
                                // 'username',
                                widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: const Color.fromARGB(255, 100, 100, 100),
                    height: Dheight * 0.64,
                    width: Dwidth * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Text(
                          widget.snap['tcontent'],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 20, 20, 20),
                    height: Dheight * 0.08,
                    width: Dwidth * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    likePost(widget.snap['postId'], widget.uid, widget.snap['likes']),
                                    setState(() {
                                      isLikeTapped = !isLikeTapped;
                                      isAlreadyLiked = false;
                                    }),
                                    print(isAlreadyLiked),
                                  },
                                  child: ((widget.snap['likes'].contains(user?.uid) && isAlreadyLiked) || isLikeTapped)
                                      ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                      : const Icon(
                                    Icons.favorite_outline,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                    child: Text('${widget.snap['likes'].length} likes'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => {print(widget.snap)},
                              child: const Icon(Icons.report),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
       ),

    );
  }
}
