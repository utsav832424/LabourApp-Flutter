import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SServiceVehical extends StatefulWidget {
  const SServiceVehical({super.key, required this.vehicalId});
  final vehicalId;

  @override
  State<SServiceVehical> createState() => _SServiceVehicalState();
}

class _SServiceVehicalState extends State<SServiceVehical> {
  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  TextEditingController date = TextEditingController();
  TextEditingController hours = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController next_service_hrs = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  TextEditingController edithours = TextEditingController();
  TextEditingController editdescription = TextEditingController();
  TextEditingController editnext_service_hrs = TextEditingController();

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

  void _selDatePicker7() {
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
        txtController1.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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
        "vihical/service?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&machinery_id=${widget.vehicalId}");
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
                        Expanded(
                          child: Container(
                            width: 300,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(left: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                        "Vehical Service Report",
                                        style: TextStyle(
                                          fontFamily: "Century Gothic",
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    init();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Column(
                            children: [
                              Text(
                                "From Date:",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: TextFormField(
                                  readOnly: true,
                                  // decoration:
                                  //     InputDecoration(labelText: 'Selected Date'),
                                  onTap: _selDatePicker,
                                  controller: txtController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text(
                                "To Date:",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Container(
                                width: 100,
                                child: TextFormField(
                                  readOnly: true,
                                  // decoration:
                                  //     InputDecoration(labelText: 'Selected Date'),
                                  onTap: _selDatePicker2,
                                  controller: txtController2,
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
                        child: Scrollbar(
                          child: ListView(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  border: TableBorder(
                                      horizontalInside: BorderSide(
                                    color: Colors.grey,
                                  )),
                                  defaultColumnWidth: FixedColumnWidth(
                                    100,
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 15, left: 10),
                                            child: Text(
                                              "Date",
                                              style: TextStyle(
                                                fontFamily: "Century Gothic",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 15, left: 10),
                                            child: Text(
                                              "Hours",
                                              style: TextStyle(
                                                fontFamily: "Century Gothic",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 15, right: 18),
                                            child: Text(
                                              "Description",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Century Gothic",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              "Next Service Hrs",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Century Gothic",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (userType == 2)
                                          TableCell(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 15),
                                              child: Text(
                                                "Action",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  left: 5,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['date']}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 12,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['hours']}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 25,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['description']}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 15, bottom: 5),
                                              child: Text(
                                                "${data['next_service_hrs']}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          if (userType == 2)
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 10,
                                                  bottom: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        log("${data}");
                                                        txtController1.text =
                                                            data['date'];
                                                        edithours.text =
                                                            data['hours'];
                                                        editdescription.text =
                                                            data['description'];

                                                        editnext_service_hrs
                                                                .text =
                                                            data[
                                                                'next_service_hrs'];

                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Service'),
                                                              actions: <Widget>[
                                                                Container(
                                                                  height: 300,
                                                                  child:
                                                                      ListView(
                                                                    children: [
                                                                      TextFormField(
                                                                        // readOnly: true,
                                                                        controller:
                                                                            txtController1,
                                                                        onTap:
                                                                            _selDatePicker7,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return "Please enter date";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          hintText:
                                                                              'Enter a date',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
                                                                        // readOnly: true,
                                                                        controller:
                                                                            edithours,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return "Please enter Hours";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          hintText:
                                                                              'Enter a Hours',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
                                                                        // readOnly: true,
                                                                        controller:
                                                                            editdescription,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return "Please enter description";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          hintText:
                                                                              'Enter a description',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
                                                                        // readOnly: true,
                                                                        controller:
                                                                            editnext_service_hrs,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return "Please enter Next hours";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          hintText:
                                                                              'Enter a Next hours',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                Colors.green[100],
                                                                            onPrimary:
                                                                                Colors.blue[900],
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            if (edithours.text.isEmpty) {
                                                                              ToastMsg(
                                                                                "Please enter insurance",
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              var param = Map<String, dynamic>();
                                                                              param['date'] = txtController1.text;
                                                                              param['hours'] = edithours.text;
                                                                              param['description'] = editdescription.text;
                                                                              param['next_service_hrs'] = editnext_service_hrs.text;

                                                                              param['id'] = data['id'];
                                                                              var resData = await apiService.postCall('vihical/editService', param);
                                                                              if (resData['success'] == 0) {
                                                                                ToastMsg(
                                                                                  resData['message'],
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text("Save"),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        // var data = Map<String, dynamic>();
                                                        // data['name'] = addcontactorname.text;
                                                        // data['user_id'] = userid.toString();
                                                        var resData =
                                                            await apiService
                                                                .getcall(
                                                          'vihical/services/delete/${data['id']}',
                                                        );
                                                        if (resData['sucess'] ==
                                                            1) {
                                                          ToastMsg(
                                                            resData['message'],
                                                            15,
                                                            Colors.green,
                                                          );
                                                          init();
                                                        }
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
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  bottom: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.7,
                              minChildSize: 0.3,
                              maxChildSize: 0.9,
                              builder: (_, controller) => StatefulBuilder(
                                  builder: (BuildContext context, setstate) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                    ),
                                  ),
                                  // height: 1000,

                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Form(
                                          key: loginForm,
                                          child: ListView(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Date",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker5,
                                                      controller: date,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Date";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Hours",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      controller: hours,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Hours";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Hours',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Description",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      controller: description,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Description";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Description',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Next Service Hrs",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      controller:
                                                          next_service_hrs,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Next Service Hrs";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Next Service Hrs  ',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                margin: EdgeInsets.only(
                                                  bottom: 10,
                                                  top: 15,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.green,
                                                          onPrimary:
                                                              Colors.white,
                                                        ),
                                                        onPressed: isLoad
                                                            ? null
                                                            : () async {
                                                                if (loginForm
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setState(
                                                                    () {
                                                                      isLoad =
                                                                          true;
                                                                    },
                                                                  );
                                                                  var data = Map<
                                                                      String,
                                                                      dynamic>();

                                                                  data['machinery_id'] =
                                                                      widget
                                                                          .vehicalId;
                                                                  data['date'] =
                                                                      date.text;
                                                                  data['hours'] =
                                                                      hours
                                                                          .text;
                                                                  data['description'] =
                                                                      description
                                                                          .text;
                                                                  data['next_service_hrs'] =
                                                                      next_service_hrs
                                                                          .text;
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'vihical/addService',
                                                                          data);
                                                                  setState(
                                                                    () {
                                                                      isLoad =
                                                                          false;
                                                                    },
                                                                  );
                                                                  if (login[
                                                                          'success'] ==
                                                                      0) {
                                                                    setState(
                                                                        () {
                                                                      ErrorMessage =
                                                                          login[
                                                                              'message'];
                                                                    });
                                                                  } else {
                                                                    ToastMsg(
                                                                      login[
                                                                          'message'],
                                                                      15,
                                                                      Colors
                                                                          .green,
                                                                    );
                                                                    date.text =
                                                                        '';
                                                                    hours.text =
                                                                        '';
                                                                    description
                                                                        .text = '';
                                                                    next_service_hrs
                                                                        .text = '';

                                                                    Navigator.pop(
                                                                        context);
                                                                    init();
                                                                  }
                                                                }
                                                              },
                                                        child: Text(
                                                          "Save",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.red,
                                                          onPrimary:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Close",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ),
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
                        Expanded(
                          child: Container(
                            // width: 300,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(left: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                        "Vehical Service Report",
                                        style: TextStyle(
                                          fontFamily: "Century Gothic",
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    init();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "From Date:",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  // width: 100,
                                  child: TextFormField(
                                    readOnly: true,
                                    onTap: _selDatePicker,
                                    controller: txtController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To Date:",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Container(
                                  // width: 100,
                                  child: TextFormField(
                                    readOnly: true,
                                    // decoration:
                                    //     InputDecoration(labelText: 'Selected Date'),
                                    onTap: _selDatePicker2,
                                    controller: txtController2,
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Table(
                              border: TableBorder(
                                  horizontalInside: BorderSide(
                                color: Colors.grey,
                              )),
                              defaultColumnWidth: FixedColumnWidth(
                                250,
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            fontFamily: "Century Gothic",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          "Hours",
                                          style: TextStyle(
                                            fontFamily: "Century Gothic",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 15, bottom: 15),
                                            child: Text(
                                              "Description",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Century Gothic",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          "Next Service Hrs",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Century Gothic",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (userType == 2)
                                      TableCell(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          child: Text(
                                            "Action",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
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
                                              left: 5,
                                              bottom: 5,
                                              right: 5),
                                          child: Text(
                                            "${data['date']}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Century Gothic",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              left: 12,
                                              bottom: 5,
                                              right: 5),
                                          child: Text(
                                            "${data['hours']}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Century Gothic",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              left: 90,
                                              bottom: 5,
                                              right: 5),
                                          child: Text(
                                            "${data['description']}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Century Gothic",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 90, bottom: 5),
                                          child: Text(
                                            "${data['next_service_hrs']}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Century Gothic",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      if (userType == 2)
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              left: 80,
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    txtController1.text =
                                                        data['date'];
                                                    edithours.text =
                                                        data['hours'];
                                                    editdescription.text =
                                                        data['description'];

                                                    editnext_service_hrs.text =
                                                        data[
                                                            'next_service_hrs'];

                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Edit Service'),
                                                          actions: <Widget>[
                                                            Column(
                                                              children: [
                                                                TextFormField(
                                                                  // readOnly: true,
                                                                  controller:
                                                                      txtController1,
                                                                  onTap:
                                                                      _selDatePicker7,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return "Please enter date";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    hintText:
                                                                        'Enter a date',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                TextFormField(
                                                                  // readOnly: true,
                                                                  controller:
                                                                      edithours,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return "Please enter Hours";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    hintText:
                                                                        'Enter a Hours',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                TextFormField(
                                                                  // readOnly: true,
                                                                  controller:
                                                                      editdescription,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return "Please enter description";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    hintText:
                                                                        'Enter a description',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                TextFormField(
                                                                  // readOnly: true,
                                                                  controller:
                                                                      editnext_service_hrs,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return "Please enter Next hours";
                                                                    }
                                                                    return null;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    hintText:
                                                                        'Enter a Next hours',
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
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .green[100],
                                                                      onPrimary:
                                                                          Colors
                                                                              .blue[900],
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      if (edithours
                                                                          .text
                                                                          .isEmpty) {
                                                                        ToastMsg(
                                                                          "Please enter insurance",
                                                                          15,
                                                                          Colors
                                                                              .red,
                                                                        );
                                                                      } else {
                                                                        var param = Map<
                                                                            String,
                                                                            dynamic>();
                                                                        param['date'] =
                                                                            txtController1.text;
                                                                        param['hours'] =
                                                                            edithours.text;
                                                                        param['description'] =
                                                                            editdescription.text;
                                                                        param['next_service_hrs'] =
                                                                            editnext_service_hrs.text;

                                                                        param['id'] =
                                                                            data['id'];
                                                                        var resData = await apiService.postCall(
                                                                            'vihical/editService',
                                                                            param);
                                                                        if (resData['success'] ==
                                                                            0) {
                                                                          ToastMsg(
                                                                            resData['message'],
                                                                            15,
                                                                            Colors.red,
                                                                          );
                                                                        } else {
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        "Save"),
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
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    // var data = Map<String, dynamic>();
                                                    // data['name'] = addcontactorname.text;
                                                    // data['user_id'] = userid.toString();
                                                    var resData =
                                                        await apiService
                                                            .getcall(
                                                      'vihical/services/delete/${data['id']}',
                                                    );
                                                    if (resData['sucess'] ==
                                                        1) {
                                                      ToastMsg(
                                                        resData['message'],
                                                        15,
                                                        Colors.green,
                                                      );
                                                      init();
                                                    }
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
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  bottom: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.7,
                              minChildSize: 0.3,
                              maxChildSize: 0.9,
                              builder: (_, controller) => StatefulBuilder(
                                  builder: (BuildContext context, setstate) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                    ),
                                  ),
                                  // height: 1000,

                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Form(
                                          key: loginForm,
                                          child: ListView(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Date",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker5,
                                                      controller: date,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Date";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Hours",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      controller: hours,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Hours";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Hours',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Description",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      controller: description,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Description";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Description',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Next Service Hrs",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: TextFormField(
                                                      controller:
                                                          next_service_hrs,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Next Service Hrs";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Next Service Hrs  ',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                margin: EdgeInsets.only(
                                                  bottom: 10,
                                                  top: 15,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.green,
                                                          onPrimary:
                                                              Colors.white,
                                                        ),
                                                        onPressed: isLoad
                                                            ? null
                                                            : () async {
                                                                if (loginForm
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setState(
                                                                    () {
                                                                      isLoad =
                                                                          true;
                                                                    },
                                                                  );
                                                                  var data = Map<
                                                                      String,
                                                                      dynamic>();

                                                                  data['machinery_id'] =
                                                                      widget
                                                                          .vehicalId;
                                                                  data['date'] =
                                                                      date.text;
                                                                  data['hours'] =
                                                                      hours
                                                                          .text;
                                                                  data['description'] =
                                                                      description
                                                                          .text;
                                                                  data['next_service_hrs'] =
                                                                      next_service_hrs
                                                                          .text;
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'vihical/addService',
                                                                          data);
                                                                  setState(
                                                                    () {
                                                                      isLoad =
                                                                          false;
                                                                    },
                                                                  );
                                                                  if (login[
                                                                          'success'] ==
                                                                      0) {
                                                                    setState(
                                                                        () {
                                                                      ErrorMessage =
                                                                          login[
                                                                              'message'];
                                                                    });
                                                                  } else {
                                                                    ToastMsg(
                                                                      login[
                                                                          'message'],
                                                                      15,
                                                                      Colors
                                                                          .green,
                                                                    );
                                                                    date.text =
                                                                        '';
                                                                    hours.text =
                                                                        '';
                                                                    description
                                                                        .text = '';
                                                                    next_service_hrs
                                                                        .text = '';

                                                                    Navigator.pop(
                                                                        context);
                                                                    init();
                                                                  }
                                                                }
                                                              },
                                                        child: Text(
                                                          "Save",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.red,
                                                          onPrimary:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Close",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
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
