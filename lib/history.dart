// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {  
  const History({Key? key}) : super(key: key);  

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedIndex = 0;
  late bool buttonLock = true;
  late bool fpStatus = false;
  final CollectionReference userHistory = FirebaseFirestore.instance.collection('user_actions');

  DatabaseReference lockButtonRef = FirebaseDatabase.instance.ref().child('lock/value');
  DatabaseReference fpRef = FirebaseDatabase.instance.ref().child('lock/var');

  @override
  void initState() {
    super.initState();
    fpRef.onValue.listen((event) {
      bool fpLock = event.snapshot.value as bool;
      if (fpLock == true) {
        userHardwareAction();
      }
    });
  }

      Future<void> userHardwareAction() async {
    try {
      final timestampRef = DateTime.now();
      String action = '';
          action = 'hardware';


      await FirebaseFirestore.instance.collection('user_actions').add({
        'userId': 'none',
        'timestamp': timestampRef,
        'action': action,
      });
      print('User action stored successfully');
    } catch (error) {
      print('Failed to store user action: $error');
    }
  }

  void botNavBarNav (int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      //history
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/unlock');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/settingsss');
    } 
  }

  String formatTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final formattedDateTime = DateFormat('dd-MM-yyyy - HH:mm').format(dateTime);
  return formattedDateTime;
}

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text('Activity Log', style: TextStyle(fontSize: 30),),
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF16161A),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 29, 25, 30),
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

      body: StreamBuilder<QuerySnapshot>(
          stream: userHistory.orderBy('timestamp', descending: true).snapshots(),  //order by time 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final username = document['userId'].split('@')[0];    //takes email and cuts it off at @
                  final timestamp = document['timestamp'];
                  final formattedTimestamp = formatTimestamp(timestamp);
                  final action = document['action'] as String;

                String message;
                  if (action == 'phone') {
                    message = 'User $username opened door with phone at: ';
                  } else if (action == 'hardware') {
                    message = 'door accessed using Fingerprint/RFID at: ';
                  } else {
                    message = 'Door Closed with phone at:';
                  }

                  return ListTile(
                    title: Text(message, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('Date & Time: $formattedTimestamp', style: const TextStyle(color: Colors.white)),
                  );
                },
              );
            }
            return const Text('No data');
          },          
        ),          
      );
  }
}