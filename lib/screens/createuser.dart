import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/users.dart' as usr;

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _firestore = FirebaseFirestore.instance;
  late XFile? _pickedImage = XFile('');
  final ImagePicker _imagePicker = ImagePicker();
  var email;
  var password;
  var newUsername;
  var phoneNumber;
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
  bool isImagePicked = true;
  bool isLoading = false;

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

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      // Use the picked image, e.g., display it or upload it
      // image.path contains the path to the selected image
      setState(() {
        _pickedImage = image;
      });
    }
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
                      InkWell(child: CircleAvatar(child: Icon(Icons.person))),
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
              backgroundImage: AssetImage('assets/images/barber shop logo.png'),
            ),
            SizedBox(width: MediaQuery.widthOf(context) * 0.01),
            Text('Barber shop'),
          ],
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
              title: const Text('create appointment'),
              onTap: () {
                // Handle item 2 tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 108),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: MediaQuery.widthOf(context) * 0.2,
                  backgroundImage: NetworkImage(_pickedImage!.path),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_rounded),
                          Text('pick image'),
                        ],
                      ),
                    ),
                  ),
                ),
                isImagePicked
                    ? SizedBox()
                    : Text(
                        'please pick barber image',
                        style: TextStyle(color: Colors.red),
                      ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    newUsername = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    phoneNumber = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    email = value;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    password = value;
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

                        print(newUsername);
                        print(email);
                        print(password);
                        print(phoneNumber);
                        print(_pickedImage!.path);
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          // Code that might throw an exception
                          usrR.createNewUser(
                            newUsername!,
                            email!,
                            password!,
                            phoneNumber!,
                          );
                          final collectionRef = _firestore.collection('users');
                          final docRef = collectionRef.where(
                            'email',
                            isEqualTo: email,
                          );
                          final docSnapshot = await docRef.get();
                          final documentId = docSnapshot.docs.first.id;
                          print(documentId);

                            await _firestore
                                .collection('users')
                                .doc(documentId)
                                .update({'imageUrl': _pickedImage!.path});

                          if (docSnapshot.docs.isNotEmpty) {
                            setState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'user created successfully',
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
                                'failed to create  user, error: ${e.toString()}',
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
    );
  }
}
