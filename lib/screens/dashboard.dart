import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barbershop/models/users.dart' as usr;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    User? user;
    final usrR = usr.User(
      id: '',
      username: '',
      email: '',
      password: '',
      phoneNumber: '',
    );
    String username = '';
    bool isUsername = false;
    Future<void> getUser() async {
      if(user != null){
        setState(() {
          isUsername = true;
        });
        var userNew = await usrR.getUserName();
        if(mounted){
          setState(() async {
            username = userNew!;
            isUsername = false;
          });
        }
        setState(() {
          isUsername = false;
        });
      }


    }

    @override
    initState() {
      // TODO: implement initState
      super.initState();
      user = FirebaseAuth.instance.currentUser;
      getUser();
    }
    return Scaffold(appBar:AppBar(
      actions: [
        user != null
            ? InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/dashboard');
          },
          child: Row(
            children: [
              isUsername?CircularProgressIndicator():Text(username),
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
    ),drawer: Drawer(),);
  }
}
