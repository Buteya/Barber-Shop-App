import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barbershop/models/users.dart' as usr;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        automaticallyImplyLeading: false,
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
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.heightOf(context) * .49,
              child: Image.asset(
                'assets/images/barber shop interior.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.heightOf(context) * .13),
              child: Text(textAlign: TextAlign.center, """
                                ✂️ Welcome to Your New Favorite Barbershop Experience
                Step into a space where style meets precision, and every cut tells a story. At Barber shop, we don’t just offer haircuts—we craft confidence.
🧼 Premium Grooming, Tailored to You
                Whether you're after a clean shave, a fresh fade, or a bold new look, our skilled barbers are here to deliver. Choose your favorite barber, book your appointment online, and skip the wait. Your time matters—and so does your style.
                    🛍️ Top-Tier Hair Products, Right at Your Fingertips
                From nourishing shampoos to beard oils that mean business, our curated selection of hair products keeps you looking sharp long after you leave the chair. Shop in-store or online—your grooming game just leveled up.
                """),
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.heightOf(context) * .36,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: MediaQuery.widthOf(context) * .3,
                      backgroundImage: AssetImage(
                        'assets/images/barber shop logo.png',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: MediaQuery.heightOf(context) * .16,
                  width: MediaQuery.widthOf(context),
                  height: MediaQuery.heightOf(context) * 1.45,
                  child: Container(
                    color: Colors.black26,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.widthOf(context) * 0.01,
                            ),
                            child: Container(
                              height: MediaQuery.heightOf(context) * 0.20,
                              width: MediaQuery.widthOf(context) * 0.19,
                              color: Colors.amber,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.cut_rounded),
                                  Text('Cut'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: MediaQuery.widthOf(context) * 0.16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.widthOf(context) * 0.01,
                            ),
                            child: Container(
                              height: MediaQuery.heightOf(context) * 0.20,
                              width: MediaQuery.widthOf(context) * 0.19,
                              color: Colors.amber,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.shopping_bag_rounded),
                                  Text('Products'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.heightOf(context) * .008,
              ),
              child: Text(textAlign: TextAlign.center, """
📅 Book. Sit. Shine.
Our easy-to-use booking system lets you pick your preferred barber, time slot, and service—all in just a few clicks. No guesswork, no hassle. Just great hair, on your schedule.
💈 Why Choose Us?
         • 	Expert barbers with personality and precision
• 	Clean, modern space with a relaxed vibe
• 	High-quality products for every hair type
                  • 	Seamless online booking with real-time availability
Come for the cut. Stay for the experience.
Your chair is waiting.
            """),
            ),
            Container(
              width: MediaQuery.widthOf(context),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 69.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('email:'),
                        SizedBox(width: MediaQuery.widthOf(context) * 0.01),
                        Text('admin@gmail'),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('phone:'),
                        SizedBox(width: MediaQuery.widthOf(context) * 0.01),
                        Text('0700415452'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copyright_rounded),
                          Text('${DateTime.now().year}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
