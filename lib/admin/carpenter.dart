import 'dart:developer';

import 'package:abc_2_1/admin/contractordetail.dart';
import 'package:abc_2_1/apiservice.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carpenter extends StatefulWidget {
  Carpenter({Key? key, required this.data, required this.type})
      : super(key: key);
  final data;
  final type;

  @override
  State<Carpenter> createState() => _CarpenterState();
}

class _CarpenterState extends State<Carpenter> {
  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  late TextEditingController fromDateController;
  DateTime fromSelectedDate = DateTime.now();

  TextEditingController contractorname = TextEditingController();
  TextEditingController labourfullday = TextEditingController();
  TextEditingController labourothrs = TextEditingController();
  TextEditingController masonfullday = TextEditingController();
  TextEditingController masonothrs = TextEditingController();
  TextEditingController carpenterfullday = TextEditingController();
  TextEditingController carprnterothrs = TextEditingController();
  TextEditingController helperfullday = TextEditingController();
  TextEditingController helperothrs = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController addcontactorname = TextEditingController();

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List labour = [];
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
    userType = prefs.getInt('type')!.toInt();
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(bottom: 50),
            child: Scrollbar(
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
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
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "DATE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 16),
                                child: Text(
                                  "CONTRACTOR NAME",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "FULL DAY",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "O.T HRS",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            if (userType == 2)
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  child: Text(
                                    "Action",
                                    style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (var data in widget.data)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['date']}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Century Gothic",
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: widget.type == 1
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ContractorDetail(
                                                  contractor_id:
                                                      data['contractorname_id'],
                                                  tabindex: 2,
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      "${data['contractorname']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Century Gothic",
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['carpenterfullday']}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Century Gothic",
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['carprnterothrs']}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Century Gothic",
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              if (userType == 2)
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            addcontactorname.text =
                                                data['contractorname'];
                                            carpenterfullday.text =
                                                data['carpenterfullday']
                                                    .toString();
                                            carprnterothrs.text =
                                                data['carprnterothrs']
                                                    .toString();
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Edit Contactor Name'),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        TextFormField(
                                                          readOnly: true,
                                                          controller:
                                                              addcontactorname,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter contractorname";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a contractorname',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              carpenterfullday,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Full day";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Full Day',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              carprnterothrs,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter othrs";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText: 'O.T Hrs',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: Colors
                                                                  .green[100],
                                                              onPrimary: Colors
                                                                  .blue[900],
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (carpenterfullday
                                                                  .text
                                                                  .isEmpty) {
                                                                ToastMsg(
                                                                  "Please enter contractorname",
                                                                  15,
                                                                  Colors.red,
                                                                );
                                                              } else {
                                                                var param = Map<
                                                                    String,
                                                                    dynamic>();
                                                                param['carpenterfullday'] =
                                                                    carpenterfullday
                                                                        .text;
                                                                param['carprnterothrs'] =
                                                                    carprnterothrs
                                                                        .text;
                                                                param['id'] =
                                                                    data['id'];
                                                                var resData =
                                                                    await apiService
                                                                        .postCall(
                                                                            'labour/editContractor',
                                                                            param);
                                                                if (resData[
                                                                        'success'] ==
                                                                    0) {
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors.red,
                                                                  );
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              }
                                                            },
                                                            child: Text("Save"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            size: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            onTap:
                                            () async {
                                              // var data = Map<String, dynamic>();
                                              // data['name'] = addcontactorname.text;
                                              // data['user_id'] = userid.toString();
                                              var resData =
                                                  await apiService.getcall(
                                                'labour/deleteContractorReport/${data['id']}',
                                              );
                                              if (resData['sucess'] == 1) {
                                                ToastMsg(
                                                  resData['message'],
                                                  15,
                                                  Colors.green,
                                                );
                                              }
                                            };
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 15,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Container(
            child: Scrollbar(
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
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
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20),
                                child: Text(
                                  "DATE",
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 240),
                                child: Text(
                                  "CONTRACTOR NAME",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "FULL DAY",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "O.T HRS",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            if (userType == 2)
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  child: Text(
                                    "Action",
                                    style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (var data in widget.data)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['date']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: widget.type == 1
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ContractorDetail(
                                                  contractor_id:
                                                      data['contractorname_id'],
                                                  tabindex: 2,
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      "${data['contractorname']}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Century Gothic",
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['carpenterfullday']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['carprnterothrs']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              if (userType == 2)
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            addcontactorname.text =
                                                data['contractorname'];
                                            carpenterfullday.text =
                                                data['carpenterfullday']
                                                    .toString();
                                            carprnterothrs.text =
                                                data['carprnterothrs']
                                                    .toString();
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Edit Contactor Name'),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        TextFormField(
                                                          readOnly: true,
                                                          controller:
                                                              addcontactorname,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter contractorname";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a contractorname',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              carpenterfullday,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Full day";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Full Day',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              carprnterothrs,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter othrs";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText: 'O.T Hrs',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: Colors
                                                                  .green[100],
                                                              onPrimary: Colors
                                                                  .blue[900],
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (carpenterfullday
                                                                  .text
                                                                  .isEmpty) {
                                                                ToastMsg(
                                                                  "Please enter contractorname",
                                                                  15,
                                                                  Colors.red,
                                                                );
                                                              } else {
                                                                var param = Map<
                                                                    String,
                                                                    dynamic>();
                                                                param['carpenterfullday'] =
                                                                    carpenterfullday
                                                                        .text;
                                                                param['carprnterothrs'] =
                                                                    carprnterothrs
                                                                        .text;
                                                                param['id'] =
                                                                    data['id'];
                                                                var resData =
                                                                    await apiService
                                                                        .postCall(
                                                                            'labour/editContractor',
                                                                            param);
                                                                if (resData[
                                                                        'success'] ==
                                                                    0) {
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors.red,
                                                                  );
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              }
                                                            },
                                                            child: Text("Save"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            size: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            onTap:
                                            () async {
                                              // var data = Map<String, dynamic>();
                                              // data['name'] = addcontactorname.text;
                                              // data['user_id'] = userid.toString();
                                              var resData =
                                                  await apiService.getcall(
                                                'labour/deleteContractorReport/${data['id']}',
                                              );
                                              if (resData['sucess'] == 1) {
                                                ToastMsg(
                                                  resData['message'],
                                                  15,
                                                  Colors.green,
                                                );
                                              }
                                            };
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
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
