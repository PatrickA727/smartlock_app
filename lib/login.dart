// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'unlock.dart';
import 'settingsss.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();  

  final passwordController = TextEditingController();  

  void signIn(BuildContext context) async {
  try {
    showDialog(
      context: context, 
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      });

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Unlock()));
    print('Sign-in successful');
  } catch (e) {
    print('Failed to sign in: $e');    
  }
}
 
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 25, 30),
      body: SingleChildScrollView(  //allows scrolling so overflow wont happen
        child: Center(
          child: Column( 
          children: [
            const SizedBox(height: 50),
            const Icon(Icons.lock, size: 200, color: Color.fromARGB(255, 62, 13, 207)),
      
            const SizedBox(height: 30),
            const Text("Smart Lock Login", style: TextStyle(color: Colors.white),),
            const SizedBox(height: 10),
      
            Padding(padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: TextField(
              style: const TextStyle(color: Color.fromARGB(255, 244, 244, 244)),
              controller: emailController,
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 62, 13, 207),),
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 62, 13, 207)),
                borderRadius: BorderRadius.circular(15),
                  ),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 62, 13, 207)),
                borderRadius: BorderRadius.circular(15),
                  ),
                fillColor: const Color.fromARGB(255, 29, 25, 30),
                filled: true,
                labelText: 'Email Address', labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 244, 244, 244), fontStyle: FontStyle.italic

                  ),
                ),
              ),
            ),
                  
            Padding(padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: TextField(
              style: const TextStyle(color: Color.fromARGB(255, 244, 244, 244)),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 62, 13, 207),),
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(255, 62, 13, 207)),
                  borderRadius: BorderRadius.circular(15),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(255, 62, 13, 207)),
                  borderRadius: BorderRadius.circular(15),
                  ),
                fillColor: const Color.fromARGB(255, 29, 25, 30),
                filled: true,
                labelText: 'Password', labelStyle: const TextStyle(color: Color.fromARGB(255, 244, 244, 244), 
                  fontStyle: FontStyle.italic
                  ),
                ),                
              ),
            ),
      
            const SizedBox(height: 20), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 62, 13, 207)),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(1226, 70)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                ),
                child: const Text('Sign In'),
                onPressed: (){
                  signIn(context);                  
                }, 
              ),
            ),

            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                    },
                    child: const Text("Sign Up Now!", style: TextStyle(color: Color.fromARGB(255, 62, 13, 207), decoration: TextDecoration.underline, fontSize: 15)),
                  ),
                ),                        
              ], //children                
            ),
              const SizedBox(height: 40,),
            ],
          ),
        ),      
      ),
    );
  }
}