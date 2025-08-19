import 'package:flutter/material.dart';

class User {
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

  // list of all users
  List<User> users = [];

  // method to add a new user and default values for parameters that are not required
  String createNewUser(
    String username,
    String email,
    String password,
    String phoneNumber, {
    String country = "N/A",
    String city = "N/A",
  }) {
    // variable to store user
    User user = User(
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    // check if the required user properties are empty
    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        phoneNumber.isNotEmpty) {
      // add the user
      users.add(user);
      // check if the user has been added successfully
      if (users.contains(user)) {
        return "User added successfully";
      } else {
        return "failed to add user";
      }
    } else {
      return "no empty fields allowed";
    }
  }

  //method to update a user if parameters are not provided the default value is null
  String updateUser(int index,  [String? username,
  String? email,
  String? password,
  String? phoneNumber,
  String? country,
  String? city]){
    if(users.contains(users[index])){
      // update the user with new value otherwise retain the old value
      users[index].username = username ?? users[index].username;
      users[index].email = email ?? users[index].email;
      users[index].password = password ?? users[index].password;
      users[index].phoneNumber = phoneNumber ?? users[index].phoneNumber;
      users[index].country = country ?? users[index].country;
      users[index].city = city ?? users[index].city;
      // check if user is still there
      if(users.contains(users[index])){
        return "user updated successfully";
      }else{
        return "failed to update user";
      }
    }else{
      return "user not found";
    }
  }

  // method to delete user
  String deleteUser(int index){
    //variable storing user
    User user = users[index];

    // check if user is there
    if(users.contains(user)){
      //delete
      users.remove(user);
      // check if user has been deleted
      if(users.contains(user)){
        return "failed to delete user";
      }else{
        return "user deleted successfully";
      }
    }else{
      return "user not found";
    }
  }

  // method delete all users
  String deleteAllUsers(){
    // using while loop to delete the last user until there is none left
    while(users.isNotEmpty){
      users.removeLast();
    }
    // check if there are any users left
    if(users.isEmpty){
      return "all users have been deleted";
    }else {
      return "failed to delete all users";
    }
  }
}
