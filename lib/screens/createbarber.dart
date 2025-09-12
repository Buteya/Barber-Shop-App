import 'dart:async';

import 'package:barbershop/screens/404.dart';
import 'package:barbershop/screens/createbarberhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barbershop/models/users.dart' as usr;
import 'package:image_picker/image_picker.dart';
import 'package:barbershop/models/barber.dart';

class CreateBarber extends StatefulWidget {
  const CreateBarber({super.key});

  @override
  State<CreateBarber> createState() => _CreateBarberState();
}

class _CreateBarberState extends State<CreateBarber> {
  final _firestore = FirebaseFirestore.instance;
  late Object? arguments;
  late XFile? _pickedImage = XFile('');
  final ImagePicker _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  final usrR = usr.User(
    id: '',
    username: '',
    email: '',
    password: '',
    phoneNumber: '',
  );
  final barber = Barber(
    id: '',
    firstname: '',
    lastname: '',
    speciality: '',
    salary: '',
    email: '',
  );
  String? firstname;
  String? lastname;
  String? speciality;
  double? salary;
  String username = '';
  String? email;
  String? password;
  bool isUsername = false;
  bool isImagePicked = true;

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
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments;
    return user == null
        ? PageNotFound()
        : arguments == null? CreateBarberHome() :Scaffold(
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 108.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
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
                      isImagePicked?SizedBox():Text('please pick barber image',style: TextStyle(color: Colors.red),),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          initialValue: arguments.toString(),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'firstname'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your firstname';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // Store the value, e.g., in a state variable or data model
                            firstname = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'lastname'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your lastname';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // Store the value, e.g., in a state variable or data model
                            lastname = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'speciality'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your speciality';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // Store the value, e.g., in a state variable or data model
                            speciality = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'salary'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your salary';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // Store the value, e.g., in a state variable or data model
                            salary = double.tryParse(value!);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 56.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(_pickedImage!.path.toString().isEmpty){
                            setState(() {
                              isImagePicked = false;
                            });
                          }
                            if (_formKey.currentState!.validate()) {

                              // All fields are valid, proceed to save or submit
                              _formKey.currentState!
                                  .save(); // Triggers onSaved callbacks
                              // Perform submission logic
                              print(_pickedImage!.path);

                              print(firstname);
                              print(lastname);
                              print(speciality);
                              print(salary);
                              print(email);

                              try {
                                // Code that might throw an exception
                                barber.newBarber(
                                  _pickedImage!.path,
                                  firstname!,
                                  lastname!,
                                  speciality!,
                                  email!,
                                  salary,
                                );
                                final collectionRef = _firestore.collection('users');
                                final docRef = collectionRef.where('email', isEqualTo: email);
                                final docSnapshot = await docRef.get();
                                final documentId = docSnapshot.docs.first.id;

                                final newBarber = await _firestore.collection('barbers').doc(documentId).get();
                                if(newBarber.exists){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'barber created successfully',
                                      ),
                                      duration: const Duration(
                                        seconds: 3,
                                      ), // Optional: set duration
                                      action: SnackBarAction(
                                        // Optional: add an action button
                                        label: 'Close',
                                        onPressed: () {
                                          // Perform an action when the "Undo" button is pressed
                                          print('Close action performed!');
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
                                      label: 'Close',
                                      onPressed: () {
                                        // Perform an action when the "Undo" button is pressed
                                        print('Close action performed!');
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
                                      'failed to create  barber, error: ${e.toString()}',
                                    ),
                                    duration: const Duration(
                                      seconds: 3,
                                    ), // Optional: set duration
                                    action: SnackBarAction(
                                      // Optional: add an action button
                                      label: 'Close',
                                      onPressed: () {
                                        // Perform an action when the "Undo" button is pressed
                                        print('Close action performed!');
                                      },
                                    ),
                                  ),
                                );
                              }
                              _formKey.currentState!.reset();
                            }
                          },
                          child: Text("create"),
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
                      Navigator.pop(context); // Close the drawer
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
                      Navigator.pop(context); // Close the drawer
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
