import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/machinery_report-detail.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SMachinery_report extends StatefulWidget {
  SMachinery_report({Key? key}) : super(key: key);

  @override
  State<SMachinery_report> createState() => _SMachinery_reportState();
}

class _SMachinery_reportState extends State<SMachinery_report> {
  final txtController = TextEditingController();
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
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  TextEditingController suppliername = TextEditingController();
  TextEditingController vehicle = TextEditingController();
  TextEditingController vehicle_no = TextEditingController();
  TextEditingController operator = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController editsuppliername = TextEditingController();
  TextEditingController editvehicle = TextEditingController();
  TextEditingController editvehicleno = TextEditingController();
  TextEditingController editoperator = TextEditingController();
  TextEditingController editunit = TextEditingController();
  TextEditingController editqty = TextEditingController();

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;
  final loginForm = GlobalKey<FormState>();

  var token = "";
  var userid = 0;
  var userType = 0;
  late List machinery = [];
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
    setState(() {
      loader = true;
    });

    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "machinery/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
    log("${resData}");
    if (mounted) {
      setState(() {
        machinery = resData['data'];
        loader = false;
      });
    }
  }

  final txtController2 = TextEditingController();
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
        init();
      });
    });
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "machinery?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
  }

  // final txtController2 = TextEditingController();
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
        init();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
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
                            width: 300,
                            margin: EdgeInsets.all(10),
                            padding:
                                EdgeInsets.only(top: 5, bottom: 5, left: 20),
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
                                    "Machinery Report",
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Table(
                          border: TableBorder(
                              horizontalInside: BorderSide(
                            color: Colors.grey,
                          )),
                          columnWidths: userType == 1
                              ? {
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(4),
                                  3: FlexColumnWidth(4),
                                }
                              : {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(2),
                                  4: FlexColumnWidth(2),
                                },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      child: Text(
                                        "Admin",
                                        style: TextStyle(
                                            fontFamily: "Century Gothic",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var data in machinery)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SMachinery_report_detail(
                                                  supliername: data['user_id'],
                                                  refresh: ((filters) {
                                                    init();
                                                  }),
                                                ),
                                              ));
                                        },
                                        child: Text(
                                          "${data['sitename']}",
                                          style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
          ),
        );
      } else {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
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
                            padding:
                                EdgeInsets.only(top: 5, bottom: 5, left: 20),
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
                                    "Machinery Report",
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Table(
                          border: TableBorder(
                              horizontalInside: BorderSide(
                            color: Colors.grey,
                          )),
                          columnWidths: userType == 1
                              ? {
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(4),
                                  3: FlexColumnWidth(4),
                                }
                              : {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(2),
                                  4: FlexColumnWidth(2),
                                },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Suppliername",
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Century Gothic",
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var data in machinery)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 8, bottom: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SMachinery_report_detail(
                                                  supliername: data['user_id'],
                                                  refresh: ((filters) {
                                                    init();
                                                  }),
                                                ),
                                              ));
                                        },
                                        child: Text(
                                          "${data['sitename']}",
                                          style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
