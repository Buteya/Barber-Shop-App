import 'dart:async';

import 'package:barbershop/models/users.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var email;
    var password;
    var username;
    var phoneNumber;
    User? user = User(
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      id: '',
    );
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // Store the value, e.g., in a state variable or data model
                        username = value;
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
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // All fields are valid, proceed to save or submit
                            formKey.currentState!
                                .save(); // Triggers onSaved callbacks
                            // Perform submission logic

                            print(username);
                            print(email);
                            print(password);
                            print(phoneNumber);
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              // Code that might throw an exception
                              user.createNewUser(
                                username!,
                                email!,
                                password!,
                                phoneNumber!,
                              );
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
                                    'failed to sign up  user, error: ${e.toString()}',
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
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                              // Code that always executes, regardless of whether an exception occurred
                              print('Finally block executed.');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'user added successfully',
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
                            formKey.currentState!.reset();
                            Navigator.of(context).pushNamed('/login');
                          }
                        },
                        child: Text('Sign in'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Text('login'),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
