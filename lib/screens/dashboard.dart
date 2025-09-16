import 'package:barbershop/screens/404.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barbershop/models/users.dart' as usr;
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? PageNotFound()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome $username to your dashboard',
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                  Text("""
Welcome, Administrator. This dashboard grants you full visibility and control over all aspects of the website. As an admin, you have access to:
• 	User Management: View, edit, or remove user accounts. Monitor activity and manage roles or permissions.
• 	Content Oversight: Review and update all published content, including articles, media, and comments.
• 	Analytics & Reports: Track website performance, user engagement, and traffic metrics in real time.
• 	System Settings: Configure site-wide preferences, integrations, and security protocols.
• 	Database Access: Inspect and manage stored data, including user submissions, logs, and backups.
• 	Notifications & Logs: Stay informed with system alerts, error logs, and audit trails.
🔐 Everything that happens on the website is visible here. You hold the keys to monitor, manage, and maintain the platform's integrity.
                """),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.widthOf(context) * 0.4,
                        height: MediaQuery.heightOf(context) * 0.2,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: false,
                            ), // Hide grid lines
                            titlesData: FlTitlesData(
                              show: false,
                            ), // Hide titles
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, 3),
                                  FlSpot(1, 5),
                                  FlSpot(2, 2),
                                  FlSpot(3, 7),
                                  FlSpot(4, 4),
                                ],
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 4,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.widthOf(context)*0.4,
                        height: MediaQuery.heightOf(context)*0.2,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                value: 40,
                                color: Colors.red,
                                title: '40%',
                                radius: 50,
                                titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: 30,
                                color: Colors.green,
                                title: '30%',
                                radius: 50,
                                titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: 20,
                                color: Colors.blue,
                                title: '20%',
                                radius: 50,
                                titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: 10,
                                color: Colors.yellow,
                                title: '10%',
                                radius: 50,
                                titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
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
                            InkWell(
                              child: CircleAvatar(child: Icon(Icons.person)),
                            ),
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
                    backgroundImage: AssetImage(
                      'assets/images/barber shop logo.png',
                    ),
                  ),
                  SizedBox(width: MediaQuery.widthOf(context) * 0.01),
                  Text('Barber shop'),
                ],
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
