// import 'dart:developer';

import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/contractordetail.dart';
import 'package:abc_2_1/superadmin/labourdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SLabour extends StatefulWidget {
  SLabour(
      {Key? key,
      this.contarator,
      this.user,
      required this.data,
      required this.type,
      required this.refresh,
      required this.action})
      : super(key: key);
  final data;
  final type;
  final action;
  final contarator;
  final user;
  final void Function(Map<String, dynamic> filters) refresh;

  @override
  State<SLabour> createState() => _SLabourState();
}

class _SLabourState extends State<SLabour> {
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
  TextEditingController editcontractorname = TextEditingController();
  TextEditingController editlabourfullday = TextEditingController();
  TextEditingController editlabourothrs = TextEditingController();

  bool loader = true;
  List data = [];
  List searchUSer = [];
  late ScrollController _scrollController;
  var contractornameid;
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
    token = prefs.getString('token').toString();
    userid = prefs.getInt('user_id')!.toInt();
    userType = prefs.getInt('type')!.toInt();
    setState(() {
      loader = true;
    });
  }

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

  // void _loadMore() async {
  //   var param = new Map<String, dynamic>();
  //   param['user_id'] = userid.toString();
  //   var resData = await apiService.getcall(
  //       "labour?from_date=${widget.fromdate}&to_date=${widget.todate}&offset=0&length=20");
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  columnWidths: widget.type == 1
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
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "${widget.type == 1 ? 'Admin' : 'CONTRACTOR NAME'}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 5, left: 10),
                              child: Text(
                                "DATE",
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
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "${widget.type == 1 ? 'ADMIN' : 'CONTRACTOR NAME'}",
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
                                  fontWeight: FontWeight.bold,
                                ),
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
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (widget.type == 2 && widget.action == 1)
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Action",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ]
                      ],
                    ),
                    for (var data in widget.data)
                      TableRow(children: [
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              onTap: widget.type == 1
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SContractorDetail(
                                            contractor_id: data['user_id'],
                                            tabindex: 0,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(11),
                                child: Text(
                                  "${widget.type == 1 ? data['sitename'] : data['contractorname']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${data['date']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              onTap: () {
                                if (widget.user == null)
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          Labourdetails(
                                        admin_id: data['user_id'],
                                        contractor_id:
                                            data['contractorname_id'],
                                      ),
                                    ),
                                  );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 5),
                                child: Text(
                                  "${widget.type == 1 ? data['sitename'] : data['contractorname']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${data['labourothrs']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          if (widget.type == 2 && widget.action == 1)
                            TableCell(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // editname.text = data['name'];
                                      editlabourfullday.text =
                                          data['labourfullday'].toString();
                                      editlabourothrs.text =
                                          data['labourothrs'].toString();
                                      editcontractorname.text =
                                          data['contractorname'];
                                      txtController.text = data['date'];
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Edit Labour'),
                                            actions: <Widget>[
                                              Container(
                                                // height: 200,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        readOnly: true,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Date',
                                                        ),
                                                        onTap: _selDatePicker,
                                                        controller:
                                                            txtController,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Date";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              editcontractorname,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  // borderRadius:
                                                                  //     BorderRadius.all(
                                                                  //   Radius.circular(30),
                                                                  // ),
                                                                  // borderSide:
                                                                  //     BorderSide.none,
                                                                  ),
                                                              hintStyle: TextStyle(color: Colors.black),
                                                              // filled: true,
                                                              // fillColor: Colors.white,
                                                              hintText: 'Enter Contactorname'),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) async {
                                                          var param = Map<
                                                              String,
                                                              dynamic>();
                                                          param['name'] =
                                                              pattern;
                                                          param['user_id'] =
                                                              data['user_id'];
                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'labour/searchContractorName',
                                                                  param);
                                                        },
                                                        itemBuilder: (context,
                                                            dynamic
                                                                suggestion) {
                                                          return ListTile(
                                                            leading: Icon(
                                                                Icons.person),
                                                            title: Text(
                                                                suggestion[
                                                                    'name']),
                                                          );
                                                        },
                                                        onSuggestionSelected:
                                                            (dynamic
                                                                suggestion) {
                                                          contractornameid =
                                                              suggestion['id'];
                                                          log("${contractornameid}");
                                                          editcontractorname
                                                                  .text =
                                                              suggestion[
                                                                  'name'];
                                                        },
                                                        validator: (value) {
                                                          if (value == "" ||
                                                              value == null ||
                                                              value.isEmpty) {
                                                            return "Code is required, Please enter code";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        // readOnly: true,
                                                        controller:
                                                            editlabourfullday,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Full Day";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Full Day',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        // readOnly: true,
                                                        controller:
                                                            editlabourothrs,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter labourothrs";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a labourothrs',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .green[100],
                                                            onPrimary: Colors
                                                                .blue[900],
                                                          ),
                                                          onPressed: () async {
                                                            var param = Map<
                                                                String,
                                                                dynamic>();
                                                            param['date'] =
                                                                txtController
                                                                    .text;
                                                            param['contractorname'] =
                                                                contractornameid;
                                                            param['labourfullday'] =
                                                                editlabourfullday
                                                                    .text;
                                                            param['labourothrs'] =
                                                                editlabourothrs
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
                                                            widget.refresh({
                                                              "reload": true
                                                            });
                                                          },
                                                          child: Text("Save"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                          return AlertDialog(
                                            actionsPadding: EdgeInsets.zero,
                                            titlePadding: EdgeInsets.zero,
                                            contentPadding: EdgeInsets.zero,
                                            title: Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Text(
                                                "Confirm Delete",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 20),
                                              ),
                                            ),
                                            content: Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          "are you sure you want to delete this?"),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            var resData =
                                                                await apiService
                                                                    .getcall(
                                                              'labour/deleteContractorReport/${data['id']}',
                                                            );
                                                            log("$resData");
                                                            Navigator.pop(
                                                                context);
                                                            if (resData[
                                                                    'sucess'] ==
                                                                1) {
                                                              ToastMsg(
                                                                resData[
                                                                    'message'],
                                                                15,
                                                                Colors.green,
                                                              );

                                                              widget.refresh({
                                                                "reload": true
                                                              });
                                                            } else {
                                                              ToastMsg(
                                                                resData[
                                                                    'message'],
                                                                15,
                                                                Colors.red,
                                                              );
                                                              widget.refresh({
                                                                "reload": true
                                                              });
                                                            }
                                                          },
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Century Gothic",
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ]
                      ]),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Table(
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
                        if (widget.type == 1) ...[
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Admin",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "DATE",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                "CONTRACTOR NAME",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          if (widget.type == 2 && widget.contarator != null)
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Action",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ]
                      ],
                    ),
                    for (var data in widget.data)
                      TableRow(children: [
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              onTap: widget.type == 1
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SContractorDetail(
                                            contractor_id: data['user_id'],
                                            tabindex: 0,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${widget.type == 1 ? data['sitename'] : data['contractorname']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${data['date']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              onTap: () {
                                if (widget.type == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SContractorDetail(
                                        contractor_id: data['user_id'],
                                        tabindex: 0,
                                      ),
                                    ),
                                  );
                                } else if (widget.type == 2 &&
                                    widget.contarator == null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SContractorDetail(
                                        user: data['contractorname_id'],
                                        contractor_id: data['user_id'],
                                        tabindex: 0,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${widget.type == 1 ? data['sitename'] : data['contractorname']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${data['labourfullday']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${data['labourothrs']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          if (widget.type == 2 && widget.contarator != null)
                            TableCell(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      log('user_id ${data['user_id']}');
                                      // editname.text = data['name'];
                                      editlabourfullday.text =
                                          data['labourfullday'].toString();
                                      editlabourothrs.text =
                                          data['labourothrs'].toString();
                                      editcontractorname.text =
                                          data['contractorname'];
                                      txtController.text = data['date'];
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Edit Labour'),
                                            actions: <Widget>[
                                              Container(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: TextFormField(
                                                          readOnly: true,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a Date',
                                                          ),
                                                          onTap: _selDatePicker,
                                                          controller:
                                                              txtController,
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
                                                        height: 10,
                                                      ),
                                                      /* TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              editcontractorname,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  // borderRadius:
                                                                  //     BorderRadius.all(
                                                                  //   Radius.circular(30),
                                                                  // ),
                                                                  // borderSide:
                                                                  //     BorderSide.none,
                                                                  ),
                                                              hintStyle: TextStyle(color: Colors.black),
                                                              // filled: true,
                                                              // fillColor: Colors.white,
                                                              hintText: 'Enter Contactorname'),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) async {
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['name'] =
                                                              pattern;
                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'labour/searchContractorName',
                                                                  data);
                                                        },
                                                        itemBuilder: (context,
                                                            dynamic
                                                                suggestion) {
                                                          return ListTile(
                                                            leading: Icon(
                                                                Icons.person),
                                                            title: Text(
                                                                suggestion[
                                                                    'name']),
                                                          );
                                                        },
                                                        onSuggestionSelected:
                                                            (dynamic
                                                                suggestion) {
                                                          contractornameid =
                                                              suggestion['id'];
                                                          editcontractorname
                                                                  .text =
                                                              suggestion[
                                                                  'name'];
                                                        },
                                                        validator: (value) {
                                                          if (value == "" ||
                                                              value == null ||
                                                              value.isEmpty) {
                                                            return "Code is required, Please enter code";
                                                          }
                                                          return null;
                                                        },
                                                      ), */
                                                      Container(
                                                        child: Autocomplete<
                                                            String>(
                                                          fieldViewBuilder: (context,
                                                              textEditingController,
                                                              focusNode,
                                                              onEditingComplete) {
                                                            textEditingController
                                                                    .text =
                                                                data[
                                                                    'contractorname'];
                                                            return TextFormField(
                                                              controller:
                                                                  textEditingController,
                                                              focusNode:
                                                                  focusNode,
                                                              onEditingComplete:
                                                                  onEditingComplete,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'Enter a Name',
                                                              ),
                                                            );
                                                          },
                                                          optionsBuilder:
                                                              (TextEditingValue
                                                                  textEditingValue) async {
                                                            if (textEditingValue
                                                                    .text ==
                                                                '') {
                                                              return const Iterable<
                                                                  String>.empty();
                                                            } else {
                                                              List<String>
                                                                  serachdata =
                                                                  [];
                                                              var param = Map<
                                                                  String,
                                                                  dynamic>();
                                                              param['name'] =
                                                                  textEditingValue
                                                                      .text;
                                                              param['user_id'] =
                                                                  data[
                                                                      'user_id'];
                                                              var resdata =
                                                                  await apiService
                                                                      .getUserSuggestion(
                                                                          'labour/searchContractorName',
                                                                          param);
                                                              log('popopopopo${resdata}');
                                                              searchUSer =
                                                                  resdata;
                                                              for (var data
                                                                  in resdata) {
                                                                serachdata.add(
                                                                    data[
                                                                        'name']);
                                                              }
                                                              serachdata
                                                                  .retainWhere(
                                                                      (s) {
                                                                return s
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        textEditingValue
                                                                            .text
                                                                            .toLowerCase());
                                                              });
                                                              return serachdata;
                                                            }
                                                          },
                                                          onSelected: (dynamic
                                                              suggestion) {
                                                            log('You just selected $suggestion');
                                                            var getid;
                                                            getid = searchUSer
                                                                .where((x) => x[
                                                                        'name']
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        suggestion
                                                                            .toLowerCase()))
                                                                .toList();
                                                            log("getid ${getid}");
                                                            for (var item
                                                                in getid) {
                                                              if (item[
                                                                      'name'] ==
                                                                  suggestion) {
                                                                contractornameid =
                                                                    item['id'];
                                                              }
                                                            }
                                                            log('id : ${contractornameid}');
                                                            contractorname
                                                                    .text =
                                                                suggestion;
                                                            log("Supplier ${contractorname.text}");
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        // readOnly: true,
                                                        controller:
                                                            editlabourfullday,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Full Day";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Full Day',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        // readOnly: true,
                                                        controller:
                                                            editlabourothrs,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter labourothrs";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a labourothrs',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Colors
                                                                .green[100],
                                                            onPrimary: Colors
                                                                .blue[900],
                                                          ),
                                                          onPressed: () async {
                                                            init();
                                                            var param = Map<
                                                                String,
                                                                dynamic>();
                                                            param['date'] =
                                                                txtController
                                                                    .text;
                                                            param['contractorname'] =
                                                                contractornameid;
                                                            param['labourfullday'] =
                                                                editlabourfullday
                                                                    .text;
                                                            param['labourothrs'] =
                                                                editlabourothrs
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
                                                            widget.refresh({
                                                              "reload": true
                                                            });
                                                          },
                                                          child: Text("Save"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                          return AlertDialog(
                                            actionsPadding: EdgeInsets.zero,
                                            titlePadding: EdgeInsets.zero,
                                            contentPadding: EdgeInsets.zero,
                                            title: Container(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Text(
                                                  "Confirm Delete",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 20),
                                                )),
                                            content: Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                          "are you sure you want to delete this?"),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Cancel")),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              init();
                                                              var resData =
                                                                  await apiService
                                                                      .getcall(
                                                                'labour/deleteContractorReport/${data['id']}',
                                                              );
                                                              log("$resData");
                                                              Navigator.pop(
                                                                  context);
                                                              if (resData[
                                                                      'sucess'] ==
                                                                  1) {
                                                                ToastMsg(
                                                                  resData[
                                                                      'message'],
                                                                  15,
                                                                  Colors.green,
                                                                );

                                                                widget.refresh({
                                                                  "reload": true
                                                                });
                                                              } else {
                                                                ToastMsg(
                                                                  resData[
                                                                      'message'],
                                                                  15,
                                                                  Colors.red,
                                                                );
                                                                widget.refresh({
                                                                  "reload": true
                                                                });
                                                              }
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Century Gothic",
                                                                  color: Colors
                                                                      .red),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ]
                      ]),
                  ],
                ),
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
