import 'package:ebook_reader/models/user.dart' as model;
import 'package:ebook_reader/resources/firestore_methods.dart';
import 'package:ebook_reader/screens/LoginScreen.dart';
import 'package:ebook_reader/screens/feedScreen.dart';
import 'package:ebook_reader/screens/profile_screen.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _workController = TextEditingController();

  bool _isLoading = false;
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String ddType = 'Type';
  String ddGenre = 'Genre';
  String ddAudience = 'Audience';
  String ddLang = 'L';

  var listType = [
    'Type',
    'Poem',
    'Story',
    'Article',
    'Other',
  ];
  var listGenre = [
    'Genre',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  var listAudience = [
    'Audience',
    'Everyone',
    'Followers',
    'Custom',
  ];
  var listLang = [
    'L',
    'En',
    'Hi',
  ];

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _workController.dispose();
  }

  Widget DropDown(
      {required String value,
      required List<String> list,
      double height = 40.0,
      double width = 100.0}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.white60),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Center(
        child: DropdownButton<String>(
          value: value,
          underline: Container(),
          dropdownColor: Colors.black26,
          borderRadius: BorderRadius.circular(30.0),

          iconSize: 0,
          items: list.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              value == ddLang
                  ? ddLang = newValue!
                  : value == ddType
                      ? ddType = newValue!
                      : value == ddGenre
                          ? ddGenre = newValue!
                          : value == ddAudience
                              ? ddAudience = newValue!
                              : null;
            });
          },
        ),
      ),
    );
  }

  void postStuff(
    String title,
    String work,
    String lang,
    String type,
    String genre,
    String audience,
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    bool contentOk = true;

    if (_titleController.text == "") {
      showSnackBar('Please give a title', context);
      contentOk = false;
    }
    if (_workController.text == "") {
      showSnackBar('Please put your work first', context);
      contentOk = false;
    }
    if (ddLang == "L") {
      showSnackBar('Please select a language', context);
      contentOk = false;
    }
    if (ddType == "Type") {
      showSnackBar('Please select a type for your work', context);
      contentOk = false;
    }
    if (ddGenre == "Genre") {
      showSnackBar('Please select a genre', context);
      contentOk = false;
    }
    if (ddAudience == "Audience") {
      showSnackBar('Please select your audience', context);
      contentOk = false;
    }

    if (contentOk == false) {
      return;
    } else {
      try {
        String res = await FirestoreMethods().uploadPost( 
          title: _titleController.text,
          work: _workController.text,
          lang: ddLang,
          type: ddType,
          genre: ddGenre,
          audience: ddAudience,
          uid: uid,
          username: username,
          profImage: profImage,
        );
        if (res == "success") {
          showSnackBar('Posted!', context);
        } else {
          showSnackBar('res', context);
        }
        print('$res + LOLOLOL');
      } catch (err) {
        showSnackBar(err.toString(), context);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void signout() async{
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    print(user);

    return Scaffold(
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
                  icon: const Icon(Icons.home)
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
      body: Material(
        color: const Color.fromARGB(255, 60, 60, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color.fromARGB(0, 60, 60, 60),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropDown(
                      value: ddLang, list: listLang, height: 50, width: 50),
                ),
              ],
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 5,
                  minHeight: 0,
                ),
                child: Container(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Give a title...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                ),
                minLines: 1,
                maxLines: 3,
                keyboardType: TextInputType.text,
                onTap: () {},
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 0,
                maxHeight: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _workController,
                decoration: InputDecoration(
                  hintText: "Put your work here.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                ),
                minLines: 3,
                maxLines: 6,
                keyboardType: TextInputType.text,
                onTap: () {},
              ),
            ),
            const Divider(
              thickness: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropDown(value: ddType, list: listType),
                DropDown(value: ddGenre, list: listGenre),
                DropDown(value: ddAudience, list: listAudience),
              ],
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                  minHeight: 0,
                ),
              ),
            ),
            Container(
              height: 40,
              width: Dwidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(color: Colors.white60),
                borderRadius: BorderRadius.circular(100),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Center(child: Text('Post')),
                  ),
                ),
                onTap: () => postStuff(
                    _titleController.text,
                    _workController.text,
                    ddLang,
                    ddType,
                    ddGenre,
                    ddAudience,
                    user!.uid,
                    user.username,
                    user.photoUrl),
              ),
            ),
            Expanded(child: Container()),
          ],
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
  }
}
