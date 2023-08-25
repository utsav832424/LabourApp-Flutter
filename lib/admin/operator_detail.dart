import 'package:abc_2_1/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Operator_detail extends StatefulWidget {
  const Operator_detail({super.key, required this.name});
  final name;
  @override
  State<Operator_detail> createState() => _Operator_detailState();
}

class _Operator_detailState extends State<Operator_detail> {
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

  bool isExportExcelLoader = false;
  List searchUSer = [];
  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController addstaffname = TextEditingController();
  TextEditingController editcontactorname = TextEditingController();
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

  TextEditingController txtController5 = TextEditingController();
  void _selDatePicker1() {
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
        txtController5.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  bool loader = true;
  List data = [];
  List data1 = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List businessname = [];
  var editcontractornameid = 0;
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();
  bool isExportPdfLoader = false;
  var suggestsup;
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
    // param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "operator/getnameByidCop?from_date=${txtController.text}&to_date=${txtController2.text}&user_id=${userid}&name=${widget.name}");
    log("${resData}");
    if (mounted) {
      setState(() {
        data = resData['data'];
        loader = false;
      });
    }

    var resdata1 =
        await apiService.getcall('staff/getAllSuggName?user_id=${userid}');
    log("${resdata1}");
    if (mounted) {
      setState(() {
        data1 = resdata1['data'];
        // loader = false;
      });
    }
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.postCall("staff", param);
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
                            width: MediaQuery.of(context).size.width - 160,
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
                                        "Operator Detail",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontFamily: "Century Gothic",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Column(
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
                                    textAlign: TextAlign.center,
                                    onTap: _selDatePicker,
                                    controller: txtController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: Column(
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
                                    textAlign: TextAlign.center,
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

                    //  Expanded(
                    //     child: Container(
                    //       padding: EdgeInsets.only(top: 30),
                    //       margin: EdgeInsets.symmetric(horizontal: 5),
                    //       child: Scrollbar(
                    //         child: ListView(
                    //           children: [
                    //             SingleChildScrollView(
                    //               scrollDirection: Axis.horizontal,
                    //               child:
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: ListView(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 15,
                                        left: 10,
                                        bottom: 10,
                                        right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: "Century Gothic",
                                          ),
                                        ),
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: "Century Gothic",
                                          ),
                                        ),
                                        if (userType == 2)
                                          Text(
                                            "Action",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: "Century Gothic",
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  for (var item in data)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 15,
                                              left: 10,
                                              bottom: 10,
                                              right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${item['date1']}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                              Text(
                                                "${item['operatorname']}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                              if (userType == 2)
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        editname.text =
                                                            item['name'];

                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Staff Name'),
                                                              actions: <Widget>[
                                                                Column(
                                                                  children: [
                                                                    TextFormField(
                                                                      // readOnly: true,
                                                                      controller:
                                                                          editname,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
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
                                                                      height:
                                                                          10,
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
                                                                              Colors.green[100],
                                                                          onPrimary:
                                                                              Colors.blue[900],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          if (editname
                                                                              .text
                                                                              .isEmpty) {
                                                                            ToastMsg(
                                                                              "Please enter Name",
                                                                              15,
                                                                              Colors.red,
                                                                            );
                                                                          } else {
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                editname.text;
                                                                            param['id'] =
                                                                                item['id'];
                                                                            var resData =
                                                                                await apiService.postCall('staff/editStaff', param);
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
                                                                        child:
                                                                            Text(
                                                                          "Save",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                "Century Gothic",
                                                                          ),
                                                                        ),
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
                                                      onTap: () async {
                                                        // var data = Map<String, dynamic>();
                                                        // data['name'] = addstaffname.text;
                                                        // data['user_id'] = userid.toString();
                                                        var resData =
                                                            await apiService
                                                                .getcall(
                                                          'staff/delete/${item['id']}',
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
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 17,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.black,
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
                            width: MediaQuery.of(context).size.width - 160,
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
                                        "Operator Detail",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontFamily: "Century Gothic",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Column(
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
                                    textAlign: TextAlign.center,
                                    onTap: _selDatePicker,
                                    controller: txtController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: Column(
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
                                    textAlign: TextAlign.center,
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

                    //  Expanded(
                    //     child: Container(
                    //       padding: EdgeInsets.only(top: 30),
                    //       margin: EdgeInsets.symmetric(horizontal: 5),
                    //       child: Scrollbar(
                    //         child: ListView(
                    //           children: [
                    //             SingleChildScrollView(
                    //               scrollDirection: Axis.horizontal,
                    //               child:
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: ListView(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 15,
                                        left: 10,
                                        bottom: 10,
                                        right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: "Century Gothic",
                                          ),
                                        ),
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: "Century Gothic",
                                          ),
                                        ),
                                        if (userType == 2)
                                          Text(
                                            "Action",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: "Century Gothic",
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  for (var item in data)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 15,
                                              left: 10,
                                              bottom: 10,
                                              right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${item['date1']}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                              Text(
                                                "${item['operatorname']}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                              if (userType == 2)
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        editname.text =
                                                            item['name'];

                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Staff Name'),
                                                              actions: <Widget>[
                                                                Column(
                                                                  children: [
                                                                    TextFormField(
                                                                      // readOnly: true,
                                                                      controller:
                                                                          editname,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
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
                                                                      height:
                                                                          10,
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
                                                                              Colors.green[100],
                                                                          onPrimary:
                                                                              Colors.blue[900],
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          if (editname
                                                                              .text
                                                                              .isEmpty) {
                                                                            ToastMsg(
                                                                              "Please enter Name",
                                                                              15,
                                                                              Colors.red,
                                                                            );
                                                                          } else {
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                editname.text;
                                                                            param['id'] =
                                                                                item['id'];
                                                                            var resData =
                                                                                await apiService.postCall('staff/editStaff', param);
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
                                                                        child:
                                                                            Text(
                                                                          "Save",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                "Century Gothic",
                                                                          ),
                                                                        ),
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
                                                      onTap: () async {
                                                        // var data = Map<String, dynamic>();
                                                        // data['name'] = addstaffname.text;
                                                        // data['user_id'] = userid.toString();
                                                        var resData =
                                                            await apiService
                                                                .getcall(
                                                          'staff/delete/${item['id']}',
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
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 17,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.black,
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
                  ],
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
                                  child: ListView(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
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
                                          onTap: _selDatePicker1,
                                          controller: txtController5,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter Date";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      for (var item in data1)
                                        CheckboxListTile(
                                          title: Text("${item["name"]}"),
                                          value: item['check'] == null
                                              ? false
                                              : item['check'],
                                          onChanged: (value) {
                                            setstate(() {
                                              if (item['check'] == null) {
                                                item['check'] = true;
                                              } else {
                                                item['check'] = !item['check'];
                                              }
                                            });
                                          },
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 140,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                                onPrimary: Colors.white,
                                              ),
                                              onPressed: () async {
                                                // log("${txtController5.text}");
                                                // log("${data1}");
                                                var param =
                                                    new Map<String, dynamic>();
                                                param['data'] =
                                                    jsonEncode(data1);
                                                param['date'] =
                                                    txtController5.text;
                                                log("${param}");
                                                var resdata =
                                                    await apiService.postCall(
                                                        'staff/CreateNameC',
                                                        param);
                                                // log("${resdata}");
                                                if (resdata['status'] == 1) {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 140,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                onPrimary: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Close",
                                                style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5, right: 10),
                                            child: TextButton(
                                              onPressed: () {
                                                showModalBottomSheet<void>(
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius: BorderRadius.circular(10),
                                                  // ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    child:
                                                        DraggableScrollableSheet(
                                                      initialChildSize: 0.7,
                                                      minChildSize: 0.3,
                                                      maxChildSize: 0.9,
                                                      builder: (_,
                                                              controller) =>
                                                          StatefulBuilder(builder:
                                                              (BuildContext
                                                                      context,
                                                                  setstate) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(15),
                                                              topLeft: Radius
                                                                  .circular(15),
                                                            ),
                                                          ),
                                                          // height: 1000,

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
                                                                          left:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "Date",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              "Century Gothic",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      child:
                                                                          TextFormField(
                                                                        readOnly:
                                                                            true,
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
                                                                        validator:
                                                                            (value) {
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
                                                                          top:
                                                                              20,
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "Name",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontFamily:
                                                                              "Century Gothic",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              5),
                                                                      child: Autocomplete<
                                                                          String>(
                                                                        optionsBuilder:
                                                                            (TextEditingValue
                                                                                textEditingValue) async {
                                                                          if (textEditingValue.text ==
                                                                              '') {
                                                                            return const Iterable<String>.empty();
                                                                          } else {
                                                                            List<String>
                                                                                serachdata =
                                                                                [];
                                                                            var data =
                                                                                Map<String, dynamic>();
                                                                            data['name'] =
                                                                                textEditingValue.text;
                                                                            data['user_id'] =
                                                                                userid.toString();
                                                                            var resdata =
                                                                                await apiService.getUserSuggestion('staff/searchName', data);
                                                                            log('popopopopo${resdata}');
                                                                            searchUSer =
                                                                                resdata;
                                                                            for (var data
                                                                                in resdata) {
                                                                              serachdata.add(data['name']);
                                                                            }
                                                                            // log('fghigh ${serachdata}');
                                                                            // serachdata =
                                                                            //     resdata[
                                                                            //         'name'];
                                                                            serachdata.retainWhere((s) {
                                                                              return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                                                            });
                                                                            return serachdata;
                                                                          }
                                                                        },
                                                                        onSelected:
                                                                            (dynamic
                                                                                suggestion) {
                                                                          log('You just selected $suggestion');
                                                                          var getid;
                                                                          getid = searchUSer
                                                                              .where((x) => x['name'].toLowerCase().contains(suggestion.toLowerCase()))
                                                                              .toList();
                                                                          log("getid ${getid}");
                                                                          for (var item
                                                                              in getid) {
                                                                            if (item['name'] ==
                                                                                suggestion) {
                                                                              suggestsup = item['id'].toString();
                                                                            }
                                                                          }
                                                                          log('id : ${suggestsup}');
                                                                          name.text =
                                                                              suggestion;
                                                                          log("Supplier ${name.text}");
                                                                        },
                                                                      ),
                                                                      //     Container(
                                                                      //   child:
                                                                      //       TypeAheadFormField(
                                                                      //     textFieldConfiguration:
                                                                      //         TextFieldConfiguration(
                                                                      //       controller:
                                                                      //           name,
                                                                      //       decoration: InputDecoration(
                                                                      //           border: OutlineInputBorder(
                                                                      //               // borderRadius:
                                                                      //               //     BorderRadius.all(
                                                                      //               //   Radius.circular(30),
                                                                      //               // ),
                                                                      //               // borderSide:
                                                                      //               //     BorderSide.none,
                                                                      //               ),
                                                                      //           hintStyle: TextStyle(color: Colors.grey),
                                                                      //           // filled: true,
                                                                      //           // fillColor: Colors.white,
                                                                      //           hintText: 'Enter a Name'),
                                                                      //     ),
                                                                      //     suggestionsCallback:
                                                                      //         (pattern) async {
                                                                      // var data =
                                                                      //     Map<String, dynamic>();
                                                                      // data['name'] =
                                                                      //     pattern;
                                                                      // data['user_id'] =
                                                                      //     userid.toString();

                                                                      //       return await apiService.getUserSuggestion('staff/searchName',
                                                                      //           data);
                                                                      //     },
                                                                      //     itemBuilder:
                                                                      //         (context, dynamic suggestion) {
                                                                      //       return ListTile(
                                                                      //         leading: Icon(Icons.person),
                                                                      //         title: Text(suggestion['name']),
                                                                      //       );
                                                                      //     },
                                                                      //     onSuggestionSelected:
                                                                      //         (dynamic suggestion) {
                                                                      //       suggestsup =
                                                                      //           suggestion['id'];
                                                                      //       name.text =
                                                                      //           suggestion['name'];
                                                                      //     },
                                                                      //     validator:
                                                                      //         (value) {
                                                                      //       if (value == "" ||
                                                                      //           value == null ||
                                                                      //           value.isEmpty) {
                                                                      //         return "Code is required, Please enter code";
                                                                      //       }
                                                                      //       return null;
                                                                      //     },
                                                                      //   ),
                                                                      // ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              160,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.green,
                                                                              onPrimary: Colors.white,
                                                                            ),
                                                                            onPressed: isLoad
                                                                                ? null
                                                                                : () async {
                                                                                    if (loginForm.currentState!.validate()) {
                                                                                      setState(
                                                                                        () {
                                                                                          isLoad = true;
                                                                                        },
                                                                                      );
                                                                                      var data = Map<String, dynamic>();
                                                                                      data['name'] = suggestsup;
                                                                                      data['date'] = txtController3.text;
                                                                                      data['user_id'] = userid.toString();
                                                                                      data['isactive'] = "1";

                                                                                      print(data);
                                                                                      var login = await apiService.postCall('staff', data);
                                                                                      setState(
                                                                                        () {
                                                                                          isLoad = false;
                                                                                        },
                                                                                      );
                                                                                      if (login['success'] == 0) {
                                                                                        setState(() {
                                                                                          ErrorMessage = login['message'];
                                                                                        });
                                                                                      } else {
                                                                                        ToastMsg(
                                                                                          login['message'],
                                                                                          15,
                                                                                          Colors.green,
                                                                                        );
                                                                                        init();
                                                                                        name.text = '';

                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    }
                                                                                  },
                                                                            child:
                                                                                Text(
                                                                              "Save",
                                                                              style: TextStyle(
                                                                                fontFamily: "Century Gothic",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              160,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.red,
                                                                              onPrimary: Colors.white,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "Close",
                                                                              style: TextStyle(
                                                                                fontFamily: "Century Gothic",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Add Staff",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
