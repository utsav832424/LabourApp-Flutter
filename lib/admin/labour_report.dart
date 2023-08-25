import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/admin/carpenter.dart';
import 'package:abc_2_1/admin/helper.dart';
import 'package:abc_2_1/admin/labour.dart';
import 'package:abc_2_1/admin/mason.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Labour_Report extends StatefulWidget {
  Labour_Report({Key? key}) : super(key: key);

  @override
  State<Labour_Report> createState() => _Labour_ReportState();
}

class _Labour_ReportState extends State<Labour_Report>
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
  var getid;
  var suggetioname;
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
  List searchUSer = [];
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
  bool isExportPdfLoader = false;

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    txtController3.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

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
      "labour?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}",
    );
    log("${resData}");
    if (mounted) {
      setState(() {
        labour = resData['data']['data'];
        total = resData['data']['total'];
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
    double o = 0;
    setState(() {
      o = othrs / 8;
    });
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
                                width: MediaQuery.of(context).size.width - 160,
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
                                              color: Colors.blue[900],
                                              fontSize: 15,
                                              fontFamily: "Century Gothic",
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
                            if (userType == 1)
                              TextButton(
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter contractorname";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText:
                                                      'Enter a contractorname',
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Colors.green[100],
                                                          onPrimary:
                                                              Colors.blue[900],
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
                                                            ToastMsg(
                                                              "Data Added",
                                                              15,
                                                              Colors.green,
                                                            );
                                                            var data = Map<
                                                                String,
                                                                dynamic>();
                                                            data['name'] =
                                                                addcontactorname
                                                                    .text;
                                                            data['user_id'] =
                                                                userid
                                                                    .toString();
                                                            var resData =
                                                                await apiService
                                                                    .postCall(
                                                                        'labour/addContractor',
                                                                        data);
                                                            if (resData[
                                                                    'success'] ==
                                                                0) {
                                                              ToastMsg(
                                                                "Data Added",
                                                                15,
                                                                Colors.green,
                                                              );
                                                              ToastMsg(
                                                                resData[
                                                                    'message'],
                                                                15,
                                                                Colors.red,
                                                              );
                                                            } else {
                                                              ToastMsg(
                                                                "Data Added",
                                                                15,
                                                                Colors.green,
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          "Save",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "Century Gothic",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Colors.green[100],
                                                          onPrimary:
                                                              Colors.blue[900],
                                                        ),
                                                        onPressed: () async {
                                                          var resData =
                                                              await apiService
                                                                  .getcall(
                                                                      "labour/getContractor?user_id=${userid}");

                                                          Navigator.pop(
                                                              context);
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Contactor Name List'),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  child: Column(
                                                                    children: [
                                                                      for (var item
                                                                          in resData[
                                                                              'data'])
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Container(
                                                                                  margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                                                                                  child: Text(
                                                                                    "${item['name']}",
                                                                                    style: TextStyle(
                                                                                      // fontWeight: FontWeight.bold,
                                                                                      fontSize: 15,
                                                                                      fontFamily: "Century Gothic",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  child: Row(
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
                                                                                                                      ToastMsg(
                                                                                                                        "Data Added",
                                                                                                                        15,
                                                                                                                        Colors.green,
                                                                                                                      );
                                                                                                                      Navigator.pop(context);
                                                                                                                      Navigator.pop(context);
                                                                                                                    }
                                                                                                                  }
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                  "Save",
                                                                                                                  style: TextStyle(
                                                                                                                    fontSize: 15,
                                                                                                                    fontFamily: "Century Gothic",
                                                                                                                  ),
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
                                                                              height: 1,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          "View",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "Century Gothic",
                                                          ),
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
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue[900],
                                    ),
                                    Text(
                                      'add Con..',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Century Gothic",
                                      ),
                                    )
                                  ],
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
                                                'user_id=${userid.toString()}';
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
                                                'http://89.116.229.150:3003/api/labour/downloadGetAllpdf?' +
                                                    query);
                                            setState(() {
                                              isExportPdfLoader = false;
                                            });
                                            if (resData['success'] == 1) {
                                              openFile(
                                                  url:
                                                      'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                  filename:
                                                      'Staff${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
                                            } else {
                                              ToastMsg(
                                                resData['message'],
                                                15,
                                                Colors.red,
                                              );
                                            }
                                          },
                                    child: Container(
                                      child: Image.asset(
                                        "assets/pdf.png",
                                        height: 40,
                                      ),
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
                                                'user_id=${userid.toString()}';
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
                                                'http://89.116.229.150:3003/api/labour/downloadGetAllExcel?' +
                                                    query);
                                            setState(() {
                                              isExportPdfLoader = false;
                                            });
                                            if (resData['success'] == 1) {
                                              openFile(
                                                  url:
                                                      'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                  filename:
                                                      'Staff${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(context,
                              //   //     MaterialPageRoute(builder: (context) => Appbar()));
                              // },
                              child: Container(
                                child: Tab(text: "LABOUR"),
                              ),
                            ),
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(
                              //   //     context,
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => Bankingone(
                              //   //               title: "IT SECTOR",
                              //   //             )));
                              // },
                              child: Container(
                                child: Tab(text: "MASON"),
                              ),
                            ),
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(
                              //   //     context,
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => Bankingone(
                              //   //               title: "PHARMA SECTOR",
                              //   //             )));
                              // },
                              child: Container(
                                child: Tab(text: "CARPENTER"),
                              ),
                            ),
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(
                              //   //     context,
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => Bankingone(
                              //   //               title: "PHARMA SECTOR",
                              //   //             )));
                              // },
                              child: Container(
                                child: Tab(text: "HELPER"),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              Labour(data: labour, type: 1),
                              Mason(data: labour, type: 1),
                              Carpenter(data: labour, type: 1),
                              Helper(data: labour, type: 1),
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
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${fulldaytotal}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Container(
                                    child: Text(
                                      "${othrs / 8}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Century Gothic",
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
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
                  if (userType == 1)
                    Positioned(
                      right: 10,
                      bottom: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              // labourfullday.text = '0';
                              // labourothrs.text = '0';
                              // masonfullday.text = '0';
                              // masonothrs.text = '0';
                              // carpenterfullday.text = '0';
                              // carprnterothrs.text = '0';
                              // helperfullday.text = '0';
                              // helperothrs.text = '0';
                            });
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
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, top: 10),
                                                    child: Text(
                                                      "Date",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "Century Gothic",
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 10),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker3,
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
                                                            fontSize: 15,
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
                                                            data['user_id'] =
                                                                userid;
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
                                                            fontSize: 15,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  labourfullday,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  labourothrs,
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
                                                            fontSize: 15,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  masonfullday,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  masonothrs,
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
                                                            fontSize: 15,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  carpenterfullday,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  carprnterothrs,
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
                                                            fontSize: 15,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  helperfullday,
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
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  helperothrs,
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Century Gothic",
                                                                ),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Century Gothic",
                                                                ),
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
                                // width: 1000,
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
                                              color: Colors.blue[900],
                                              fontSize: 15,
                                              fontFamily: "Century Gothic",
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
                            if (userType == 1)
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text(
                                                'Add Contactor Name'),
                                            actions: <Widget>[
                                              Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        addcontactorname,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Please enter contractorname";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Enter a contractorname',
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
                                                              if (addcontactorname
                                                                  .text
                                                                  .isEmpty) {
                                                                ToastMsg(
                                                                  "Please enter contractorname",
                                                                  15,
                                                                  Colors.red,
                                                                );
                                                              } else {
                                                                var data = Map<
                                                                    String,
                                                                    dynamic>();
                                                                data['name'] =
                                                                    addcontactorname
                                                                        .text;
                                                                data['user_id'] =
                                                                    userid
                                                                        .toString();
                                                                var resData =
                                                                    await apiService
                                                                        .postCall(
                                                                            'labour/addContractor',
                                                                            data);
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
                                                            child: Text(
                                                              "Save",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Century Gothic",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Container(
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
                                                              var resData =
                                                                  await apiService
                                                                      .getcall(
                                                                          "labour/getContractor?user_id=${userid}");

                                                              Navigator.pop(
                                                                  context);
                                                              showDialog<void>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Contactor Name List'),
                                                                    content:
                                                                        Form(
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            for (var item
                                                                                in resData['data'])
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                                                                                        child: Text(
                                                                                          "${item['name']}",
                                                                                          style: TextStyle(
                                                                                            fontFamily: "Century Gothic",

                                                                                            // fontWeight: FontWeight.bold,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        child: Row(
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
                                                                                                                              "Data Added",
                                                                                                                              15,
                                                                                                                              Colors.green,
                                                                                                                            );
                                                                                                                            ToastMsg(
                                                                                                                              resData['message'],
                                                                                                                              15,
                                                                                                                              Colors.red,
                                                                                                                            );
                                                                                                                          } else {
                                                                                                                            ToastMsg(
                                                                                                                              "Data Added",
                                                                                                                              15,
                                                                                                                              Colors.green,
                                                                                                                            );
                                                                                                                            Navigator.pop(context);
                                                                                                                            Navigator.pop(context);
                                                                                                                          }
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
                                                                                    height: 1,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              "View",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Century Gothic",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ]);
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.blue[900],
                                        ),
                                        Text(
                                          "Contractor Na..",
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
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 20, left: 20),
                                // width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                // width: 200,
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
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, right: 20),
                              child: Row(
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: isExportPdfLoader
                                          ? null
                                          : () async {
                                              var query = '';
                                              query +=
                                                  'user_id=${userid.toString()}';
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
                                              var resData =
                                                  await apiService.getCall(
                                                      'http://89.116.229.150:3003/api/labour/downloadGetAllpdf?' +
                                                          query);

                                              setState(() {
                                                isExportPdfLoader = false;
                                              });
                                              if (resData['success'] == 1) {
                                                openFile(
                                                    url:
                                                        'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                    filename:
                                                        'Staff${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: isExportPdfLoader
                                          ? null
                                          : () async {
                                              var query = '';
                                              query +=
                                                  'user_id=${userid.toString()}';
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
                                              var resData =
                                                  await apiService.getCall(
                                                      'http://89.116.229.150:3003/api/labour/downloadGetAllExcel?' +
                                                          query);

                                              setState(() {
                                                isExportPdfLoader = false;
                                              });
                                              if (resData['success'] == 1) {
                                                openFile(
                                                    url:
                                                        'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                    filename:
                                                        'Staff${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(context,
                              //   //     MaterialPageRoute(builder: (context) => Appbar()));
                              // },
                              child: Container(
                                child: Tab(text: "LABOUR"),
                              ),
                            ),
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(
                              //   //     context,
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => Bankingone(
                              //   //               title: "IT SECTOR",
                              //   //             )));
                              // },
                              child: Container(
                                child: Tab(text: "MASON"),
                              ),
                            ),
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(
                              //   //     context,
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => Bankingone(
                              //   //               title: "PHARMA SECTOR",
                              //   //             )));
                              // },
                              child: Container(
                                child: Tab(text: "CARPENTER"),
                              ),
                            ),
                            GestureDetector(
                              // onLongPress: () {
                              //   // Navigator.push(
                              //   //     context,
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => Bankingone(
                              //   //               title: "PHARMA SECTOR",
                              //   //             )));
                              // },
                              child: Container(
                                child: Tab(text: "HELPER"),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              Labour(data: labour, type: 1),
                              Mason(data: labour, type: 1),
                              Carpenter(data: labour, type: 1),
                              Helper(data: labour, type: 1),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Total"),
                              Row(
                                children: [
                                  Text(
                                    "${fulldaytotal}",
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Container(
                                    child: Text(
                                      "${othrs / 8}",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: "Century Gothic",
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
                            setState(() {
                              // labourfullday.text = '0';
                              // labourothrs.text = '0';
                              // masonfullday.text = '0';
                              // masonothrs.text = '0';
                              // carpenterfullday.text = '0';
                              // carprnterothrs.text = '0';
                              // helperfullday.text = '0';
                              // helperothrs.text = '0';
                            });
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
                                      decoration: const BoxDecoration(
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
                                                            top: 10),
                                                        child: TextFormField(
                                                          readOnly: true,
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
                                                        child: Autocomplete<
                                                            String>(
                                                          fieldViewBuilder: (context,
                                                              textEditingController,
                                                              focusNode,
                                                              onEditingComplete) {
                                                            return TextFormField(
                                                              validator:
                                                                  (value) {
                                                                log("name of sug : ${suggetioname}");
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty ||
                                                                    value !=
                                                                        suggetioname) {
                                                                  return "Enter a name";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                              controller:
                                                                  textEditingController,
                                                              focusNode:
                                                                  focusNode,
                                                              onEditingComplete:
                                                                  onEditingComplete,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    UnderlineInputBorder(),
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
                                                              var data = Map<
                                                                  String,
                                                                  dynamic>();
                                                              data['name'] =
                                                                  textEditingValue
                                                                      .text;
                                                              data['user_id'] =
                                                                  userid;
                                                              var resdata =
                                                                  await apiService
                                                                      .getUserSuggestion(
                                                                          'labour/searchContractorName',
                                                                          data);
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
                                                            suggetioname =
                                                                suggestion;
                                                            log('You just selected $suggestion');

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
                                                      // Container(
                                                      //   margin: EdgeInsets.only(
                                                      //     left: 10,
                                                      //     right: 10,
                                                      //   ),
                                                      //   child:
                                                      //       TypeAheadFormField(
                                                      //     textFieldConfiguration:
                                                      //         TextFieldConfiguration(
                                                      //       controller:
                                                      //           contractorname,
                                                      //       decoration: InputDecoration(
                                                      //           border: OutlineInputBorder(
                                                      //               // borderRadius:
                                                      //               //     BorderRadius.all(
                                                      //               //   Radius.circular(30),
                                                      //               // ),
                                                      //               // borderSide:
                                                      //               //     BorderSide.none,
                                                      //               ),
                                                      //           hintStyle: TextStyle(color: Colors.black),
                                                      //           // filled: true,
                                                      //           // fillColor: Colors.white,
                                                      //           hintText: 'Enter Contactorname'),
                                                      //     ),
                                                      //     suggestionsCallback:
                                                      //         (pattern) async {
                                                      // var data = Map<
                                                      //     String,
                                                      //     dynamic>();
                                                      // data['name'] =
                                                      //     pattern;
                                                      // data['user_id'] =
                                                      //     userid;
                                                      //       return await apiService
                                                      //           .getUserSuggestion(
                                                      //               'labour/searchContractorName',
                                                      //               data);
                                                      //     },
                                                      //     itemBuilder: (context,
                                                      //         dynamic
                                                      //             suggestion) {
                                                      //       return ListTile(
                                                      //         leading: Icon(
                                                      //             Icons.person),
                                                      //         title: Text(
                                                      //             suggestion[
                                                      //                 'name']),
                                                      //       );
                                                      //     },
                                                      //     onSuggestionSelected:
                                                      //         (dynamic
                                                      //             suggestion) {
                                                      //       contractornameid =
                                                      //           suggestion[
                                                      //               'id'];
                                                      // contractorname
                                                      //         .text =
                                                      //           suggestion[
                                                      //               'name'];
                                                      //     },
                                                      //     validator: (value) {
                                                      //       if (value == "" ||
                                                      //           value == null ||
                                                      //           value.isEmpty) {
                                                      //         return "Code is required, Please enter code";
                                                      //       }
                                                      //       return null;
                                                      //     },
                                                      //   ),
                                                      // ),
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
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 8,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    labourfullday,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'labourfullday',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 6,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    labourothrs,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'labourothrs',
                                                                ),
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
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 8,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    masonfullday,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'masonfullday',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 6,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    masonothrs,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'masonothrs',
                                                                ),
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
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 8,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    carpenterfullday,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'carpenterfullday',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 6,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    carprnterothrs,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'carprnterothrs',
                                                                ),
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
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 8,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    helperfullday,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'helperfullday',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              // width: 165,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 6,
                                                                right: 6,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    helperothrs,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      'helperothrs',
                                                                ),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Century Gothic",
                                                                ),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Century Gothic",
                                                                ),
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
