// import 'dart:async';
// import 'dart:io' show Platform;
import 'package:ebook_reader/utils/utils.dart';
import 'package:ebook_reader/widgets/loginCard.dart';
import 'package:ebook_reader/widgets/signupCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter/src/widgets/media_query.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Uint8List? _image;
  // void initState() {
  // // TODO: implement initState
  //   super.initState();
  //   print('${Dheight}');
  //   Uint8List? ii = _image;
  // }

  bool isLogin = false;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> card = [signupCard(image: _image), const loginCard()];
    // final mywidgetkey = GlobalKey();
// Container(
// key:mywidgetkey,
// );
//     RenderBox renderbox = mywidgetkey.currentContext!.findRenderObject() as RenderBox;
//     double Dwidth = renderbox.size.width;
//     double Dheight = renderbox.size.height;

    // double Dwidth = Dwidth;
    // double Dheight = Dheight;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          color: const Color.fromARGB(255, 60, 60, 60),
          theme: ThemeData.dark(),
          home: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 60, 60, 60),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(
                  height: 80,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !isLogin
                          ? CircleAvatar(
                              radius: Dheight * 0.03,
                              backgroundColor: const Color.fromARGB(0, 60, 60, 60),
                            )
                          : Container(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        child: GestureDetector(
                          onTap: () { print(isLogin); },
                            child: Center(
                              child: Image.asset('assets/logo.gif'),
                            ),
                        ),
                      ),
                      !isLogin
                          ? Material(
                              borderRadius: BorderRadius.circular(
                                  Dheight +
                                      Dwidth),
                              child: InkWell(
                                onTap: () => selectImage(),
                                child: Container(
                                  child: _image != null
                                      ? Material(
                                          borderRadius: BorderRadius.circular(
                                              Dheight + Dwidth),
                                          child: CircleAvatar(
                                            radius:
                                                Dheight *
                                                    0.03,
                                            backgroundColor: Colors.greenAccent,
                                            child: CircleAvatar(
                                              radius: Dheight *
                                                  0.028,
                                              backgroundImage: MemoryImage(_image!),
                                            ),
                                          ),
                                        )
                                      : Material(
                                          borderRadius: BorderRadius.circular(
                                              Dheight +
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width),
                                          child: CircleAvatar(
                                            radius:
                                                Dheight *
                                                    0.03,
                                            backgroundImage: const AssetImage(
                                                'assets/null_dp.png'),
                                          ),
                                        ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Material(
                  color: const Color.fromARGB(255, 60, 60, 60),
                  child: VxSwiper.builder(
                    itemCount: 2,
                    height: Dheight * 0.465,
                    viewportFraction: 1.0,
                    // enlargeCenterPage: true,
                    onPageChanged: (index) {
                      setState(() {
                        print(MediaQuery.of(context).size);
                        isLogin = !isLogin;
                      });
                    },
                    itemBuilder: (context, index) {
                      ZStack Z = ZStack([
                        Positioned(
                          child: VxBox(
                            child: card[index],
                          )
                              .border(color: Colors.black)
                              .withRounded(value: 20)
                              .make()
                              .px32()
                              .px12(),
                        ),
                      ]);
                      return VxBox(
                        child: Z,
                      ).make();
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Material(
                  color: const Color.fromARGB(255, 60, 60, 60),
                  child: Text("← Swipe to ${isLogin ? "Sign up →" : "Log in →"}"),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
