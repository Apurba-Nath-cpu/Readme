import 'package:ebook_reader/resources/auth_methods.dart';
import 'package:ebook_reader/screens/feedScreen.dart';
import 'package:ebook_reader/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/models/user.dart' as model;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

  void signout() async {
    await AuthMethods().signOut();
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return AppBar(
      backgroundColor: Colors.black26,
      centerTitle: false,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        height: MediaQuery.of(context).size.height * 0.06,
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
            // const IconButton(
            //     onPressed: null,
            //     icon: Icon(
            //       Icons.circle_sharp,
            //       color: Color.fromARGB(0, 255, 255, 255),
            //     ),
            // ),
            Center(child: Image.asset('assets/logo.gif')),
            // const IconButton(
            //     onPressed: null,
            //     icon: Icon(Icons.circle_sharp,
            //         color: Color.fromARGB(0, 60, 60, 60)),
            // ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shrinkWrap: true,
                    children: [
                      'Sign Out',
                      'Profile',
                    ]
                        .map((e) => GestureDetector(
                      onTap: () => {
                        (e == 'Sign Out') ?
                        signout()
                            :
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: user!.uid,),
                          ),
                        ),
                      },
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 14,
                                bottom: 14,
                                left: 16,
                                right: 16,
                              ),
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: Colors.red[400],
                                ),
                              ),
                            ),
                            (e == 'Sign Out') ? const Divider(
                              thickness: 1,
                            )
                                :
                            Container(),
                          ],
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
              icon: const Icon(Icons.account_circle_outlined,),
            ),
            // Icon(),
          ],
        ),
      ),
    );
  }
}
