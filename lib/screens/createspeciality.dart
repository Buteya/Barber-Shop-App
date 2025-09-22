import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/users.dart' as usr;

class CreateSpeciality extends StatefulWidget {
  const CreateSpeciality({super.key});

  @override
  State<CreateSpeciality> createState() => _CreateSpecialityState();
}

class _CreateSpecialityState extends State<CreateSpeciality> {
  final _firestore = FirebaseFirestore.instance;
  var speciality;
  var price;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final usrR = usr.User(
    id: '',
    username: '',
    email: '',
    password: '',
    phoneNumber: '',
  );
  String username = '';
  bool isUsername = false;

  Future<void> getUser() async {
    setState(() {
      isUsername = true;
    });
    var userNew = await usrR.getUserName(user!.uid);
    setState(() {
      username = userNew!;
      isUsername = false;
    });

    setState(() {
      isUsername = false;
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          user != null
              ? InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/dashboard');
            },
            child: Row(
              children: [
                isUsername
                    ? Center(child: CircularProgressIndicator())
                    : Text(username),
                SizedBox(width: MediaQuery.widthOf(context) * 0.01),
                InkWell(
                  child: CircleAvatar(child: Icon(Icons.person)),
                ),
              ],
            ),
          )
              : InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Text('login'),
          ),
          SizedBox(width: MediaQuery.widthOf(context) * .02),
        ],
        automaticallyImplyLeading: true,
        toolbarHeight: MediaQuery.heightOf(context) * .16,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: MediaQuery.widthOf(context) * .03,
              backgroundImage: AssetImage(
                'assets/images/barber shop logo.png',
              ),
            ),
            SizedBox(width: MediaQuery.widthOf(context) * 0.01),
            Text('Barber shop'),
          ],
        ),
      ),
     body:  SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 108),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Speciality'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter speciality';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    speciality = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    price = double.tryParse(value!);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // All fields are valid, proceed to save or submit
                        _formKey.currentState!
                            .save(); // Triggers onSaved callbacks
                        // Perform submission logic

                        print(speciality);
                        print(price);
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          // Code that might throw an exception
                          // usrR.createNewUser(
                          //   newUsername!,
                          //   email!,
                          //   password!,
                          //   phoneNumber!,
                          // );
                          final collectionRef = _firestore.collection('users');
                          final docRef = collectionRef.where(
                            'email',
                            isEqualTo: speciality,
                          );
                          final docSnapshot = await docRef.get();
                          final documentId = docSnapshot.docs.first.id;
                          print(documentId);

                          // await _firestore
                          //     .collection('users')
                          //     .doc(documentId)
                          //     .update({'imageUrl': _pickedImage!.path});

                          if (docSnapshot.docs.isNotEmpty) {
                            setState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'speciality created successfully',
                                ),
                                duration: const Duration(
                                  seconds: 3,
                                ), // Optional: set duration
                                action: SnackBarAction(
                                  // Optional: add an action button
                                  label: 'Undo',
                                  onPressed: () {
                                    // Perform an action when the "Undo" button is pressed
                                    print('Undo action performed!');
                                  },
                                ),
                              ),
                            );
                          }
                        } on TimeoutException catch (e) {
                          // Handles a specific type of exception (e.g., FormatException)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'request timed out check internet!',
                              ),
                              duration: const Duration(
                                seconds: 3,
                              ), // Optional: set duration
                              action: SnackBarAction(
                                // Optional: add an action button
                                label: 'Undo',
                                onPressed: () {
                                  // Perform an action when the "Undo" button is pressed
                                  print('Undo action performed!');
                                },
                              ),
                            ),
                          );
                        } catch (e) {
                          // Catches any other type of exception or error
                          print('Caught generic exception: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'failed to create speciality, error: ${e.toString()}',
                              ),
                              duration: const Duration(
                                seconds: 3,
                              ), // Optional: set duration
                              action: SnackBarAction(
                                // Optional: add an action button
                                label: 'Undo',
                                onPressed: () {
                                  // Perform an action when the "Undo" button is pressed
                                  print('Undo action performed!');
                                },
                              ),
                            ),
                          );
                        }
                        _formKey.currentState!.reset();
                      }
                    },
                    child: Text('create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Remove default padding
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('create user'),
              onTap: () {
                // Handle item 1 tap
                Navigator.of(context).pushNamed('/createuser');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('create barber'),
              onTap: () {
                // Handle item 2 tap

                Navigator.of(context).pushNamed('/createbarberhome');

                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('create product'),
              onTap: () {
                // Handle item 2 tap
                Navigator.of(context).pushNamed('/createproduct');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('create speciality'),
              onTap: () {
                // Handle item 2 tap
                Navigator.of(context).pushNamed('/createspeciality');
                // Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('create appointment'),
              onTap: () {
                // Handle item 2 tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
