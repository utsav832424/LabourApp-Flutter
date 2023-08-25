import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/carpenter.dart';
import 'package:abc_2_1/superadmin/helper.dart';
import 'package:abc_2_1/superadmin/labour.dart';
import 'package:abc_2_1/superadmin/mason.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SLabour_Report extends StatefulWidget {
  SLabour_Report({Key? key}) : super(key: key);

  @override
  State<SLabour_Report> createState() => _SLabour_ReportState();
}

class _SLabour_ReportState extends State<SLabour_Report>
    with TickerProviderStateMixin {
  final txtController = TextEditingController();
  late TabController _controller;
  int _selectedIndex = 0;
  var type = 1;
  var editcontractornameid = 0;
  var contractornameid = 0;
  final loginForm = GlobalKey<FormState>();
  late TextEditingController fromDateController;
  DateTime fromSelectedDate = DateTime.now();

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
  TextEditingController editcontactorname = TextEditingController();

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  var fulldaytotal;
  var othrs = 0.0;
  late List labour = [];
  var total = {};
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
        if (_selectedIndex == 0) {
          fulldaytotal = total['totallabourfullday'];
          othrs = total['totallabourothrs'];
        }
        if (_selectedIndex == 1) {
          fulldaytotal = total['totalmasonfullday'];
          othrs = total['totalmasonothrs'];
        }
        if (_selectedIndex == 2) {
          fulldaytotal = total['totalcarpenterfullday'];
          othrs = total['totalcarprnterothrs'];
        }
        if (_selectedIndex == 3) {
          fulldaytotal = total['totalhelperfullday'];
          othrs = total['totalhelperothrs'];
        }
      });
      print("Selected Index: " + _controller.index.toString());
    });
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
      "labour/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20",
    );
    log("${resData}");
    if (mounted) {
      setState(() {
        labour = resData['data']['data'];
        total = resData['data']['total'];
        // log('${total['totallabourothrs']}');
        fulldaytotal = total['totallabourfullday'];
        othrs = total['totallabourothrs'];
        loader = false;
      });
    }
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "labour?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
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
        init();
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
        txtController3.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _productDataSource;
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return DefaultTabController(
          length: 4,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    child: Column(
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
                                      "Labour Report",
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
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              SLabour(
                                data: labour,
                                type: 1,
                                action: 0,
                                refresh: ((filters) {
                                  if (filters['reload']) {
                                    init();
                                  }
                                }),
                              ),
                              SMason(
                                data: labour,
                                type: 1,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                              SCarpenter(
                                data: labour,
                                type: 1,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                              SHelper(
                                data: labour,
                                type: 1,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userType == 1)
                    Positioned(
                      bottom: 50,
                      left: 100,
                      child: TextButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Add Contactor Name'),
                                actions: <Widget>[
                                  Column(
                                    children: [
                                      TextFormField(
                                        controller: addcontactorname,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter contractorname";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter a contractorname',
                                          labelText: 'Enter Name',
                                        ),
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
                                                  if (addcontactorname
                                                      .text.isEmpty) {
                                                    ToastMsg(
                                                      "Please enter contractorname",
                                                      15,
                                                      Colors.red,
                                                    );
                                                  } else {
                                                    var data =
                                                        Map<String, dynamic>();
                                                    data['name'] =
                                                        addcontactorname.text;
                                                    data['user_id'] =
                                                        userid.toString();
                                                    var resData =
                                                        await apiService.postCall(
                                                            'labour/addContractor',
                                                            data);
                                                    if (resData['success'] ==
                                                        0) {
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
                                                child: Text("Save"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green[100],
                                                  onPrimary: Colors.blue[900],
                                                ),
                                                onPressed: () async {
                                                  var resData =
                                                      await apiService.getcall(
                                                          "labour/getContractor");
                                                  Navigator.pop(context);
                                                  showDialog<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Contactor Name List'),
                                                        actions: <Widget>[
                                                          Container(
                                                            height: 350,
                                                            child: ListView(
                                                              children: [
                                                                for (var item
                                                                    in resData[
                                                                        'data'])
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 15,
                                                                                left: 10,
                                                                                bottom: 10),
                                                                            child:
                                                                                Text(
                                                                              "${item['name']}",
                                                                              style: TextStyle(
                                                                                fontFamily: "Century Gothic",
                                                                                // fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    editcontractornameid = item['id'];
                                                                                    editcontactorname.text = item['name'];
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          title: const Text('Edit Contactor Name'),
                                                                                          actions: <Widget>[
                                                                                            Column(
                                                                                              children: [
                                                                                                TextFormField(
                                                                                                  controller: editcontactorname,
                                                                                                  validator: (value) {
                                                                                                    if (value == null || value.isEmpty) {
                                                                                                      return "Please enter contractorname";
                                                                                                    }
                                                                                                    return null;
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    border: OutlineInputBorder(),
                                                                                                    hintText: 'Enter a contractorname',
                                                                                                    labelText: 'Enter Name',
                                                                                                  ),
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
                                                                                                            if (editcontactorname.text.isEmpty) {
                                                                                                              ToastMsg(
                                                                                                                "Please enter contractorname",
                                                                                                                15,
                                                                                                                Colors.red,
                                                                                                              );
                                                                                                            } else {
                                                                                                              var data = Map<String, dynamic>();
                                                                                                              data['name'] = editcontactorname.text;
                                                                                                              data['id'] = editcontractornameid.toString();
                                                                                                              var resData = await apiService.postCall('labour/editContractorName', data);
                                                                                                              if (resData['success'] == 0) {
                                                                                                                ToastMsg(
                                                                                                                  resData['message'],
                                                                                                                  15,
                                                                                                                  Colors.red,
                                                                                                                );
                                                                                                              } else {
                                                                                                                Navigator.pop(context);
                                                                                                                Navigator.pop(context);
                                                                                                              }
                                                                                                            }
                                                                                                          },
                                                                                                          child: Text("Save"),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      width: 10,
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
                                                                                  child: Icon(
                                                                                    Icons.edit,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                Container(
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      var data = Map<String, dynamic>();
                                                                                      data['id'] = item['id'];
                                                                                      var resData = await apiService.postCall('labour/deleteContractorName', data);
                                                                                      if (resData['success'] == 1) {
                                                                                        Navigator.pop(context);
                                                                                        ToastMsg(
                                                                                          "${resData['message']}",
                                                                                          15,
                                                                                          Colors.green,
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.delete,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  "View",
                                                ),
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
                                "Contractor Name",
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
                  // if (userType == 1)

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
          ),
        );
      } else {
        return DefaultTabController(
          length: 4,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    child: Column(
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
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 20),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            "Labour Report",
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
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              SLabour(
                                data: labour,
                                type: 1,
                                action: 0,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                              SMason(
                                data: labour,
                                type: 1,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                              SCarpenter(
                                data: labour,
                                type: 1,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                              SHelper(
                                data: labour,
                                type: 1,
                                refresh: ((filters) {
                                  init();
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userType == 1)
                    Positioned(
                      bottom: 50,
                      left: 100,
                      child: TextButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Add Contactor Name'),
                                actions: <Widget>[
                                  Column(
                                    children: [
                                      TextFormField(
                                        controller: addcontactorname,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter contractorname";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter a contractorname',
                                          labelText: 'Enter Name',
                                        ),
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
                                                  if (addcontactorname
                                                      .text.isEmpty) {
                                                    ToastMsg(
                                                      "Please enter contractorname",
                                                      15,
                                                      Colors.red,
                                                    );
                                                  } else {
                                                    var data =
                                                        Map<String, dynamic>();
                                                    data['name'] =
                                                        addcontactorname.text;
                                                    data['user_id'] =
                                                        userid.toString();
                                                    var resData =
                                                        await apiService.postCall(
                                                            'labour/addContractor',
                                                            data);
                                                    if (resData['success'] ==
                                                        0) {
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
                                                child: Text("Save"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green[100],
                                                  onPrimary: Colors.blue[900],
                                                ),
                                                onPressed: () async {
                                                  var resData =
                                                      await apiService.getcall(
                                                          "labour/getContractor");

                                                  Navigator.pop(context);
                                                  showDialog<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Contactor Name List'),
                                                        actions: <Widget>[
                                                          Container(
                                                            height: 350,
                                                            child: Column(
                                                              children: [
                                                                for (var item
                                                                    in resData[
                                                                        'data'])
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(
                                                                                top: 15,
                                                                                left: 10,
                                                                                bottom: 10),
                                                                            child:
                                                                                Text(
                                                                              "${item['name']}",
                                                                              style: TextStyle(
                                                                                fontFamily: "Century Gothic",
                                                                                // fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    editcontractornameid = item['id'];
                                                                                    editcontactorname.text = item['name'];
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          title: const Text('Edit Contactor Name'),
                                                                                          actions: <Widget>[
                                                                                            Column(
                                                                                              children: [
                                                                                                TextFormField(
                                                                                                  controller: editcontactorname,
                                                                                                  validator: (value) {
                                                                                                    if (value == null || value.isEmpty) {
                                                                                                      return "Please enter contractorname";
                                                                                                    }
                                                                                                    return null;
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    border: OutlineInputBorder(),
                                                                                                    hintText: 'Enter a contractorname',
                                                                                                    labelText: 'Enter Name',
                                                                                                  ),
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
                                                                                                            if (editcontactorname.text.isEmpty) {
                                                                                                              ToastMsg(
                                                                                                                "Please enter contractorname",
                                                                                                                15,
                                                                                                                Colors.red,
                                                                                                              );
                                                                                                            } else {
                                                                                                              var data = Map<String, dynamic>();
                                                                                                              data['name'] = editcontactorname.text;
                                                                                                              data['id'] = editcontractornameid.toString();
                                                                                                              var resData = await apiService.postCall('labour/editContractorName', data);
                                                                                                              if (resData['success'] == 0) {
                                                                                                                ToastMsg(
                                                                                                                  resData['message'],
                                                                                                                  15,
                                                                                                                  Colors.red,
                                                                                                                );
                                                                                                              } else {
                                                                                                                Navigator.pop(context);
                                                                                                                Navigator.pop(context);
                                                                                                              }
                                                                                                            }
                                                                                                          },
                                                                                                          child: Text("Save"),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      width: 10,
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
                                                                                  child: Icon(
                                                                                    Icons.edit,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                Container(
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      var data = Map<String, dynamic>();
                                                                                      data['id'] = item['id'];
                                                                                      var resData = await apiService.postCall('labour/deleteContractorName', data);
                                                                                      if (resData['success'] == 1) {
                                                                                        Navigator.pop(context);
                                                                                        ToastMsg(
                                                                                          "${resData['message']}",
                                                                                          15,
                                                                                          Colors.green,
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.delete,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  "View",
                                                ),
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
                                "Contractor Name",
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
                  if (userType == 1)
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
                                  minChildSize: 0.5,
                                  maxChildSize: 0.9,
                                  builder: (_, controller) => StatefulBuilder(
                                      builder:
                                          (BuildContext context, setstate) {
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Date",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                        ),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a Date',
                                                          ),
                                                          onTap:
                                                              _selDatePicker3,
                                                          controller:
                                                              txtController3,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Contractor Name",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                        ),
                                                        child:
                                                            TypeAheadFormField(
                                                          textFieldConfiguration:
                                                              TextFieldConfiguration(
                                                            controller:
                                                                contractorname,
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
                                                            var data = Map<
                                                                String,
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
                                                                suggestion[
                                                                    'id'];
                                                            contractorname
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
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Labour",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 8,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  labourfullday,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter labourfullday";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'labourfullday',
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 6,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  labourothrs,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter labourothrs";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'labourothrs',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Mason",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 8,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  masonfullday,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter masonfullday";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'masonfullday',
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 6,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  masonothrs,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter masonothrs";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'masonothrs',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Carpenter",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 8,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  carpenterfullday,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter carpenterfullday";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'carpenterfullday',
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 6,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  carprnterothrs,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter carprnterothrs";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'carprnterothrs',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Helper",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 8,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  helperfullday,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter helperfullday";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'helperfullday',
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 165,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 6,
                                                              right: 6,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  helperothrs,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter helperothrs";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'helperothrs',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
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
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.green,
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
                                                                      data['contractorname'] =
                                                                          contractornameid;
                                                                      data['labourfullday'] =
                                                                          labourfullday
                                                                              .text;
                                                                      data['labourothrs'] =
                                                                          labourothrs
                                                                              .text;
                                                                      data['masonfullday'] =
                                                                          masonfullday
                                                                              .text;
                                                                      data['masonothrs'] =
                                                                          masonothrs
                                                                              .text;
                                                                      data['carpenterfullday'] =
                                                                          carpenterfullday
                                                                              .text;
                                                                      data['carprnterothrs'] =
                                                                          carprnterothrs
                                                                              .text;
                                                                      data['helperfullday'] =
                                                                          helperfullday
                                                                              .text;
                                                                      data['helperothrs'] =
                                                                          helperothrs
                                                                              .text;
                                                                      data['date'] =
                                                                          txtController3
                                                                              .text;

                                                                      data['user_id'] =
                                                                          userid
                                                                              .toString();
                                                                      data['isactive'] =
                                                                          "1";

                                                                      print(
                                                                          data);
                                                                      var login = await apiService.postCall(
                                                                          'labour',
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
                                                                              login['message'];
                                                                        });
                                                                      } else {
                                                                        ToastMsg(
                                                                          login[
                                                                              'message'],
                                                                          15,
                                                                          Colors
                                                                              .green,
                                                                        );
                                                                        contractorname.text =
                                                                            '';
                                                                        labourfullday.text =
                                                                            '';
                                                                        labourothrs.text =
                                                                            '';
                                                                        masonfullday.text =
                                                                            '';
                                                                        masonothrs.text =
                                                                            '';
                                                                        carpenterfullday.text =
                                                                            '';
                                                                        carprnterothrs.text =
                                                                            '';
                                                                        helperfullday.text =
                                                                            '';
                                                                        helperothrs.text =
                                                                            '';

                                                                        Navigator.pop(
                                                                            context);
                                                                        init();
                                                                      }
                                                                    }
                                                                  },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 30,
                                                                      left: 30,
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              child: Text(
                                                                "Save",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.red,
                                                              onPrimary:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 30,
                                                                      left: 30,
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              child: Text(
                                                                "Close",
                                                              ),
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
