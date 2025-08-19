import 'package:barbershop/users.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var email;
    var password;
    var username;
    var phoneNumber;
    User? user = User(username: username, email: email, password: password, phoneNumber: phoneNumber);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
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
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                // Store the value, e.g., in a state variable or data model
                password = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // All fields are valid, proceed to save or submit
                  formKey.currentState!.save(); // Triggers onSaved callbacks
                  // Perform submission logic
                  print(username);
                  print(email);
                  print(password);
                  print(phoneNumber);
                  user!.createNewUser(username, email, password, phoneNumber);
                }
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
