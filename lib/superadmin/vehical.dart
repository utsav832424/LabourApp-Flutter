import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/service.dart';
import 'package:abc_2_1/superadmin/vehicaldetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SVehical extends StatefulWidget {
  const SVehical({super.key});

  @override
  State<SVehical> createState() => _SVehicalState();
}

class _SVehicalState extends State<SVehical> {
  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  TextEditingController date = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController insurance = TextEditingController();
  TextEditingController registration_date = TextEditingController();
  TextEditingController rc_book = TextEditingController();
  TextEditingController puc = TextEditingController();
  TextEditingController fitness = TextEditingController();
  TextEditingController form_10 = TextEditingController();
  TextEditingController cng_kit = TextEditingController();
  TextEditingController editinsurance = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController editregistrationdate = TextEditingController();
  TextEditingController editrcbook = TextEditingController();
  TextEditingController editpuc = TextEditingController();
  TextEditingController editfitness = TextEditingController();
  TextEditingController editform10 = TextEditingController();
  TextEditingController editcngkit = TextEditingController();

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
        "vihical/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
    log("${resData}");
    if (mounted) {
      setState(() {
        diesel = resData['data'];
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
        "diesel?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
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

  void _selDatePicker4() {
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
        registration_date.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  void _selDatePicker6() {
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
        editregistrationdate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  void _selDatePicker5() {
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
        date.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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
                                  "Vehical Report",
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
                          columnWidths: {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(4),
                            3: FlexColumnWidth(4),
                          },
                          defaultColumnWidth: FixedColumnWidth(
                            85,
                          ),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      "Name",
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
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 12,
                                          bottom: 5,
                                          right: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Vehicaldetail(
                                                  user_id: data['user_id'],
                                                  refresh: ((filters) {
                                                    init();
                                                  }),
                                                ),
                                              ));
                                        },
                                        child: Text(
                                          "${data['sitename']}",
                                          style: TextStyle(
                                              fontSize: 15,
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
                                    "Vehical Report",
                                    style: TextStyle(
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
                        child: Scrollbar(
                          child: Table(
                            border: TableBorder(
                                horizontalInside: BorderSide(
                              color: Colors.grey,
                            )),
                            columnWidths: {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(4),
                            },
                            defaultColumnWidth: FixedColumnWidth(
                              180,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
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
                                                      Vehicaldetail(
                                                    user_id: data['user_id'],
                                                    refresh: ((filters) {
                                                      init();
                                                    }),
                                                  ),
                                                ));
                                          },
                                          child: Text(
                                            "${data['sitename']}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
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
