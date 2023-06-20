import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'unlock.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(   //widget rebuilds when auth state changes
        stream: FirebaseAuth.instance.authStateChanges(), //checks firebase if user is logged in(checks auth state)
        builder: (context, snapshot) { //snapshot is the data from the stream
          if (snapshot.hasData) {
            return Unlock();
          } else {
            return Login();
          }
        },
      ),
    );  
  }
}