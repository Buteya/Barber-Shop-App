import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class User with ChangeNotifier {
  String? id;
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? country;
  String? city;
  DateTime? createdAt;
  bool? isOnline;

  User({
    @required id,
    @required username,
    @required email,
    @required password,
    @required phoneNumber,
    country,
    city,
    createdAt,
    isOnline,
  });

  //sharedPreferences with cache
   final Future<SharedPreferencesWithCache> _prefs =  SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // This cache will only accept the key 'counter'.
          allowList: <String>{'userId'}));

  //firebase user
  final  _user = FirebaseAuth.instance.currentUser;

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
    final userId = Uuid().v4();
    final userPrefs = await _prefs ;
    if(userPrefs.getString('userId') != userId){
      try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, // Get email from text field
        password: password, // Get password from text field
      );
      // User created successfully, handle navigation or show success message
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Handle weak password error
        return 'password is weak';
      } else if (e.code == 'email-already-in-use') {
        // Handle email already in use error
        return 'email already in use';
      }
      // Handle other FirebaseAuthExceptions
      return e.message!;
    } catch (e) {
      // Handle general errors
      return 'error';
    }

    final userCreatedAt = DateFormat(
      'EEE, MMM d, y hh:mm aaa',
    ).format(DateTime.now());

    Map<String, dynamic> userData = {
      'id': userId,
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'country': country,
      'city': city,
      'createdAt': userCreatedAt,
      'isOnline':false,
    };

    // variable to store user
    User user = User(
      id: userId,
      username: username,
      email: FirebaseAuth.instance.currentUser!.email ?? email,
      password: password,
      phoneNumber: phoneNumber,
      country: country,
      city: city,
      createdAt: userCreatedAt,
      isOnline: false,
    );
    // check if the required user properties are empty
    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        phoneNumber.isNotEmpty) {
      //cache the id of the new user to shared preferences
      userPrefs.setString("userId", userId);
      final newPrefs = await SharedPreferences.getInstance();
      newPrefs.setString('newUserId', userId);
      // add the user
      _users.add(user);

      // Example using set() with a specific document ID
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(userData);

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
    }else{
      return "user already exists ";
    }
  }

  //method for login user
  void loginUser(String email,String password) async{
    final userPrefs = await _prefs;
    final userId = userPrefs.getString("userId");
    final newPrefs = await SharedPreferences.getInstance();
    final newUserId = newPrefs.getString('newUserId');
    if(email.isNotEmpty && password.isNotEmpty){
        FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        if(FirebaseAuth.instance.currentUser != null){
          final collectionRef = FirebaseFirestore.instance.collection('users');
          print(FirebaseAuth.instance.currentUser!.uid);
          final docRef = collectionRef.doc(FirebaseAuth.instance.currentUser!.uid);
          final docSnapshot = await docRef.get();
          if(docSnapshot.exists){
            final data = docSnapshot.data();
            print(data);
            await docRef.update({
              'isOnline': true,
            });
        }
      }else{
        print("document not found");
      }
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
      if (_users[index].username == username ||
          _users[index].email == email ||
          _users[index].password == password ||
          _users[index].phoneNumber == phoneNumber ||
          _users[index].country == country ||
          _users[index].city == city) {
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
