import 'package:abc_2_1/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SDetail extends StatefulWidget {
  SDetail({Key? key}) : super(key: key);

  @override
  State<SDetail> createState() => _SDetailState();
}

class _SDetailState extends State<SDetail> {
  // final txtController = TextEditingController();
  // final txtController2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    txtController.text = "${sitename}";
    txtController2.text = "****";
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
                      fontFamily: "Century Gothic",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    // color: Colors.white,
                  ),
                ),
                Container(
                  child: Text(
                    "Sahil Bhayani",
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: TextFormField(
                          controller: txtController,
                          readOnly: true,
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
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password',

                                // labelText: 'Name',
                              ),
                            ),
                          ),
                        ],
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
                      fontFamily: "Century Gothic",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    // color: Colors.white,
                  ),
                ),
                Container(
                  child: Text(
                    "Sahil Bhayani",
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: TextFormField(
                          controller: txtController,
                          readOnly: true,
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
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password',

                                // labelText: 'Name',
                              ),
                            ),
                          ),
                        ],
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
