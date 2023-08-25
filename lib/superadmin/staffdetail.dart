import 'dart:developer';
import 'dart:io';
import 'package:abc_2_1/superadmin/staff_namedetail.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class StaffDetail extends StatefulWidget {
  StaffDetail({Key? key, required this.user_id, required this.refresh})
      : super(key: key);
  final user_id;
  final void Function(Map<String, dynamic> filters) refresh;

  @override
  State<StaffDetail> createState() => _StaffDetailState();
}

class _StaffDetailState extends State<StaffDetail> {
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

  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  bool isExportPdfLoader = false;
  bool isExportExcelLoader = false;

  TextEditingController name = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  var suggestsup;
  List searchUSer = [];
  var contractornameid;
  List materialUSer = [];
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
        // txtController.text = DateFormat.yMd().format(picke dDate);
        txtController1.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
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
      });
    });
  }

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List businessname = [];
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

  final now = DateFormat("yyyy-MM-dd").format(DateTime.now());

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
        "staff?from_date=${txtController.text}&to_date=${txtController2.text}&user_id=${widget.user_id}");
    log("${resData}");
    if (mounted) {
      setState(() {
        data = resData['data'];
        loader = false;
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
        txtController2.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Stack(
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
                                "Staff",
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
                                      query += 'user_id=${widget.user_id}';
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
                                          'http://89.116.229.150:3003/api/staff/downloadGetAllpdf?' +
                                              query);

                                      setState(() {
                                        isExportPdfLoader = false;
                                      });
                                      if (resData['success'] == 1) {
                                        openFile(
                                            url:
                                                'http://89.116.229.150/~pramukh/labourapp' +
                                                    resData['fileLink'],
                                            filename:
                                                'StaffSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                      query += 'user_id=${widget.user_id}';
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
                                          'http://89.116.229.150:3003/api/staff/downloadGetAllExcel?' +
                                              query);

                                      setState(() {
                                        isExportExcelLoader = false;
                                      });
                                      if (resData['success'] == 1) {
                                        openFile(
                                            url:
                                                'http://89.116.229.150/~pramukh/labourapp' +
                                                    resData['fileLink'],
                                            filename:
                                                'StaffSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                      child: Container(
                          padding: EdgeInsets.only(top: 30),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: ListView(children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 15, left: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            fontFamily: "Century Gothic",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                            fontFamily: "Century Gothic",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        if (userType == 2)
                                          Text(
                                            "Action",
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
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
                                              top: 15, left: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${item['date']}",
                                                style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Staff_NameDetail(
                                                          user_id:
                                                              item["user_id"],
                                                          name: item["name"],
                                                          refresh: ((filters) {
                                                            init();
                                                          }),
                                                        ),
                                                      ));
                                                },
                                                child: Text(
                                                  "${item['staff_name']}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              if (userType == 2)
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        editname.text =
                                                            item['staff_name'];
                                                        txtController1.text =
                                                            item['date'];
                                                        contractornameid =
                                                            item['name'];
                                                        log("con : ${contractornameid}");
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Staff Name'),
                                                              actions: <Widget>[
                                                                Container(
                                                                  height: 200,
                                                                  child:
                                                                      ListView(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            TextFormField(
                                                                          // readOnly:
                                                                          //     true,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Date',
                                                                          ),
                                                                          onTap:
                                                                              _selDatePicker5,
                                                                          controller:
                                                                              txtController1,
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
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TypeAheadFormField(
                                                                        textFieldConfiguration:
                                                                            TextFieldConfiguration(
                                                                          controller:
                                                                              editname,
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
                                                                              hintText: 'Enter a Staff'),
                                                                        ),
                                                                        suggestionsCallback:
                                                                            (pattern) async {
                                                                          var param = Map<
                                                                              String,
                                                                              dynamic>();
                                                                          param['name'] =
                                                                              pattern;
                                                                          param['user_id'] =
                                                                              item["user_id"];
                                                                          // log("${param}");
                                                                          return await apiService.getUserSuggestion(
                                                                              'staff/searchName',
                                                                              param);
                                                                        },
                                                                        itemBuilder:
                                                                            (context,
                                                                                dynamic suggestion) {
                                                                          return ListTile(
                                                                            leading:
                                                                                Icon(Icons.person),
                                                                            title:
                                                                                Text(suggestion['name']),
                                                                          );
                                                                        },
                                                                        onSuggestionSelected:
                                                                            (dynamic
                                                                                suggestion) {
                                                                          contractornameid =
                                                                              suggestion['id'];
                                                                          editname.text =
                                                                              suggestion['name'];
                                                                          log("contractornameid ${contractornameid}");
                                                                        },
                                                                        validator:
                                                                            (value) {
                                                                          if (value == "" ||
                                                                              value == null ||
                                                                              value.isEmpty) {
                                                                            return "Code is required, Please enter code";
                                                                          }
                                                                          return null;
                                                                        },
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
                                                                            if (editname.text.isEmpty) {
                                                                              ToastMsg(
                                                                                "Please enter Name",
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              var param = Map<String, dynamic>();
                                                                              param['date'] = txtController1.text;
                                                                              param['name'] = contractornameid;
                                                                              param['id'] = item['id'];
                                                                              var resData = await apiService.postCall('staff/editStaff', param);
                                                                              if (resData['success'] == 0) {
                                                                                ToastMsg(
                                                                                  resData['message'],
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                              init();
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
                                                        size: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              StatefulBuilder(builder:
                                                                  (BuildContext
                                                                          context,
                                                                      setState) {
                                                            return AlertDialog(
                                                              actionsPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              titlePadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title: Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 10,
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  child: Text(
                                                                    "Confirm Delete",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Century Gothic",
                                                                        fontSize:
                                                                            20),
                                                                  )),
                                                              content:
                                                                  Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 10,
                                                                  left: 10,
                                                                  right: 10,
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
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
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text("Cancel")),
                                                                          TextButton(
                                                                              onPressed: () async {
                                                                                var resData = await apiService.getcall(
                                                                                  'staff/delete/${item['id']}',
                                                                                );
                                                                                log("$resData");
                                                                                Navigator.pop(context);
                                                                                if (resData['sucess'] == 1) {
                                                                                  ToastMsg(
                                                                                    resData['message'],
                                                                                    15,
                                                                                    Colors.green,
                                                                                  );

                                                                                  init();
                                                                                } else {
                                                                                  ToastMsg(
                                                                                    resData['message'],
                                                                                    15,
                                                                                    Colors.red,
                                                                                  );
                                                                                  init();
                                                                                }
                                                                              },
                                                                              child: Text(
                                                                                "Yes",
                                                                                style: TextStyle(fontFamily: "Century Gothic", color: Colors.red),
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
                            )
                          ]))),
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
        );
      } else {
        return Scaffold(
          body: Stack(
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
                                      "Staff",
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
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
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
                        width: 50,
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
                                      query += 'user_id=${widget.user_id}';
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
                                          'http://89.116.229.150:3003/api/staff/downloadGetAllpdf?' +
                                              query);

                                      setState(() {
                                        isExportPdfLoader = false;
                                      });
                                      if (resData['success'] == 1) {
                                        openFile(
                                            url:
                                                'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                            filename:
                                                'StaffSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                      query += 'user_id=${widget.user_id}';
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
                                          'http://89.116.229.150:3003/api/staff/downloadGetAllExcel?' +
                                              query);

                                      setState(() {
                                        isExportExcelLoader = false;
                                      });
                                      if (resData['success'] == 1) {
                                        openFile(
                                            url:
                                                'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                            filename:
                                                'StaffSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                      child: Container(
                          padding: EdgeInsets.only(top: 30),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: ListView(children: [
                            SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 15, left: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Date",
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          if (userType == 2)
                                            Text(
                                              "Action",
                                              style: TextStyle(
                                                fontFamily: "Century Gothic",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
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
                                                top: 15, left: 10, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${item['date']}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Staff_NameDetail(
                                                            user_id:
                                                                item["user_id"],
                                                            name: item["name"],
                                                            refresh:
                                                                ((filters) {
                                                              init();
                                                            }),
                                                          ),
                                                        ));
                                                  },
                                                  child: Text(
                                                    "${item['staff_name']}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                if (userType == 2)
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          log("${item}");
                                                          editname.text = item[
                                                              'staff_name'];
                                                          txtController1.text =
                                                              item['date'];
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Staff Name'),
                                                                actions: <
                                                                    Widget>[
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            TextFormField(
                                                                          // readOnly:
                                                                          //     true,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Date',
                                                                          ),
                                                                          onTap:
                                                                              _selDatePicker5,
                                                                          controller:
                                                                              txtController1,
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
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        child: Autocomplete<
                                                                            String>(
                                                                          fieldViewBuilder: (context,
                                                                              textEditingController,
                                                                              focusNode,
                                                                              onEditingComplete) {
                                                                            textEditingController.text =
                                                                                item['staff_name'];
                                                                            return TextFormField(
                                                                              controller: textEditingController,
                                                                              focusNode: focusNode,
                                                                              onEditingComplete: onEditingComplete,
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a Name',
                                                                              ),
                                                                            );
                                                                          },
                                                                          optionsBuilder:
                                                                              (TextEditingValue textEditingValue) async {
                                                                            if (textEditingValue.text ==
                                                                                '') {
                                                                              return const Iterable<String>.empty();
                                                                            } else {
                                                                              List<String> serachdata = [];
                                                                              var param = Map<String, dynamic>();
                                                                              param['name'] = textEditingValue.text;
                                                                              param['user_id'] = item['user_id'];
                                                                              var resdata = await apiService.getUserSuggestion('staff/searchName', param);
                                                                              log('popopopopo${resdata}');
                                                                              searchUSer = resdata;
                                                                              for (var data in resdata) {
                                                                                serachdata.add(data['name']);
                                                                              }
                                                                              serachdata.retainWhere((s) {
                                                                                return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                                                              });
                                                                              return serachdata;
                                                                            }
                                                                          },
                                                                          onSelected:
                                                                              (dynamic suggestion) {
                                                                            log('You just selected $suggestion');
                                                                            var getid;
                                                                            getid =
                                                                                searchUSer.where((x) => x['name'].toLowerCase().contains(suggestion.toLowerCase())).toList();
                                                                            log("getid ${getid}");
                                                                            for (var item
                                                                                in getid) {
                                                                              if (item['name'] == suggestion) {
                                                                                contractornameid = item['id'];
                                                                              }
                                                                            }
                                                                            log('id : ${contractornameid}');
                                                                            editname.text =
                                                                                suggestion;
                                                                            log("Supplier ${editname.text}");
                                                                          },
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
                                                                            if (editname.text.isEmpty) {
                                                                              ToastMsg(
                                                                                "Please enter Name",
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              init();

                                                                              var param = Map<String, dynamic>();
                                                                              param['date'] = txtController1.text;
                                                                              param['name'] = contractornameid;
                                                                              param['id'] = item['id'];
                                                                              var resData = await apiService.postCall('staff/editStaff', param);
                                                                              if (resData['success'] == 0) {
                                                                                ToastMsg(
                                                                                  resData['message'],
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                              init();
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
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                StatefulBuilder(builder:
                                                                    (BuildContext
                                                                            context,
                                                                        setState) {
                                                              return AlertDialog(
                                                                actionsPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                titlePadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                title:
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets
                                                                                .only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Confirm Delete",
                                                                          style: TextStyle(
                                                                              fontFamily: "Century Gothic",
                                                                              fontSize: 20),
                                                                        )),
                                                                content:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 10,
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Text("are you sure you want to delete this?"),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("Cancel")),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  var resData = await apiService.getcall(
                                                                                    'staff/delete/${item['id']}',
                                                                                  );
                                                                                  log("$resData");
                                                                                  Navigator.pop(context);
                                                                                  init();

                                                                                  if (resData['sucess'] == 1) {
                                                                                    ToastMsg(
                                                                                      resData['message'],
                                                                                      15,
                                                                                      Colors.green,
                                                                                    );

                                                                                    init();
                                                                                  } else {
                                                                                    ToastMsg(
                                                                                      resData['message'],
                                                                                      15,
                                                                                      Colors.red,
                                                                                    );
                                                                                    init();
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  "Yes",
                                                                                  style: TextStyle(fontFamily: "Century Gothic", color: Colors.red),
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
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
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
                                ))
                          ]))),
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
