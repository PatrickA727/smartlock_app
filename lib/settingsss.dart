// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlock/login.dart';
import 'fingerprint_config.dart';


class Settingss extends StatefulWidget {
  const Settingss({Key? key}) : super(key: key);

  @override
  State<Settingss> createState() => _SettingssState();
}

final dbRef = FirebaseFirestore.instance.collection('user_actions');

class _SettingssState extends State<Settingss> {
  int _selectedIndex = 2;

  void botNavBarNav (int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/history');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/unlock');
    } else if (index == 2) {
      //settings
    } 
  }

  void signOut(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure you want to sign out?'),
        content: const Text(''),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation without signing out
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                print('User signed out successfully');
                await Future.delayed(Duration(seconds: 1));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              } catch (e) {
                print('Error signing out: $e');
              }
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

  void clearHistory(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to clear the history of ALL user actions? This process cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final snapshot = await dbRef.get();
                for (final document in snapshot.docs) {
                  await document.reference.delete();      //delet history
                }
                print('User actions history deleted successfully');
              } catch (e) {
                print('Error deleting user actions history: $e');
              }

              Navigator.of(context).pop(); // Close confirmation
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

  void accountDelete(BuildContext context) async {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete your account? this action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.delete();
                    await Future.delayed(Duration(seconds: 1));
                    print('Account deleted successfully');
                  } else {
                    print('User is not authenticated');
                  }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false, // clear all previous routes
                    );
                } catch (e) {
                  print('Account deletion failed: $e');
                }
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user!.email!.split('@')[0];
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 30),),
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF16161A),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 29, 25, 30),
        items: const <BottomNavigationBarItem>[
          //need history, (fingerprint sign up, sign out) in settings, and possibly users
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
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: _selectedIndex,
        onTap: botNavBarNav,           
      ),
      
      body: ListView(
        children: [
          Column(
            children: [
                  Image.asset(
                  'lib/images/newPFP.png',
                  color: Colors.white.withOpacity(0.5),      
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    username,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Email: ' + FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: ListTile(
                      title: const Text('Clear History', style: TextStyle(fontSize: 18, color: Colors.white)),
                      trailing: const Icon(Icons.history, color: Colors.white),
                      tileColor: const Color(0xFF16161A),
                      onTap: () {
                        clearHistory(context);
                      },
                    ),
              ),
                  const SizedBox(height: 10),
            ],
          ),
          ListTile(
                title: const Text('Configure fingerprint',  style: TextStyle(fontSize: 18, color: Colors.white)),
                trailing: const Icon(Icons.fingerprint, color: Colors.white),
                tileColor: Color(0xFF16161A),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FingerprintConfig()));
                },
              ),
              const SizedBox(height: 10),
          ListTile(
                title: const Text('Delete Account',  style: TextStyle(fontSize: 18, color: Colors.white)),
                trailing: const Icon(Icons.delete_forever, color: Colors.white),
                tileColor: Color(0xFF16161A),
                onTap: () {
                  accountDelete(context);
                },
              ),
              const SizedBox(height: 10),
          ListTile(
                title: const Text('Sign Out',  style: TextStyle(fontSize: 18, color: Colors.white)),
                trailing: const Icon(Icons.logout, color: Colors.white),
                tileColor: Color(0xFF16161A),
                onTap: () {
                  signOut(context);
                },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
