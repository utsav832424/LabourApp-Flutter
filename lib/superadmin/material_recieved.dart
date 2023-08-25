import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/material_recieved_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SMaterial_recieved extends StatefulWidget {
  SMaterial_recieved({Key? key}) : super(key: key);

  @override
  State<SMaterial_recieved> createState() => _SMaterial_recievedState();
}

class _SMaterial_recievedState extends State<SMaterial_recieved> {
  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();

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
        // txtController.text = DateFormat.yMd().format(picke dDate);
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  TextEditingController suppliername = TextEditingController();
  TextEditingController material = TextEditingController();
  TextEditingController vehicle_no = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController challan_no = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController editmaterial = TextEditingController();
  TextEditingController editvehiclenumber = TextEditingController();
  TextEditingController editchallanno = TextEditingController();
  TextEditingController editqtyltr = TextEditingController();
  TextEditingController editunit = TextEditingController();

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
        init();
      });
    });
  }

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List materials = [];
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
    var resData = await apiService.getcall(
        "materials/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
    log("${resData}");
    if (mounted) {
      setState(() {
        materials = resData['data'];
        loader = false;
      });
    }
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
        txtController3.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "materials/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Icon(
                                Icons.arrow_back,
                              ),
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
                                  "Material Recieved",
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       margin: EdgeInsets.only(top: 20, left: 20),
                    //       child: Column(
                    //         children: [
                    //           Text(
                    //             "From :",
                    //             style: TextStyle(
                    //               fontFamily: "Century Gothic",
                    //               color: Colors.blue[900],
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 18,
                    //             ),
                    //           ),
                    //           Container(
                    //             width: 100,
                    //             child: TextFormField(
                    //               readOnly: true,
                    //               onTap: _selDatePicker,
                    //               controller: txtController,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(top: 20),
                    //       child: Column(
                    //         children: [
                    //           Text(
                    //             "To Date:",
                    //             style: TextStyle(
                    //                 fontFamily: "Century Gothic",
                    //                 color: Colors.blue[900],
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 18),
                    //           ),
                    //           Container(
                    //             width: 100,
                    //             child: TextFormField(
                    //               readOnly: true,
                    //               // decoration:
                    //               //     InputDecoration(labelText: 'Selected Date'),
                    //               onTap: _selDatePicker2,
                    //               controller: txtController2,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(top: 20, right: 20),
                    //       child: Row(
                    //         children: [
                    //           Image.asset(
                    //             "assets/pdf.png",
                    //             height: 40,
                    //           ),
                    //           SizedBox(
                    //             width: 20,
                    //           ),
                    //           Image.asset(
                    //             "assets/exel.png",
                    //             height: 40,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Expanded(
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
                                    "Admin",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Century Gothic",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          for (var data in materials)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Smaterial_recieved_detail(
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
                                            fontSize: 16,
                                            fontFamily: "Century Gothic",
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
                                    "Material Recieved",
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.only(top: 20, left: 20),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "From Date:",
                    //               style: TextStyle(
                    //                 fontFamily: "Century Gothic",
                    //                 color: Colors.blue[900],
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 18,
                    //               ),
                    //             ),
                    //             Container(
                    //               // width: 100,
                    //               child: TextFormField(
                    //                 readOnly: true,
                    //                 onTap: _selDatePicker,
                    //                 controller: txtController,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 25,
                    //     ),
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.only(top: 20),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "To Date:",
                    //               style: TextStyle(
                    //                   fontFamily: "Century Gothic",
                    //                   color: Colors.blue[900],
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 18),
                    //             ),
                    //             Container(
                    //               // width: 100,
                    //               child: TextFormField(
                    //                 readOnly: true,
                    //                 // decoration:
                    //                 //     InputDecoration(labelText: 'Selected Date'),
                    //                 onTap: _selDatePicker2,
                    //                 controller: txtController2,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(top: 20, right: 20),
                    //       child: Row(
                    //         children: [
                    //           Image.asset(
                    //             "assets/pdf.png",
                    //             height: 40,
                    //           ),
                    //           SizedBox(
                    //             width: 20,
                    //           ),
                    //           Image.asset(
                    //             "assets/exel.png",
                    //             height: 40,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Expanded(
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
                                    "Admin",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Century Gothic",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          for (var data in materials)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Smaterial_recieved_detail(
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
                                            fontSize: 16,
                                            fontFamily: "Century Gothic",
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
