import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_reader/screens/feedScreen.dart';
import 'package:ebook_reader/screens/full_post_card.dart';
import 'package:ebook_reader/widgets/follow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/resources/auth_methods.dart';
import 'package:ebook_reader/resources/firestore_methods.dart';
// import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:ebook_reader/models/user.dart' as model;
import '../providers/user_provider.dart';
import '../widgets/post_card.dart';
import 'LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var followersList;
  var followingList;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // print(widget.uid);
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length ?? 0;
      userData = userSnap.data()!;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      followers = userData['followers']?.length;
      following = userData['following']?.length;
      followersList = userData['followers'];
      followingList = userData['following'];
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void signout() async {
    await AuthMethods().signOut();
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double card_height = 300.0;
    model.User? user = Provider.of<UserProvider>(context).getUser;
    // print(userData['followers']);
    // print(userData['following']);
    // print('kkk');
    return !isLoading
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        centerTitle: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          height: Dheight * 0.06,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const FeedScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.home),
              ),
              Center(child: Image.asset('assets/logo.gif')),
              IconButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: user!.uid,),
                  ),
                ),
                icon: const Icon(Icons.account_circle_outlined,),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: GestureDetector(onTap: () =>
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  height: Dwidth * 0.9,
                                  child: Image(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      userData['photoUrl'],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData[
                            'photoUrl'] ??
                                'https://images.unsplash.com/photo-1554050857-c84a8abdb5e2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YmxhY2t8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                            radius: 50,
                          ),
                        ),
                      ),
                      // Expanded(child: Container(),),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                ),
                                margin: const EdgeInsets.only(
                                  bottom: 4,
                                  // left: 20,
                                  // right: 20,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: Dwidth * 0.35,
                                  maxWidth: Dwidth * 0.35,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 100, 100, 100),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),

                                child: GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 100, 100, 100),
                                          borderRadius: BorderRadius.circular(5.0)
                                        ),
                                        height: Dheight * 0.64,
                                        width: Dwidth * 0.9,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              userData['username'],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        userData['username'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => signout(),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: const Icon(Icons.logout_outlined,),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            margin: const EdgeInsets.only(
                              top: 4,
                            ),
                            constraints: BoxConstraints(
                              minWidth: Dwidth * 0.65,
                              maxWidth: Dwidth * 0.65,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 100, 100, 100),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 100, 100, 100),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    height: Dheight * 0.64,
                                    width: Dwidth * 0.9,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          userData['bio'],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: Dwidth * 0.65,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    userData['bio'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildStatColumn(postLen, "posts"),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: StreamBuilder(
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                    if (snapshot.connectionState != ConnectionState.waiting) {
                                      List c = userData['followers'];
                                      return ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data!.docs.length,
                                          shrinkWrap: false,
                                          itemBuilder: (context, index) => c.contains((snapshot.data!.docs[index].data()['uid'])) ? Container(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    color: const Color.fromARGB(255, 50, 50, 50),
                                                    child: GestureDetector(
                                                      onTap: () => Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) => ProfileScreen(uid: snapshot.data!.docs[index].data()['uid']),
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: Dwidth * 0.9,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor: Colors.grey,
                                                              backgroundImage: NetworkImage(
                                                                snapshot.data!.docs[index].data()['photoUrl'],
                                                              ),
                                                              radius: 20,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(left: 8,),
                                                              child: Text('${(snapshot.data!.docs[index].data()['username'])}'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                              :
                                          Container()
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .snapshots(),
                                ),
                              ),
                            ),
                              child: buildStatColumn(followers ?? 0, "followers"),
                          ),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: StreamBuilder(
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                    if (snapshot.connectionState != ConnectionState.waiting) {
                                      List c = userData['following'];
                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.docs.length,
                                        shrinkWrap: false,
                                        itemBuilder: (context, index) => c.contains((snapshot.data!.docs[index].data()['uid'])) ? Container(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) => ProfileScreen(uid: snapshot.data!.docs[index].data()['uid']),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: Dwidth * 0.9,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: Colors.grey,
                                                          backgroundImage: NetworkImage(
                                                            snapshot.data!.docs[index].data()['photoUrl'],
                                                          ),
                                                          radius: 20,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 8,),
                                                            child: Text('${(snapshot.data!.docs[index].data()['username'])}'),
                                                        ),
                                                        Expanded(child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                            :
                                        Container()
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .snapshots(),
                                ),
                              ),
                            ),
                            child: buildStatColumn(following ?? 0, "following"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                      text: "Sign Out",
                      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      function: () async {
                        await AuthMethods().signOut();
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                      },
                        // bottom
                    )
                        : isFollowing
                        ? FollowButton(
                      text: "Unfollow",
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      function: () async {
                        await FirestoreMethods().followUser(
                          FirebaseAuth
                              .instance.currentUser!.uid,
                          userData['uid'],
                        );
                        setState(() {
                          isFollowing = false;
                          followers--;
                        });
                        print('unfollow tapped..');
                      },
                    )
                        : FollowButton(
                      text: "Follow",
                      backgroundColor: Colors.blueAccent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      function: () async {
                        await FirestoreMethods().followUser(
                          FirebaseAuth
                              .instance.currentUser!.uid,
                          userData['uid'],
                        );
                        // print(FirebaseAuth
                        //     .instance.currentUser!.email);
                        // print(widget.uid);

                        setState(() {
                          isFollowing = true;
                          followers++;
                        });
                        print('follow tapped..');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Divider(
              thickness: 1,
            ),
          ),
          Container(
            height: Dheight * 0.73,
            // width: 400,
            child: StreamBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  snapshot) {
                // print(snapshot.data!.docs);
                // print()
                if (snapshot.connectionState != ConnectionState.waiting) {
                  return GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: postLen,
                      shrinkWrap: true,

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // crossAxisSpacing: 5,
                        mainAxisSpacing: 25,
                        mainAxisExtent: 300.0,
                      ),
                      //crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                      itemBuilder: (BuildContext context, int index) {
                        // print(snapshot.data!.size);
                        // if(snapshot.data!.docs[index].data()['uid'] != userData['uid']){ return Container();}
                        print(index);
                        return GestureDetector(
                          onTap: () => {
                            snapshot.data!.docs[index].data()['type'] == 'Poem' ?
                            print('poem') : print('not poem'),
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  Dialog(
                                    child: FullPostCard(
                                      snap: snapshot.data!.docs[index].data(),  uid: user!.uid,),
                                  ),
                            ),
                          },
                          child: snapshot.data?.docs[index].data()['uid'] == userData['uid'] ?
                          PostCard(
                            snap: snapshot.data?.docs[index].data(),
                          ) :
                          Container(
                            child: Column(
                              children: [
                                Text('sn: ${snapshot.data?.docs[index].data()['uid']}'),
                                Text('user: ${userData['uid']}'),
                                Text('widget: ${widget.uid}')
                              ],
                            ),
                          ),
                        );
                      });
                }
                return const CircularProgressIndicator();
              },
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: widget.uid)
                  // .orderBy(
                  //   'datePublished',
                  //   descending: true,
                  // )
                  .snapshots(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FeedScreen(),
          ),
        ),
        elevation: 15,
        backgroundColor: Colors.blueGrey[200],
        child: const Icon(Icons.home),
      ),
    )
        : const Center(
      child: CircularProgressIndicator(),
    );
  }



  Container buildStatColumn(int num, String label) {
    return Container(
      constraints: BoxConstraints(minWidth: Dwidth * 0.29),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 100, 100, 100),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6.0,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Dheight Post