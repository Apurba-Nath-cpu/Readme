import 'dart:typed_data';

import 'package:ebook_reader/resources/auth_methods.dart';
import 'package:ebook_reader/responsive/mobile_screen_layout.dart';
import 'package:ebook_reader/responsive/responsive_layout.dart';
import 'package:ebook_reader/responsive/web_screen_layout.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:ebook_reader/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

class signupCard extends StatefulWidget {
  final Uint8List? image;
  const signupCard({Key? key, required this.image}) : super(key: key);

  @override
  State<signupCard> createState() => _signupCardState();
}

class _signupCardState extends State<signupCard> {
  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = false;

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    //
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: widget.image!,
    );
    print(res);
    print('looooooooool');
    if(res != 'success'){
      // showSnackBar(res, context);
    }
    else{
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          )
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 60, 60, 60),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
              width: 1.0
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          child: Column(
            children: [
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                onTap: () {},
              ),

              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 24,
                    // maxWidth: 24,
                  ),
                  child: Container(),
                ),
              ),

              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                onTap: () {},
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 24,
                    // maxWidth: 24,
                  ),
                  child: Container(),
                ),
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
                onTap: () {},
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 24,
                    // maxWidth: 24,
                  ),
                  child: Container(),
                ),
              ),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                onTap: () {},
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              InkWell(
                onTap: () => signUpUser(),
                child: Container(

                  child: _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 51, 76),
                    ),
                  )
                      : const Text('Sign up'),
                  // width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: Color.fromARGB(255, 30, 30, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
