import "dart:async";

import "package:barbershop/models/users.dart" as usr;
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var email;
    var password;
    final user = usr.User(
      id: '',
      username: '',
      email: email,
      password: password,
      phoneNumber: '',
    );
    return isLoading?Center(child: CircularProgressIndicator()):Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: MediaQuery.widthOf(context) * .2718,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.widthOf(context) * .09,
                backgroundImage: AssetImage(
                  'assets/images/barber shop logo.png',
                ),
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
                    if(formKey.currentState!.validate()){
                      // All fields are valid, proceed to save or submit
                      formKey.currentState!.save(); // Triggers onSaved callbacks
                      // Perform submission logic
                      print(email);
                      print(password);
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        // Code that might throw an exception
                        user.loginUser(email, password,context);
                        if(firebaseAuth.currentUser != null){
                          final collectionRef = FirebaseFirestore.instance.collection('users');
                          final newUserId = firebaseAuth.currentUser!.uid;
                          print(newUserId);
                          final docRef = collectionRef.doc(newUserId);
                          final docSnapshot = await docRef.get();
                          if(docSnapshot.exists){
                            final data = docSnapshot.data();
                            print(data);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('login successful!'),
                            duration: const Duration(seconds: 3), // Optional: set duration
                            action: SnackBarAction( // Optional: add an action button
                              label: 'close',
                              onPressed: () {
                                // Perform an action when the "Undo" button is pressed
                                print('close action performed!');
                              },
                            ),
                          ));
                        }
                      } on TimeoutException catch (e) {
                        // Handles a specific type of exception (e.g., FormatException)
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('request timed out check internet!'),
                          duration: const Duration(seconds: 3), // Optional: set duration
                          action: SnackBarAction( // Optional: add an action button
                            label: 'Undo',
                            onPressed: () {
                              // Perform an action when the "Undo" button is pressed
                              print('Undo action performed!');
                            },
                          ),
                        ));
                      } catch (e) {
                        // Catches any other type of exception or error
                        print('Caught generic exception: $e');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:  Text('failed to login  user, error: ${e.toString()}'),
                          duration: const Duration(seconds: 3), // Optional: set duration
                          action: SnackBarAction( // Optional: add an action button
                            label: 'Undo',
                            onPressed: () {
                              // Perform an action when the "Undo" button is pressed
                              print('Undo action performed!');
                            },
                          ),
                        ));
                      }
                      formKey.currentState!.reset();
                    }
                  },
                  child: Text("login"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signin');
                },
                child: Text("signup"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(onPressed: (){}, child: Text('forgot password?')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
