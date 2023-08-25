import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/operatordetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOperator extends StatefulWidget {
  SOperator({Key? key}) : super(key: key);

  @override
  State<SOperator> createState() => _SOperatorState();
}

class _SOperatorState extends State<SOperator> {
  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController Date = TextEditingController();

  void _selDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // txtController.text = DateFormat.yMd().format(pickedDate);
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List businessname = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token').toString();
    userid = prefs.getInt('user_id')!.toInt();
    userType = prefs.getInt('type')!.toInt();
    setState(() {
      loader = true;
    });

    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall("operator/group");
    log("${resData}");
    if (mounted) {
      setState(() {
        data = resData['data'];
        loader = false;
      });
    }
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall("operator");
  }

  final txtController2 = TextEditingController();
  void _selDatePicker2() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // txtController.text = DateFormat.yMd().format(pickedDate);
        txtController2.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  final txtController3 = TextEditingController();
  void _selDatePicker3() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // txtController.text = DateFormat.yMd().format(pickedDate);
        txtController2.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/report.png",
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                "Operator",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      for (var item in data)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OperatorDetail(
                                              user_id: item['user_id'],
                                              refresh: ((filters) {
                                                init();
                                              }),
                                            ),
                                          ));
                                    },
                                    child: Text(
                                      "${item['sitename']}",
                                      style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      init();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ),
              if (loader)
                Positioned(
                    child: Container(
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.green,
                        ))))
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // width: 300,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/report.png",
                                height: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text(
                                  "Operator",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      for (var item in data)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OperatorDetail(
                                              user_id: item['user_id'],
                                              refresh: ((filters) {
                                                init();
                                              }),
                                            ),
                                          ));
                                    },
                                    child: Text(
                                      "${item['sitename']}",
                                      style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      init();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ),
              if (loader)
                Positioned(
                    child: Container(
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.green,
                        ))))
            ],
          ),
        );
      }
    });
  }

  void ToastMsg(String msg, double fontsize, Color color) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text("$msg"),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
