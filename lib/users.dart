import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? country;
  String? city;

  User({
    @required username,
    @required email,
    @required password,
    @required phoneNumber,
    country,
    city,
  });

  // cloud firestore instance
  final _firestore = FirebaseFirestore.instance;



  // list of all users internal private state
  final List<User> _users = [];

  // an unmodifiable list of all the users
  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  // method that returns a specif user
  User getUser(int index) {
    return _users.elementAt(index);
  }

  // method to add a new user and default values for parameters that are not required
  Future<String> createNewUser(
    String username,
    String email,
    String password,
    String phoneNumber, {
    String country = "N/A",
    String city = "N/A",
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, // Get email from text field
        password: password, // Get password from text field
      );
      // User created successfully, handle navigation or show success message
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Handle weak password error
      } else if (e.code == 'email-already-in-use') {
        // Handle email already in use error
      }
      // Handle other FirebaseAuthExceptions
    } catch (e) {
      // Handle general errors
    }
    // the current firebase user
    final firebaseUser = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> userData = {
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'country': country,
      'city': city,
    };

    // variable to store user
    User user = User(
      username: username,
      email: firebaseUser!.email ?? email,
      password: password,
      phoneNumber: phoneNumber,
      country: country,
      city: city,
    );
    // check if the required user properties are empty
    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        phoneNumber.isNotEmpty) {
      // add the user
      _users.add(user);

      // Example using set() with a specific document ID
      await _firestore.collection('users').doc(firebaseUser.uid).set(userData);

      // notify listening widgets to rebuild
      notifyListeners();
      // check if the user has been added successfully
      if (_users.contains(user)) {
        return "User added successfully";
      } else {
        return "failed to add user";
      }
    } else {
      return "no empty fields allowed";
    }
  }

  //method to update a user if parameters are not provided the default value is null
  String updateUser(
    int index, [
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    String? country,
    String? city,
  ]) {
    if (_users.contains(_users[index])) {
      // update the user with new value otherwise retain the old value
      _users[index].username = username ?? _users[index].username;
      _users[index].email = email ?? _users[index].email;
      _users[index].password = password ?? _users[index].password;
      _users[index].phoneNumber = phoneNumber ?? _users[index].phoneNumber;
      _users[index].country = country ?? _users[index].country;
      _users[index].city = city ?? _users[index].city;

      // notify listening widgets to rebuild
      notifyListeners();
      // check if user is still there
      if (_users.contains(_users[index])) {
        return "user updated successfully";
      } else {
        return "failed to update user";
      }
    } else {
      return "user not found";
    }
  }

  // method to delete user
  String deleteUser(int index) {
    //variable storing user
    User user = _users[index];

    // check if user is there
    if (_users.contains(user)) {
      //delete
      _users.remove(user);
      // notify listening widgets to rebuild
      notifyListeners();
      // check if user has been deleted
      if (_users.contains(user)) {
        return "failed to delete user";
      } else {
        return "user deleted successfully";
      }
    } else {
      return "user not found";
    }
  }

  // method delete all users
  String deleteAllUsers() {
    // using while loop to delete the last user until there is none left
    while (_users.isNotEmpty) {
      _users.removeLast();
    }
    // notify listening widgets to rebuild
    notifyListeners();
    // check if there are any users left
    if (_users.isEmpty) {
      return "all users have been deleted";
    } else {
      return "failed to delete all users";
    }
  }
}
