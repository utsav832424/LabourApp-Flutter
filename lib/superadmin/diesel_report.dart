import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/diesel_report_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sdiesel_Report extends StatefulWidget {
  Sdiesel_Report({Key? key}) : super(key: key);
  // final data;
  // final type;

  @override
  State<Sdiesel_Report> createState() => _Sdiesel_ReportState();
}

class _Sdiesel_ReportState extends State<Sdiesel_Report> {
  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  double totalused = 0;
  double incoming = 0;
  double yesterdaystock = 0;
  double totalstock = 0;

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
        init();
      });
    });
  }

  TextEditingController machinery = TextEditingController();
  TextEditingController vehiclenumber = TextEditingController();
  TextEditingController driver = TextEditingController();
  TextEditingController qty_ltr = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController editvehiclenumber = TextEditingController();
  TextEditingController editdriver = TextEditingController();
  TextEditingController editqtyltr = TextEditingController();
  TextEditingController editvehiclename = TextEditingController();

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List diesel = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();

    txtController3.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
    userType = prefs.getInt('type')!.toInt();
    var resData = await apiService.getcall(
        "diesel/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
    log("${resData}");
    if (mounted) {
      setState(() {
        diesel = resData['data'];
        // totalused = resData['total_used'];
        // incoming = resData['incoming'];
        // yesterdaystock = resData['yesterday'];
        // totalstock = resData['total_stock'];
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
        txtController3.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();

    var resData = await apiService.getcall(
        "diesel?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}");
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return Scaffold(
            body: Stack(
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
                                  "Diesel Report",
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
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      "Admin",
                                      style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var data in diesel)
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
                                                    SDiesel_report_detail(
                                                  machinery: data['user_id'],
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
                if (userType == 1)
                  Positioned(
                    bottom: 60,
                    left: 120,
                    child: TextButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Add Diesel'),
                              actions: <Widget>[
                                Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            "Date",
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: TextFormField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter a Date',
                                            ),
                                            onTap: _selDatePicker3,
                                            controller: txtController3,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter Date";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "Qty Ltr",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // width: 165,
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 6, top: 10),
                                              child: TextFormField(
                                                controller: qtyltr,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter Qty Ltr";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Qty Ltr',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            // width: MediaQuery.of(context).size.width,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green[100],
                                                onPrimary: Colors.blue[900],
                                              ),
                                              onPressed: () async {
                                                var data =
                                                    Map<String, dynamic>();
                                                data['date'] =
                                                    txtController3.text;
                                                data['user_id'] =
                                                    userid.toString();
                                                data['qty_ltr'] = qtyltr.text;
                                                var resData =
                                                    await apiService.postCall(
                                                        'diesel/addNewDiesel',
                                                        data);
                                                if (resData['success'] == 0) {
                                                  ToastMsg(
                                                    resData['message'],
                                                    15,
                                                    Colors.red,
                                                  );
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("Save"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.blue[900],
                            ),
                            Text(
                              "Add Diesel",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
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
                                      "Diesel Report",
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
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        "Admin",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              for (var data in diesel)
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
                                                      SDiesel_report_detail(
                                                    machinery: data['user_id'],
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
                  if (userType == 1)
                    Positioned(
                      bottom: 60,
                      left: 120,
                      child: TextButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Add Diesel'),
                                actions: <Widget>[
                                  Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              "Date",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: TextFormField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a Date',
                                              ),
                                              onTap: _selDatePicker3,
                                              controller: txtController3,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter Date";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: Text(
                                                  "Qty Ltr",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // width: 165,
                                                margin: EdgeInsets.only(
                                                    left: 8, right: 6, top: 10),
                                                child: TextFormField(
                                                  controller: qtyltr,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter Qty Ltr";
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText: 'Qty Ltr',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              // width: MediaQuery.of(context).size.width,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green[100],
                                                  onPrimary: Colors.blue[900],
                                                ),
                                                onPressed: () async {
                                                  var data =
                                                      Map<String, dynamic>();
                                                  data['date'] =
                                                      txtController3.text;
                                                  data['user_id'] =
                                                      userid.toString();
                                                  data['qty_ltr'] = qtyltr.text;
                                                  var resData =
                                                      await apiService.postCall(
                                                          'diesel/addNewDiesel',
                                                          data);
                                                  if (resData['success'] == 0) {
                                                    ToastMsg(
                                                      resData['message'],
                                                      15,
                                                      Colors.red,
                                                    );
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text("Save"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.blue[900],
                              ),
                              Text(
                                "Add Diesel",
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
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
            ),
          );
        }
      },
    );
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
