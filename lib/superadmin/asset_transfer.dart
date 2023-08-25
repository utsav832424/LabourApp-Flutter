import 'dart:developer';

import 'package:abc_2_1/admin/fromto.dart';
import 'package:abc_2_1/admin/receivedto.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/fromto.dart';
import 'package:abc_2_1/superadmin/receivedto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SAsset_Transfer extends StatefulWidget {
  SAsset_Transfer({Key? key}) : super(key: key);

  @override
  State<SAsset_Transfer> createState() => _SAsset_TransferState();
}

class _SAsset_TransferState extends State<SAsset_Transfer>
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
  var fulldaytotal = 0;
  var othrs = 0;
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
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      init();
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
      "assetTransfer/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&type=${_selectedIndex + 1}",
    );
    log("${resData}");
    if (mounted) {
      setState(() {
        labour = resData['data'];
        loader = false;
      });
    }
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "labour/group?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
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
          length: 2,
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
                                      "Asset transfer",
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
                                      onTap: _selDatePicker,
                                      controller: txtController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
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
                                      // decoration:
                                      //     InputDecoration(labelText: 'Selected Date'),
                                      onTap: _selDatePicker2,
                                      controller: txtController2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(top: 20, right: 20),
                            //   child: Row(
                            //     children: [
                            //       Image.asset(
                            //         "assets/pdf.png",
                            //         height: 40,
                            //       ),
                            //       SizedBox(
                            //         width: 20,
                            //       ),
                            //       Image.asset(
                            //         "assets/exel.png",
                            //         height: 40,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TabBar(
                          controller: _controller,
                          labelColor: Colors.black,
                          isScrollable: true,
                          indicatorColor: Colors.black,
                          tabs: [
                            GestureDetector(
                              child: Container(
                                child: Tab(text: "From To"),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                child: Tab(text: "Received To"),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              SFromto(
                                data: labour,
                                type: 1,
                                refresh: (filters) {
                                  if (filters['refresh']) {
                                    init();
                                  }
                                },
                              ),
                              SReceivedto(
                                refresh: (filters) {
                                  if (filters['refresh']) {
                                    init();
                                  }
                                },
                                data: labour,
                                type: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
            ),
          ),
        );
      } else {
        return DefaultTabController(
          length: 2,
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
                                        "Asset transfer",
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
                            // Container(
                            //   margin: EdgeInsets.only(top: 20, right: 20),
                            //   child: Row(
                            //     children: [
                            //       Image.asset(
                            //         "assets/pdf.png",
                            //         height: 40,
                            //       ),
                            //       SizedBox(
                            //         width: 20,
                            //       ),
                            //       Image.asset(
                            //         "assets/exel.png",
                            //         height: 40,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TabBar(
                          controller: _controller,
                          labelColor: Colors.black,
                          isScrollable: true,
                          indicatorColor: Colors.black,
                          tabs: [
                            GestureDetector(
                              child: Container(
                                child: Tab(text: "In Coming"),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                child: Tab(text: "Out Going"),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              SFromto(
                                data: labour,
                                type: 1,
                                refresh: (filters) {
                                  if (filters['refresh']) {
                                    init();
                                  }
                                },
                              ),
                              SReceivedto(
                                refresh: (filters) {
                                  if (filters['refresh']) {
                                    init();
                                  }
                                },
                                data: labour,
                                type: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
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
