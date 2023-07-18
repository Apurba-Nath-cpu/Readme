import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_reader/resources/auth_methods.dart';
import 'package:ebook_reader/screens/LoginScreen.dart';
import 'package:ebook_reader/screens/full_post_card.dart';
import 'package:ebook_reader/screens/profile_screen.dart';
import 'package:ebook_reader/screens/search_screen.dart';
import 'package:ebook_reader/screens/uploadStuff.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:ebook_reader/widgets/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/models/post.dart';
import 'package:ebook_reader/models/user.dart' as model;
import 'package:ebook_reader/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../providers/user_provider.dart';
import '../widgets/MyAppBar.dart';
// import '../widgets/post_card.dart';
// MediaQ

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  void moveTo(String page) async {
    if (page == "add_post") {
      print("addpost...");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AddPost(),
        ),
      );
    }
  }

  void signout() async {
    await AuthMethods().signOut();
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double card_height = 300.0;
    double heading_padding = 20.0;
    final width = MediaQuery.of(context).size.width;
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0),
          child: SafeArea(
            child: AppBar(
              toolbarHeight: 120.0,
              backgroundColor: Colors.black26,
              centerTitle: false,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                height: Dheight * 0.072,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const FeedScreen(),
                              ),
                            ),
                        icon: const Icon(Icons.home)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.circle,
                          color: Color.fromARGB(0, 60, 60, 60),
                        )),
                    Center(child: Image.asset('assets/logo.gif')),
                    IconButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            ),
                        icon: const Icon(
                          Icons.search,
                          // color: Color.fromARGB(0, 60, 60, 60),
                        )),
                    IconButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: user!.uid,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.account_circle_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        // shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: heading_padding),
            child: Row(children: <Widget>[
              const Expanded(child: Divider()),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const Text(
                  'Poems',
                  textAlign: TextAlign.left,
                  // textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ]),
          ),
          Container(
            height: card_height,
            child: StreamBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: false,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => {
                          snapshot.data!.docs[index].data()['type'] == 'Poem'
                              ? print('poem')
                              : print('not poem'),
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: FullPostCard(
                                snap: snapshot.data!.docs[index].data(), uid: user!.uid,
                              ),
                            ),
                          ),
                        },
                        child:
                            snapshot.data!.docs[index].data()['type'] == 'Poem'
                                ? PostCard(
                                    snap: snapshot.data!.docs[index].data(),
                                  )
                                : Container(),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 5,
              maxHeight: 20,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: heading_padding),
            child: Row(children: <Widget>[
              const Expanded(child: Divider()),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const Text(
                  'Stories',
                  textAlign: TextAlign.left,
                  // textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ]),
          ),
          Container(
            height: card_height,
            child: StreamBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: false,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => {
                          snapshot.data!.docs[index].data()['type'] == 'Poem'
                              ? print('poem')
                              : print('not poem'),
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: FullPostCard(
                                snap: snapshot.data!.docs[index].data(), uid: user!.uid,
                              ),
                            ),
                          ),
                        },
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
            ),
            //   ],
            // ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: <Widget>[
              const Expanded(child: Divider()),
              Container(
                padding: EdgeInsets.symmetric(vertical: heading_padding),
                child: const Text(
                  'Articles',
                  textAlign: TextAlign.left,
                  // textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ]),
          ),
          Container(
            height: card_height,
            child: StreamBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: false,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: FullPostCard(
                              snap: snapshot.data!.docs[index].data(), uid: user!.uid,
                            ),
                          ),
                        ),
                        child: snapshot.data!.docs[index].data()['type'] ==
                                'Article'
                            ? PostCard(
                                snap: snapshot.data!.docs[index].data(),
                              )
                            : Container(),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
            ),
            //   ],
            // ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: heading_padding),
            child: Row(children: <Widget>[
              const Expanded(child: Divider()),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const Text(
                  'Others',
                  textAlign: TextAlign.left,
                  // textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ]),
          ),
          Container(
            height: card_height,
            child: StreamBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: false,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: FullPostCard(
                              snap: snapshot.data!.docs[index].data(), uid: user!.uid,
                            ),
                          ),
                        ),
                        child:
                            snapshot.data!.docs[index].data()['type'] == 'Other'
                                ? PostCard(
                                    snap: snapshot.data!.docs[index].data(),
                                  )
                                : Container(),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AddPost(),
          ),
        ),
        elevation: 15,
        backgroundColor: Colors.blueGrey[200],
        child: const Icon(Icons.add),
      ),
    );
  }
}
