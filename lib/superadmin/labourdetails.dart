import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/carpenter.dart';
import 'package:abc_2_1/superadmin/helper.dart';
import 'package:abc_2_1/superadmin/labour.dart';
import 'package:abc_2_1/superadmin/mason.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Labourdetails extends StatefulWidget {
  Labourdetails({Key? key, required this.admin_id, required this.contractor_id})
      : super(key: key);
  final admin_id;
  final contractor_id;

  @override
  State<Labourdetails> createState() => _LabourdetailsState();
}

class _LabourdetailsState extends State<Labourdetails>
    with TickerProviderStateMixin {
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
        // init();
      });
    });
  }

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
        // txtController.text = DateFormat.yMd().format(pickedDate);
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  Future openFile({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);

    if (file == null) return;

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final res = await Dio().get(url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ));

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(res.data);
    await raf.close();

    return file;
  }

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
  late TabController _controller;
  int _selectedIndex = 0;
  final loginForm = GlobalKey<FormState>();
  late TextEditingController fromDateController;
  DateTime fromSelectedDate = DateTime.now();
  bool isExportPdfLoader = false;

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

    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
      // "labour/getContractorWise?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${widget.contractor_id}",
      "labour/getContractorWise?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&contractor_id=${widget.contractor_id}&user_id=${widget.admin_id}",
    );
    log("${resData}");
    if (mounted) {
      setState(() {
        labour = resData['data']['data'];
        total = resData['data']['total'];
        fulldaytotal = total['totallabourfullday'];
        othrs = total['totallabourothrs'];
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Column(
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
                                          "Contract Name",
                                          style: TextStyle(
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
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Column(
                              children: [
                                Text(
                                  "From Date:",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: "Century Gothic",
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
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text(
                                  "To Date:",
                                  style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Century Gothic",
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
                          Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: isExportPdfLoader
                                      ? null
                                      : () async {
                                          var query = '';
                                          query +=
                                              'user_id=${widget.admin_id.toString()}';
                                          // from_date=${txtController.text}&to_date=${txtController2.text}
                                          if (txtController.text != '') {
                                            query +=
                                                '&from_date=${txtController.text}';
                                          }

                                          if (txtController2.text != '') {
                                            query +=
                                                '&to_date=${txtController2.text}';
                                          }
                                          query +=
                                              '&contractor_id=${widget.contractor_id}';
                                          log('query $query');
                                          setState(() {
                                            isExportPdfLoader = true;
                                          });
                                          var resData = await apiService.getCall(
                                              'http://89.116.229.150:3003/api/labour/getContractorWise/downloadGetAllPdf?' +
                                                  query);

                                          setState(() {
                                            isExportPdfLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                    'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'labour${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
                                          } else {
                                            ToastMsg(
                                              resData['message'],
                                              15,
                                              Colors.red,
                                            );
                                          }
                                        },
                                  child: Image.asset(
                                    "assets/pdf.png",
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: isExportPdfLoader
                                      ? null
                                      : () async {
                                          var query = '';
                                          query +=
                                              'user_id=${widget.admin_id.toString()}';
                                          // from_date=${txtController.text}&to_date=${txtController2.text}
                                          if (txtController.text != '') {
                                            query +=
                                                '&from_date=${txtController.text}';
                                          }

                                          if (txtController2.text != '') {
                                            query +=
                                                '&to_date=${txtController2.text}';
                                          }
                                          query +=
                                              '&contractor_id=${widget.contractor_id}';
                                          log('query $query');
                                          setState(() {
                                            isExportPdfLoader = true;
                                          });
                                          var resData = await apiService.getCall(
                                              'http://89.116.229.150:3003/api/labour/getContractorWise/downloadGetAllExcel?' +
                                                  query);

                                          setState(() {
                                            isExportPdfLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                    'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'labour${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
                                          } else {
                                            ToastMsg(
                                              resData['message'],
                                              15,
                                              Colors.red,
                                            );
                                          }
                                        },
                                  child: Image.asset(
                                    "assets/exel.png",
                                    height: 40,
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
                      TabBar(
                        controller: _controller,
                        labelColor: Colors.black,
                        isScrollable: true,
                        indicatorColor: Colors.black,
                        tabs: [
                          Container(
                            child: Tab(text: "LABOUR"),
                          ),
                          Container(
                            child: Tab(text: "MASON"),
                          ),
                          Container(
                            child: Tab(text: "CARPENTER"),
                          ),
                          Container(
                            child: Tab(text: "HELPER"),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _controller,
                          children: [
                            SLabour(
                              data: labour,
                              type: 2,
                              action: 1,
                              user: widget.contractor_id,
                              refresh: ((filters) {
                                init();
                              }),
                            ),
                            SMason(
                              data: labour,
                              type: 2,
                              action: 1,
                              refresh: ((filters) {
                                init();
                              }),
                            ),
                            SCarpenter(
                              data: labour,
                              type: 2,
                              action: 1,
                              refresh: ((filters) {
                                init();
                              }),
                            ),
                            SHelper(
                              data: labour,
                              type: 2,
                              action: 1,
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text("Total"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${fulldaytotal}",
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Container(
                                    child: Text(
                                      "${othrs / 8}",
                                      style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                Positioned(
                  child: Column(
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
                                          "Contract Name",
                                          style: TextStyle(
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
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Column(
                              children: [
                                Text(
                                  "From Date:",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: "Century Gothic",
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
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text(
                                  "To Date:",
                                  style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Century Gothic",
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
                          Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: isExportPdfLoader
                                      ? null
                                      : () async {
                                          var query = '';
                                          query +=
                                              'user_id=${widget.admin_id.toString()}';
                                          // from_date=${txtController.text}&to_date=${txtController2.text}
                                          if (txtController.text != '') {
                                            query +=
                                                '&from_date=${txtController.text}';
                                          }

                                          if (txtController2.text != '') {
                                            query +=
                                                '&to_date=${txtController2.text}';
                                          }
                                          query +=
                                              '&contractor_id=${widget.contractor_id}';
                                          log('query $query');
                                          setState(() {
                                            isExportPdfLoader = true;
                                          });
                                          var resData = await apiService.getCall(
                                              'http://89.116.229.150:3003/api/labour/getContractorWise/downloadGetAllPdf?' +
                                                  query);

                                          setState(() {
                                            isExportPdfLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                    'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'labour${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
                                          } else {
                                            ToastMsg(
                                              resData['message'],
                                              15,
                                              Colors.red,
                                            );
                                          }
                                        },
                                  child: Image.asset(
                                    "assets/pdf.png",
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: isExportPdfLoader
                                      ? null
                                      : () async {
                                          var query = '';
                                          query +=
                                              'user_id=${widget.admin_id.toString()}';
                                          // from_date=${txtController.text}&to_date=${txtController2.text}
                                          if (txtController.text != '') {
                                            query +=
                                                '&from_date=${txtController.text}';
                                          }

                                          if (txtController2.text != '') {
                                            query +=
                                                '&to_date=${txtController2.text}';
                                          }
                                          query +=
                                              '&contractor_id=${widget.contractor_id}';
                                          log('query $query');
                                          setState(() {
                                            isExportPdfLoader = true;
                                          });
                                          var resData = await apiService.getCall(
                                              'http://89.116.229.150:3003/api/labour/getContractorWise/downloadGetAllExcel?' +
                                                  query);

                                          setState(() {
                                            isExportPdfLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                    'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'labour${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
                                          } else {
                                            ToastMsg(
                                              resData['message'],
                                              15,
                                              Colors.red,
                                            );
                                          }
                                        },
                                  child: Image.asset(
                                    "assets/exel.png",
                                    height: 40,
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
                      TabBar(
                        controller: _controller,
                        labelColor: Colors.black,
                        isScrollable: true,
                        indicatorColor: Colors.black,
                        tabs: [
                          Container(
                            child: Tab(text: "LABOUR"),
                          ),
                          Container(
                            child: Tab(text: "MASON"),
                          ),
                          Container(
                            child: Tab(text: "CARPENTER"),
                          ),
                          Container(
                            child: Tab(text: "HELPER"),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _controller,
                          children: [
                            SLabour(
                              data: labour,
                              type: 2,
                              action: 1,
                              refresh: ((filters) {
                                init();
                              }),
                            ),
                            SMason(
                              data: labour,
                              type: 2,
                              refresh: ((filters) {
                                init();
                              }),
                            ),
                            SCarpenter(
                              data: labour,
                              type: 2,
                              refresh: ((filters) {
                                init();
                              }),
                            ),
                            SHelper(
                              data: labour,
                              type: 2,
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text("Total"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${fulldaytotal}",
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Container(
                                    child: Text(
                                      "${othrs / 8}",
                                      style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                        ),
                      ),
                    ),
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
        content: Text(
          "$msg",
          style: TextStyle(
            fontFamily: "Century Gothic",
          ),
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
