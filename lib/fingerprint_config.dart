// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FingerprintConfig extends StatefulWidget {
  const FingerprintConfig({Key? key}) : super(key: key);

  @override
  State<FingerprintConfig> createState() => _FingerprintConfigState();
}

class _FingerprintConfigState extends State<FingerprintConfig> {
  final dbRef = FirebaseDatabase.instance.ref().child('lock');
  late bool newfpState;
  bool showInstructions = false;
  String instructionText = '';

  void fpSignUp() {
    dbRef.update({'newfp': true})
      .then((value) => print('Fingerprint Sign-up Successful'))
      .catchError((error) => print('Failed to update boolean value: $error'));

      showInstructions = true;
      instructionText = 'Place your finger on the sensor';

    Timer(const Duration(seconds: 1), () {
      setState(() {
        showInstructions = true;
        instructionText = 'Hold it there';
      });
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        showInstructions = true;
        instructionText = 'Remove finger';
        
      });
    });

    Timer(const Duration(seconds: 7), () {
      setState(() {
        showInstructions = true;
        instructionText = 'Place same finger again';
      });
    });

    Timer(const Duration(seconds: 12), () {
      setState(() {
        showInstructions = false;
      });
      dbRef.update({'newfp': false})
        .then((value) => print('Fingerprint Sign-up Reset'))
        .catchError((error) => print('Failed to update boolean value: $error'));
    });
  }

  void fpReset() {
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
                dbRef.update({'resetfp': true})
                  .then((value) => print('Fingerprint Sign-up Successful'))
                  .catchError((error) => print('Failed to update boolean value: $error'));

                Future.delayed(const Duration(seconds: 5), () {
                  dbRef.update({'resetfp': false})
                    .then((value) => print('Fingerprint Sign-up Reset'))
                    .catchError((error) => print('Failed to update boolean value: $error'));
                });
              Navigator.of(context).pop(); // Close confirmation
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
  }

  String getInstructionText() {
    if (showInstructions) {
      return instructionText;
    } else {
    return 'No new fingerprints to add';
    }
  }

  Color fpColorChange() {
    if (instructionText == 'Remove finger') {
      return Color.fromARGB(255, 62, 13, 207);
    } else {
      return Colors.red;
    }
  }

  int fpCounter() {
    int counter = 0;
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF16161A),
      body: 
        Column(
          children: [
            GestureDetector(
              onTap:() {
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 37, horizontal: 15),
                  child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 130,),
            const Center(child: Icon(Icons.fingerprint, size: 170, color: Color.fromARGB(255, 62, 13, 207))),
            const SizedBox(height: 50),
            Text(getInstructionText(), style: const TextStyle(fontSize: 30, color: Color.fromARGB(255, 62, 13, 207))),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 62, 13, 207)),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
              onPressed: fpSignUp, 
              child: const Text('Add new fingerprint', style: TextStyle(fontSize: 20, color: Colors.white))
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 62, 13, 207)),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
              onPressed: fpReset, 
              child: const Text('Clear saved fingerprints', style: TextStyle(fontSize: 20, color: Colors.white))
            ),
        ],
      ),
    );
  }
}