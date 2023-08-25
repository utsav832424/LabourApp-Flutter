import 'package:abc_2_1/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // final txtController = TextEditingController();
  // final txtController2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    init();
  }

  String sitename = '';

  List tabBarView = [];

  TextEditingController txtController = TextEditingController();
  TextEditingController txtController2 = TextEditingController();
  final insertForm = GlobalKey<FormState>();

  late SharedPreferences prefs;
  Map<String, dynamic> data = {};
  ApiService apiService = ApiService();
  bool loginLoeader = false;

  init() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sitename = prefs.getString('sitename').toString();
      txtController.text = sitename;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/profile_bg.jpg",
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Image.asset('assets/logo.png')),
                Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 5, right: 10, left: 10, top: 15),
                        child: Text(
                          "Site Name",
                          style: TextStyle(
                            fontFamily: "Century Gothic",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: TextFormField(
                          controller: txtController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "${sitename}",
                            // labelText: 'Name',
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 5, right: 10, left: 10, top: 15),
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            child: TextFormField(
                              controller: txtController2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password',
                                // labelText: 'Name',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/profile_bg.jpg",
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Image.asset('assets/logo.png')),
                Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 5, right: 10, left: 10, top: 15),
                        child: Text(
                          "Site Name",
                          style: TextStyle(
                            fontFamily: "Century Gothic",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: TextFormField(
                          controller: txtController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "${sitename}",
                            // labelText: 'Name',
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 5, right: 10, left: 10, top: 15),
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            child: TextFormField(
                              controller: txtController2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password',
                                // labelText: 'Name',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
