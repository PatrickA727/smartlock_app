// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:smartlock/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartlock/login.dart';
import 'firebase_options.dart';
import 'history.dart';
import 'unlock.dart';
import 'settingsss.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MainApp());
  } catch (error) {
    print('Failed to initialize Firebase: $error');
  }
}



class MainApp extends StatelessWidget { 
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Auth(),
      routes: {
        '/history': (context) => History(),
        '/unlock': (context) => Unlock(),   
        '/settingsss': (context) => Settingss(),
        '/login': (context) => Login(),
      },
    );
  }
}
