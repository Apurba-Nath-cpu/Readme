import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/screens/profile_screen.dart';
// import 'package:ebook_reader/utils/colors.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ebook_reader/utils/global_variables.dart';

import 'feedScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  String usernameSearched = "";
  @override
  void dispose(){
    super.dispose();
    searchController.dispose();
  }
  @override
  Future<QuerySnapshot> _searchUsers(String query) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.toUpperCase())
        .get();
  }

  Future<QuerySnapshot>? _searchResultsFuture;
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isWeb = width > webScreenSize;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 60, 60, 60),
        title: Container(
          height: Dheight * 0.072,
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for a user',
            ),
            onFieldSubmitted: (String query) {
              print(query);
              print(searchController.text.toUpperCase());
              setState(() {
                _searchResultsFuture = _searchUsers(query);
              });
            },
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _searchResultsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic)!.docs[index]!['uid'],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic)!.docs[index]!['photoUrl'],
                        ),
                      ),
                      title: Text(
                        (snapshot.data! as dynamic)!.docs[index]!['username'],
                      ),
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
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
    );

    // Future<QuerySnapshot> _searchUsers(String query) {
    //   return FirebaseFirestore.instance
    //       .collection('users')
    //       .where('username', isGreaterThanOrEqualTo: query.toUpperCase())
    //       .get();
    // }
    //
    // Future<QuerySnapshot>? _searchResultsFuture;

  }
}
// floatingActionButton: FloatingActionButton(
// onPressed: () => Navigator.of(context).pushReplacement(
// MaterialPageRoute(
// builder: (context) => const FeedScreen(),
// ),
// ),
// elevation: 15,
// backgroundColor: Colors.blueGrey[200],
// child: const Icon(Icons.home),
// ),