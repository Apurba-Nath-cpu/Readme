import 'dart:async';
import 'dart:io' show Platform;
import 'package:ebook_reader/providers/user_provider.dart';
import 'package:ebook_reader/screens/LoginScreen.dart';
import 'package:ebook_reader/utils/utils.dart';
import 'package:ebook_reader/widgets/loginCard.dart';
import 'package:ebook_reader/widgets/signupCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyA3sxoM-6dBnbcKtUEgmT0XTOh88xvKgOw',
          appId: '1:827895775470:web:bb3330456184db357bb3ff',
          messagingSenderId: '827895775470',
          projectId: 'readme-a4022',
          storageBucket: "readme-a4022.appspot.com",
      ),
    );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            color: const Color.fromARGB(255, 60, 60, 60),
            theme: ThemeData.dark(),
            home: const LoginPage(),
          ),
      ),
    );
  }
}
