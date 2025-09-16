import 'dart:async';

import 'package:barbershop/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/users.dart' as usr;

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();
  late XFile _pickedImage = XFile('');
  final ImagePicker _imagePicker = ImagePicker();
  final _firestore = FirebaseFirestore.instance;
  final productId = Uuid().v4();
  var supplierName;
  var productName;
  var productPrice;
  var productQuantity;
  User? user = FirebaseAuth.instance.currentUser;
  final usrR = usr.User(
    id: '',
    username: '',
    email: '',
    password: '',
    phoneNumber: '',
  );
  final productModel = Product(
    id: '',
    supplierId: '',
    imagePath: '',
    name: '',
    price: 0.0,
    quantity: 0.0,
  );
  String username = '';
  bool isUsername = false;
  bool isLoading = false;
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
                        children: [Icon(Icons.image_rounded), Text('pick image')],
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
                  decoration: InputDecoration(labelText: 'Supplier'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your supplier';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    supplierName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    productName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    productPrice = double.tryParse(value!);
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Store the value, e.g., in a state variable or data model
                    productQuantity = double.tryParse(value!);
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
        
                        print(supplierName);
                        print(productName);
                        print(productPrice);
                        print(productQuantity);
                        print(_pickedImage!.path);
                        try {
                          setState(() {
                            isLoading = true;
                          });
        
                          // // Code that might throw an exception
                          productModel.createNewProduct(
                            productId,
                            _pickedImage.path,
                            productName,
                            productPrice,
                            productQuantity,
                          );
                          final collectionRef = _firestore.collection('products');
                          final docRef = collectionRef.where(
                            'id',
                            isEqualTo: productId,
                          );
                          final docSnapshot = await docRef.get();
                          final document = docSnapshot.docs.first.data();
                          print(document);
        
        
                          if (document.isNotEmpty) {
                            setState(() {
                              isLoading = false;
                            });
        
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('product created successfully'),
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
                                'failed to create  product, error: ${e.toString()}',
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
