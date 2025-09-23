import 'package:barbershop/screens/404.dart';
import 'package:barbershop/screens/createbarber.dart';
import 'package:barbershop/screens/createbarberhome.dart';
import 'package:barbershop/screens/createproduct.dart';
import 'package:barbershop/screens/createspeciality.dart';
import 'package:barbershop/screens/createsupplier.dart';
import 'package:barbershop/screens/createuser.dart';
import 'package:barbershop/screens/dashboard.dart';
import 'package:barbershop/screens/home.dart';
import 'package:barbershop/screens/login.dart';
import 'package:barbershop/screens/signin.dart';
import 'package:barbershop/models/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utilities/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => User(
            id: '',
            username: '',
            email: '',
            password: '',
            phoneNumber: '',
            isOnline: false,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/signin': (context) => SignIn(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/pagenotfound': (context) => PageNotFound(),
        '/dashboard': (context) => Dashboard(),
        '/createbarber': (context) => CreateBarber(),
        '/createbarberhome': (context) => CreateBarberHome(),
        '/createuser': (context) => CreateUser(),
        '/createproduct': (context) => CreateProduct(),
        '/createspeciality': (context) => CreateSpeciality(),
        '/createsupplier': (context) => CreateSupplier(),
      },
      title: 'Barber Shop',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
