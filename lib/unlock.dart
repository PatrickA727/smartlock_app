// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'settingsss.dart';
// import 'login.dart';

class Unlock extends StatefulWidget {
  const Unlock({Key? key}) : super(key: key);

  @override
  State<Unlock> createState() => _UnlockState();
}

class _UnlockState extends State<Unlock> {
  late DatabaseReference dbRef;
  late bool buttonLock;
  late bool fpLock;

_UnlockState()  {
  dbRef = FirebaseDatabase.instance.ref().child('lock');

  fpLock = false; //fingerprint button
  dbRef.child('var').onValue.listen((event) {
    if (event.snapshot.value != null) {
      setState(() {
        fpLock = event.snapshot.value as bool;
      });
    }
  });

  buttonLock = false; //phone button
  dbRef.child('value').onValue.listen((event) {
    if (event.snapshot.value != null) {
      setState(() {
        buttonLock = event.snapshot.value as bool;
      });
    }
  });
}

  void toggleButton() {
    setState(() {
      buttonLock = !buttonLock;
    });
    dbRef.update({'value': buttonLock})
    .then((value) => print('Lock Button Toggled'))
    .catchError((error) => print('Failed to update boolean value: $error'));
  }  

  Color buttonColorChange() {
    if (buttonLock == true || fpLock == true) {
      return Colors.red;
    } else {
      return Color.fromARGB(255, 62, 13, 207);
    }
  }

  String buttonTextChange() {
    if (buttonLock == true || fpLock == true) {
      return 'Lock';
    } else {
      return 'Unlock';
    }
  }

  String imageChange() {
    if (buttonLock == true || fpLock == true) {
      return 'lib/images/unlockv3.png'; //'lib/images/unlockv3.png'
    } else {
      return 'lib/images/lockv3.png'; //'lib/images/lockv3.png'
    }
  }

  Color imageColorChange() {
    if (buttonLock == true || fpLock == true) {
      return Colors.red;
    } else {
      return Color.fromARGB(255, 62, 13, 207); //Color.fromARGB(255, 62, 13, 207)
    }
  }

  String doorStatus() {
    if (buttonLock == true || fpLock == true) {
      return 'Door is unlocked';
    } else {
      return 'Door is locked';
    }
  }

  String greetingTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  int _selectedIndex = 1;

  void botNavBarNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/history');
    } else if (index == 1) {
      //home
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/settingsss');
    }
  } 

  Future<void> storeUserAction(String userIdRef) async {
  try {
    final timestampRef = DateTime.now();
    String action = '';
    if (buttonLock == true) {
        action = 'phone';
      }

    await FirebaseFirestore.instance.collection('user_actions').add({
      'userId': userIdRef,
      'timestamp': timestampRef,
      'action': action,
      'status': 'opened'
    });

    print('User action stored successfully');
  } catch (error) {
    print('Failed to store user action: $error');
  }
}

//   Future<void> userHardwareAction() async {
//   try {
//     final timestampRef = DateTime.now();
//     String action = '';
//     if (fpLock == true) {
//         action = 'hardware';
//       }

//     await FirebaseFirestore.instance.collection('user_actions').add({
//       'timestamp': timestampRef,
//       'action': action,
//     });

//     print('User action stored successfully');
//   } catch (error) {
//     print('Failed to store user action: $error');
//   }
// }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user!.email!.split('@')[0];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 29, 25, 30),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Color(0xFFFFFFFE),
        unselectedItemColor: Color(0xFFFFFFFE),
        currentIndex: _selectedIndex,
        onTap: botNavBarNav,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     signOut(context);
          //   },
          // icon: Icon(Icons.logout),
          // ),
        ],
        title: const Text(
          'Front Door',
          style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 239, 239, 238)),
        ),
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF16161A),
      ),
      backgroundColor: const Color(0xFF16161A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(greetingTime(), 
                  style: TextStyle(color: Color.fromARGB(255, 239, 239, 238), fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Welcome ${username}', 
                  style:  const TextStyle(color: Color.fromARGB(255, 239, 239, 238), fontSize: 25, fontWeight: FontWeight.bold),),
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () {
                },
                child: Image.asset(
                  imageChange(),
                  color: imageColorChange(),      
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Text(doorStatus(), style: TextStyle(color: imageColorChange(), fontSize: 30),),
              const SizedBox(height: 130),

              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(buttonColorChange()),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(250, 65)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    buttonTextChange(),
                    style: TextStyle(color: Color.fromARGB(255, 239, 239, 238), fontSize: 24),
                  ),
                  onPressed: () {
                    toggleButton();  
                    storeUserAction(user.email!);                 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
