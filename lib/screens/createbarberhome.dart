import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barbershop/models/users.dart' as usr;

class CreateBarberHome extends StatefulWidget {
  const CreateBarberHome({super.key});

  @override
  State<CreateBarberHome> createState() => _CreateBarberHomeState();
}

class _CreateBarberHomeState extends State<CreateBarberHome> {
  late Future<List<Map<String, dynamic>>> _usersFuture;
  TextEditingController searchTerm = TextEditingController();
  late List<Map<String,dynamic>> _searchedUsers;
  List<Map<String,dynamic>> newList=[];
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
  bool isSearching = false;

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

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      // Get a reference to the 'users' collection
      CollectionReference usersCollection = FirebaseFirestore.instance
          .collection('users');

      // Fetch all documents from the collection
      QuerySnapshot querySnapshot = await usersCollection.get();

      // Extract data from each document and add to a list
      List<Map<String, dynamic>> usersData = [];
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        usersData.add(document.data() as Map<String, dynamic>);
        // You can also access the document ID: print(document.id);
      }
      if(usersData.isNotEmpty){
        newList = usersData;
      }

      print(usersData);
      return usersData;
    } catch (e) {
      print("Error getting users: $e");
      return []; // Return an empty list or handle the error as appropriate
    }
  }

  void searchUsers(String search)async{

      setState(() {
        isSearching = true;
      });
      print(search);

      print('search User called');
      _searchedUsers = await _usersFuture;
      print(_searchedUsers);
      setState(() {
        newList = _searchedUsers.where((user)=>user['username'].toString().toLowerCase().contains(search)).toList();
      });
      print(_searchedUsers.where((userSs)=>userSs.toString().toLowerCase().contains(search)).length);
      print(newList);
      setState(() {
        isSearching = false;
      });

  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    getUser();
    _usersFuture = getAllUsers();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 91.0),
            child: Center(
              child: SearchBar(
                leading: Icon(Icons.search_rounded),
                onSubmitted: (_){
                  searchUsers(searchTerm.text);
                },
                onChanged: (value){
                  searchUsers(value);
                },
                controller: searchTerm,
                hintText: ' search user...',

              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 91.0,vertical: 24.0),
                child: Text('all users',),
              ),
            ],
          ),
          // In a StatefulWidget or StatelessWidget:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 91.0),
            child: SizedBox(
              height: MediaQuery.heightOf(context) * 0.6,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.value(newList),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No users found.');
                  } else {
                    // Display the list of users
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]['username']),
                          subtitle: Text(snapshot.data![index]['email']),
                          trailing: InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/createbarber');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.edit), Text('make barber')],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
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
