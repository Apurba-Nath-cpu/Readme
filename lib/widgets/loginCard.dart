import 'package:ebook_reader/resources/auth_methods.dart';
import 'package:ebook_reader/responsive/mobile_screen_layout.dart';
import 'package:ebook_reader/responsive/responsive_layout.dart';
import 'package:ebook_reader/responsive/web_screen_layout.dart';
import 'package:ebook_reader/screens/feedScreen.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:ebook_reader/widgets/text_field_input.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginCard extends StatefulWidget {
  const loginCard({Key? key}) : super(key: key);

  @override
  State<loginCard> createState() => _loginCardState();
}

class _loginCardState extends State<loginCard> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    print(_emailController.text);
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res != 'success') {
      print(res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              ),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 60, 60, 60),
        border:
            Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        child: Column(
          children: [
            // TextFieldInput(
            //   textEditingController: _nicknameController,
            //   hintText: 'Enter a nickname',
            //   textInputType: TextInputType.text,
            //   onTap: () {},
            // ),

            // const SizedBox(
            //   height: 32,
            // ),
            TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              onTap: () {},
            ),
            // const SizedBox(
            //   height: 24,
            // ),
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
              flex: 7,
              child: Container(),
            ),
            InkWell(
              onTap: () => loginUser(),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 30, 30, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 51, 76),
                        ),
                      )
                    : const Text('Log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
