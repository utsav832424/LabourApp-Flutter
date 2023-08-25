import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/admin/view.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class View1 extends StatefulWidget {
  View1({Key? key}) : super(key: key);
  // final data;
  // final type;

  @override
  State<View1> createState() => _View1State();
}

class _View1State extends State<View1> {
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

  final now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  var totalused = 0;
  var incoming = 0;
  var yesterdaystock = 0;
  var totalstock = 0;

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
  bool isExportPdfLoader = false;
  bool isExportExcelLoader = false;
  var token = "";
  var userid = 0;
  var userType = 0;
  late List diesel = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();
  final txtController2 = TextEditingController();
  final txtController4 = TextEditingController();
  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();

    // txtController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // txtController2.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
        "diesel/getAllDiesel?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}");
    log("${resData}");
    if (mounted) {
      setState(() {
        diesel = resData['data'];
        loader = false;
      });
    }
  }

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
        txtController4.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List Summ = [];
    for (var i = 0; i < diesel.length; i++) {
      var myDouble = int.parse(diesel[i]['ltr'].toString());
      Summ.add(myDouble);
    }

    int sum = 0;

    for (var i in Summ) {
      // Each element of iterator and added to sum variable.
      sum = i + sum;
    }

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
                          padding: const EdgeInsets.all(5.0),
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
                            width: MediaQuery.of(context).size.width - 80,
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
                                        "Diesel Report",
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
                        // if (userType == 1)
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
                                  fontFamily: "Century Gothic",
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
                        Container(
                          margin: EdgeInsets.only(top: 20, right: 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: isExportPdfLoader
                                    ? null
                                    : () async {
                                        var query = '';
                                        query += 'user_id=${userid.toString()}';
                                        // from_date=${txtController.text}&to_date=${txtController2.text}
                                        if (txtController.text != '') {
                                          query +=
                                              '&from_date=${txtController.text}';
                                        }

                                        if (txtController2.text != '') {
                                          query +=
                                              '&to_date=${txtController2.text}';
                                        }
                                        log('query $query');
                                        setState(() {
                                          isExportPdfLoader = true;
                                        });
                                        var resData = await apiService.getCall(
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllLtrPdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'diesel${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
                                        } else {
                                          ToastMsg(
                                            resData['message'],
                                            15,
                                            Colors.red,
                                          );
                                        }
                                      },
                                child: isExportPdfLoader
                                    ? CircularProgressIndicator()
                                    : Image.asset(
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
                                        query += 'user_id=${userid.toString()}';
                                        // from_date=${txtController.text}&to_date=${txtController2.text}
                                        if (txtController.text != '') {
                                          query +=
                                              '&from_date=${txtController.text}';
                                        }

                                        if (txtController2.text != '') {
                                          query +=
                                              '&to_date=${txtController2.text}';
                                        }
                                        log('query $query');
                                        setState(() {
                                          isExportExcelLoader = true;
                                        });
                                        var resData = await apiService.getCall(
                                            'http://89.116.229.150:3003/api/diesel/downloadGetLtrExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'diesel${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
                                        } else {
                                          ToastMsg(
                                            resData['message'],
                                            15,
                                            Colors.red,
                                          );
                                        }
                                      },
                                child: isExportExcelLoader
                                    ? CircularProgressIndicator()
                                    : Image.asset(
                                        "assets/exel.png",
                                        height: 40,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _vertical,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: Scrollbar(
                          controller: _horizontal,
                          thumbVisibility: true,
                          trackVisibility: true,
                          notificationPredicate: (notif) => notif.depth == 1,
                          child: SingleChildScrollView(
                            controller: _vertical,
                            child: SingleChildScrollView(
                              controller: _horizontal,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                // padding: EdgeInsets.only(top: 30, bottom: 50),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    defaultColumnWidth: FixedColumnWidth(
                                      200,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 15, left: 10),
                                              child: Text(
                                                "Ltr",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (userType == 2)
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Action",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        "Century Gothic",
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
                                                    left: 10,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  "${data['date']}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 15,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  "${data['ltr']}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (userType == 2)
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 5,
                                                    left: 10,
                                                    bottom: 5,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          editvehiclename.text =
                                                              data['machinery'];
                                                          editvehiclenumber
                                                                  .text =
                                                              data[
                                                                  'vehiclenumber'];
                                                          editdriver.text =
                                                              data['driver'];
                                                          editqtyltr.text =
                                                              data['qty_ltr'];

                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Contactor Name'),
                                                                actions: <Widget>[
                                                                  Container(
                                                                    height: 300,
                                                                    child:
                                                                        ListView(
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editvehiclename,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter vehiclename";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a vehiclename',
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editvehiclenumber,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter Vehicle No";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a Vehicle No',
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editdriver,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter driver";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a driver',
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  primary: Colors.green[100],
                                                                                  onPrimary: Colors.blue[900],
                                                                                ),
                                                                                onPressed: () async {
                                                                                  if (editvehiclename.text.isEmpty) {
                                                                                    ToastMsg(
                                                                                      "Please enter Name",
                                                                                      15,
                                                                                      Colors.red,
                                                                                    );
                                                                                  } else {
                                                                                    var param = Map<String, dynamic>();
                                                                                    param['machinery'] = editvehiclename.text;
                                                                                    param['vehiclenumber'] = editvehiclenumber.text;
                                                                                    param['driver'] = editdriver.text;
                                                                                    param['qty_ltr'] = editqtyltr.text;
                                                                                    param['id'] = data['id'];
                                                                                    var resData = await apiService.postCall('diesel/editDiesel', param);
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
                                                                                child: Text("Save"),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
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
                                                            'diesel/delete/${data['id']}',
                                                          );
                                                          if (resData[
                                                                  'sucess'] ==
                                                              1) {
                                                            ToastMsg(
                                                              resData[
                                                                  'message'],
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
                          )))),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [],
                            ),
                            Column(
                              children: [],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Total Stock",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  sum.toString(),
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
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
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
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
                                      "Diesel Report",
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
                    children: [
                      SizedBox(
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From Date:",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              // width: 100,
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
                      const SizedBox(
                        width: 50,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "To Date:",
                              style: TextStyle(
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
                      SizedBox(
                        width: 500,
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
                                      query += 'user_id=${userid.toString()}';
                                      // from_date=${txtController.text}&to_date=${txtController2.text}
                                      if (txtController.text != '') {
                                        query +=
                                            '&from_date=${txtController.text}';
                                      }

                                      if (txtController2.text != '') {
                                        query +=
                                            '&to_date=${txtController2.text}';
                                      }
                                      log('query $query');
                                      setState(() {
                                        isExportPdfLoader = true;
                                      });
                                      var resData = await apiService.getCall(
                                          'http://89.116.229.150:3003/api/diesel/downloadGetAllLtrPdf?' +
                                              query);

                                      setState(() {
                                        isExportPdfLoader = false;
                                      });
                                      if (resData['success'] == 1) {
                                        openFile(
                                            url:
                                                'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                            filename:
                                                'diesel${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
                                      } else {
                                        ToastMsg(
                                          resData['message'],
                                          15,
                                          Colors.red,
                                        );
                                      }
                                    },
                              child: isExportPdfLoader
                                  ? CircularProgressIndicator()
                                  : Image.asset(
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
                                      query += 'user_id=${userid.toString()}';
                                      // from_date=${txtController.text}&to_date=${txtController2.text}
                                      if (txtController.text != '') {
                                        query +=
                                            '&from_date=${txtController.text}';
                                      }

                                      if (txtController2.text != '') {
                                        query +=
                                            '&to_date=${txtController2.text}';
                                      }
                                      log('query $query');
                                      setState(() {
                                        isExportExcelLoader = true;
                                      });
                                      var resData = await apiService.getCall(
                                          'http://89.116.229.150:3003/api/diesel/downloadGetLtrExcel?' +
                                              query);

                                      setState(() {
                                        isExportExcelLoader = false;
                                      });
                                      if (resData['success'] == 1) {
                                        openFile(
                                            url:
                                                'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                            filename:
                                                'diesel${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
                                      } else {
                                        ToastMsg(
                                          resData['message'],
                                          15,
                                          Colors.red,
                                        );
                                      }
                                    },
                              child: isExportExcelLoader
                                  ? CircularProgressIndicator()
                                  : Image.asset(
                                      "assets/exel.png",
                                      height: 40,
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
                  //     Expanded(
                  //       child: Container(
                  //         margin: EdgeInsets.only(top: 20, left: 20),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "From Date:",
                  //               style: TextStyle(
                  //                 color: Colors.blue[900],
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 18,
                  //               ),
                  //             ),
                  //             Container(
                  //               // width: 100,
                  //               child: TextFormField(
                  //                 readOnly: true,
                  //                 // decoration:
                  //                 //     InputDecoration(labelText: 'Selected Date'),
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
                    child: Container(
                      padding: EdgeInsets.only(top: 30, bottom: 50),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: ListView(
                        children: [
                          Scrollbar(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Table(
                                border: TableBorder(
                                    horizontalInside: BorderSide(
                                  color: Colors.grey,
                                )),
                                defaultColumnWidth: FixedColumnWidth(
                                  300,
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: "Century Gothic",
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 15, left: 10),
                                          child: Text(
                                            "Ltr",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: "Century Gothic",
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
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
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 10,
                                                bottom: 5,
                                                right: 5),
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
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 15,
                                                bottom: 5,
                                                right: 5),
                                            child: Text(
                                              "${data['ltr']}",
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
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 10,
                                                bottom: 5,
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      editvehiclename.text =
                                                          data['machinery'];
                                                      editvehiclenumber.text =
                                                          data['vehiclenumber'];
                                                      editdriver.text =
                                                          data['driver'];
                                                      editqtyltr.text =
                                                          data['qty_ltr'];

                                                      showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Edit Contactor Name'),
                                                            actions: <Widget>[
                                                              Container(
                                                                height: 300,
                                                                child: ListView(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        TextFormField(
                                                                          // readOnly: true,
                                                                          controller:
                                                                              editvehiclename,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter vehiclename";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a vehiclename',
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        TextFormField(
                                                                          // readOnly: true,
                                                                          controller:
                                                                              editvehiclenumber,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter Vehicle No";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Vehicle No',
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        TextFormField(
                                                                          // readOnly: true,
                                                                          controller:
                                                                              editdriver,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter driver";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a driver',
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
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
                                                                              primary: Colors.green[100],
                                                                              onPrimary: Colors.blue[900],
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              if (editvehiclename.text.isEmpty) {
                                                                                ToastMsg(
                                                                                  "Please enter Name",
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                var param = Map<String, dynamic>();
                                                                                param['machinery'] = editvehiclename.text;
                                                                                param['vehiclenumber'] = editvehiclenumber.text;
                                                                                param['driver'] = editdriver.text;
                                                                                param['qty_ltr'] = editqtyltr.text;
                                                                                param['id'] = data['id'];
                                                                                var resData = await apiService.postCall('diesel/editDiesel', param);
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
                                                        'diesel/delete/${data['id']}',
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
                          SizedBox(
                            height: 30,
                          )
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
                        )))),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [],
                          ),
                          Column(
                            children: [],
                          ),
                          Column(
                            children: [
                              Text(
                                "Total Stock",
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                sum.toString(),
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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
            fontSize: 15,
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
