// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartlock/unlock.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

final newEmail = TextEditingController();
final newPassword = TextEditingController();

  class _SignupState extends State<Signup> {
    // void delete() {
    //   newEmail.dispose();
    //   newPassword.dispose();
    //   super.dispose();
    // }

  Future<void> signUp() async {
  try {
    // showDialog(
    //   context: context, 
    //   builder: (context) {
    //     return Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   });

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: newEmail.text.trim(),
      password: newPassword.text.trim(),
    );
    print('Sign-up successful');
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Unlock()),
    );
  } catch (error) {
    print('Sign-up failed: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 29, 25, 30),
      body: SingleChildScrollView(  
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         Color.fromARGB(255, 255, 255, 255),
        //         Color.fromARGB(255, 255, 255, 255)
        //       ]),
        // ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),              
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20) ,
                  child: Column(                  
                    children: [                    
                      Align(
                        alignment: Alignment.topLeft,
                      child: 
                        Text("Welcome!", style: TextStyle(color: Color.fromARGB(255, 62, 13, 207), fontSize: 45),),
                      ),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Let's get started!",
                          style: TextStyle(color: Color.fromARGB(255, 62, 13, 207), fontSize: 45),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     "Create an account to continue",
                      //     style: TextStyle(color: Color.fromARGB(255, 235, 235, 235), fontSize: 20),
                      //   ),
                      // ),
                    ],
                  ),
                ),              
              const SizedBox(height: 60),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                                                                
                    Padding(padding: const EdgeInsets.only(),
                      child: Column(
                        children: [                                               
                        TextField(
                          style: TextStyle(color: Color.fromARGB(255, 244, 244, 244)),
                          controller: newEmail,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 62, 13, 207),),
                              contentPadding: EdgeInsets.symmetric(vertical: 30),
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
                        ],                        
                      ),
                    ),

                    const SizedBox(height: 20),
                    Padding(padding: const EdgeInsets.only(),
                      child: Column(
                        children: [                           
                       TextField(
                        style: const TextStyle(color: Color.fromARGB(255, 244, 244, 244)),
                        controller: newPassword,
                        obscureText: true,
                        decoration:  InputDecoration(
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
                        ],                        
                      ),
                    ),
                  ],
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
                             child: const Text('Sign up'),
                             onPressed: (){
                                signUp();   //PASS NEEDS TO BE ATLEAST 6 LETTERS
                             }, 
                           ),
               ),

               const SizedBox(height: 180),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ", style: TextStyle(color: Color.fromARGB(255, 235, 235, 235)),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: const Text("Sign in!", style: TextStyle(color: Color.fromARGB(255, 62, 13, 207), decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 55),
            ], //children
          ),
        ),     
      ),
    );
  }
}
