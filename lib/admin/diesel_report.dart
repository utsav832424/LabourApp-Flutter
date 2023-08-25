import 'dart:developer';
import 'dart:io';
import 'package:abc_2_1/admin/diesel_report_vechicalno.dart';
import 'package:abc_2_1/admin/view.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class diesel_Report extends StatefulWidget {
  diesel_Report({Key? key}) : super(key: key);
  // final data;
  // final type;

  @override
  State<diesel_Report> createState() => _diesel_ReportState();
}

class _diesel_ReportState extends State<diesel_Report> {
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

  TextEditingController vechicalno = TextEditingController();
  TextEditingController vechicalno1 = TextEditingController();
  TextEditingController editPopvehicleno = TextEditingController();
  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  var totalused = 0;
  var incoming = 0;
  var yesterdaystock = 0;
  var totalstock = 0;
  bool isExportPdfLoader = false;
  var suggestsup;

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

  var token = "";
  var userid = 0;
  var userType = 0;
  late List diesel = [];
  List searchUSer = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();
  final txtController2 = TextEditingController();
  final txtController4 = TextEditingController();
  var dropdownValue = null;
  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    txtController3.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    txtController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    txtController2.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    init();
  }

  final now = DateFormat("yyyy-MM-dd").format(DateTime.now());

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
        "diesel?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}");
    log("${resData}");
    if (mounted) {
      setState(() {
        diesel = resData['data'];
        loader = false;
        totalused = resData['total_used'];
        incoming = resData['incoming'];
        // yesterdaystock = resData['yesterday'];
        totalstock = resData['total_stock'];
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
        init();
      });
    });
  }

  bool isExportExcelLoader = false;

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();

    var resData = await apiService.getcall(
        "diesel?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
  }

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();

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
                        Container(
                          width: MediaQuery.of(context).size.width - 140,
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
                        // if (userType == 1)
                        TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text('Add Diesel'),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 10,
                                                    right: 10,
                                                    left: 10),
                                                // padding: EdgeInsets.only(right: 10),
                                                // margin: EdgeInsets.only(
                                                //     top: 20, right: 10, left: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black54),
                                                ),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.grey[700],
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    // enabledBorder: InputBorder.none,
                                                  ),
                                                  value: dropdownValue,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                  ),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(
                                                      () {
                                                        dropdownValue =
                                                            newValue!;
                                                        log("${dropdownValue}");
                                                      },
                                                    );
                                                  },
                                                  items: <String>[
                                                    'Select',
                                                    'Diesel',
                                                    'Vehical No',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Text(
                                                              value,
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              if (dropdownValue == "Vehical No")
                                                Container(
                                                  // width: 165,
                                                  margin: EdgeInsets.only(
                                                      left: 8,
                                                      right: 6,
                                                      top: 10),
                                                  child: TextFormField(
                                                    controller: vechicalno,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Please enter No";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: 'Vechical No',
                                                    ),
                                                  ),
                                                ),
                                              if (dropdownValue == "Diesel")
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
                                              if (dropdownValue == "Diesel")
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 10),
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: 'Enter a Date',
                                                    ),
                                                    onTap: _selDatePicker3,
                                                    controller: txtController3,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Please enter Date";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              if (dropdownValue == "Diesel")
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              if (dropdownValue == "Diesel")
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "Qty Ltr",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // width: 165,
                                                      margin: EdgeInsets.only(
                                                          left: 8,
                                                          right: 6,
                                                          top: 10),
                                                      child: TextFormField(
                                                        controller: qtyltr,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Qty Ltr";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: 'Qty Ltr',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          if (dropdownValue == "Diesel")
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
                                                      init();
                                                      if (dropdownValue ==
                                                          "Vehical No") {
                                                        var data1 = Map<String,
                                                            dynamic>();
                                                        data1['user_id'] =
                                                            userid.toString();
                                                        data1['name'] =
                                                            vechicalno.text;
                                                        var resdata1 =
                                                            await apiService
                                                                .postCall(
                                                                    'diesel/createVehicleC',
                                                                    data1);
                                                        if (resdata1[
                                                                'success'] ==
                                                            0) {
                                                          ToastMsg(
                                                            resdata1['message'],
                                                            15,
                                                            Colors.red,
                                                          );
                                                        } else {
                                                          ToastMsg(
                                                            resdata1['message'],
                                                            15,
                                                            Colors.green,
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                      if (dropdownValue ==
                                                          "Diesel") {
                                                        var data = Map<String,
                                                            dynamic>();
                                                        data['date'] =
                                                            txtController3.text;
                                                        data['user_id'] =
                                                            userid.toString();
                                                        data['qty_ltr'] =
                                                            qtyltr.text;
                                                        var resData =
                                                            await apiService
                                                                .postCall(
                                                                    'diesel/addNewDiesel',
                                                                    data);
                                                        if (resData[
                                                                'success'] ==
                                                            0) {
                                                          ToastMsg(
                                                            resData['message'],
                                                            15,
                                                            Colors.red,
                                                          );
                                                        } else {
                                                          ToastMsg(
                                                            resData['message'],
                                                            15,
                                                            Colors.green,
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                    child: Text("Save"),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
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
                                                      if (dropdownValue ==
                                                          "Diesel") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        View1()));
                                                      }
                                                      if (dropdownValue ==
                                                          "Vehical No") {
                                                        var resData =
                                                            await apiService
                                                                .getcall(
                                                                    "diesel/getName?user_id=${userid}");
                                                        Navigator.pop(context);
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Name List'),
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
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
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
                                                                                        // editcontractornameid = item['id'];
                                                                                        // editcontactorname.text = item['name'];
                                                                                        showDialog<void>(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: const Text('Edit vehical No'),
                                                                                              actions: <Widget>[
                                                                                                Column(
                                                                                                  children: [
                                                                                                    // Container(
                                                                                                    //   // margin: EdgeInsets.only(
                                                                                                    //   //     left: 15, right: 15),
                                                                                                    //   decoration: BoxDecoration(
                                                                                                    //     borderRadius:
                                                                                                    //         BorderRadius.circular(10),
                                                                                                    //     color: Colors.white54,
                                                                                                    //   ),
                                                                                                    //   child: DropdownButtonFormField<
                                                                                                    //           String>(
                                                                                                    //       icon: Icon(
                                                                                                    //         Icons.keyboard_arrow_down,
                                                                                                    //         color: Colors.grey[700],
                                                                                                    //       ),
                                                                                                    //       hint: Text("Segment"),
                                                                                                    //       value: dropdownvalue2,
                                                                                                    //       style: TextStyle(
                                                                                                    //           fontFamily:
                                                                                                    //               "Century Gothic",
                                                                                                    //           color: Colors.grey[700]),
                                                                                                    //       onChanged:
                                                                                                    //           (String? newValue) async {
                                                                                                    //         setState(() {
                                                                                                    //           dropdownvalue2 = newValue!;
                                                                                                    //           _page = 0;
                                                                                                    //         });
                                                                                                    //         await init();
                                                                                                    //       },
                                                                                                    //       items: [
                                                                                                    //         for (var data in item)
                                                                                                    //           DropdownMenuItem<String>(
                                                                                                    //             value: data,
                                                                                                    //             child: Row(
                                                                                                    //               children: [
                                                                                                    //                 Container(
                                                                                                    //                   padding:
                                                                                                    //                       EdgeInsets.only(
                                                                                                    //                           left: 10),
                                                                                                    //                   child: Text(
                                                                                                    //                     "${data}",
                                                                                                    //                     style: TextStyle(
                                                                                                    //                       fontFamily:
                                                                                                    //                           "Century Gothic",
                                                                                                    //                     ),
                                                                                                    //                   ),
                                                                                                    //                 ),
                                                                                                    //               ],
                                                                                                    //             ),
                                                                                                    //           )
                                                                                                    //       ]),
                                                                                                    // ),
                                                                                                    TextFormField(
                                                                                                      controller: editPopvehicleno,
                                                                                                      validator: (value) {
                                                                                                        if (value == null || value.isEmpty) {
                                                                                                          return "Please enter Vehicle No";
                                                                                                        }
                                                                                                        return null;
                                                                                                      },
                                                                                                      decoration: InputDecoration(
                                                                                                        border: OutlineInputBorder(),
                                                                                                        hintText: 'Enter a Vechile No',
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
                                                                                                                if (editPopvehicleno.text.isEmpty) {
                                                                                                                  ToastMsg(
                                                                                                                    "Please enter Vechical No",
                                                                                                                    15,
                                                                                                                    Colors.red,
                                                                                                                  );
                                                                                                                } else {
                                                                                                                  ToastMsg(
                                                                                                                    "Data Added",
                                                                                                                    15,
                                                                                                                    Colors.green,
                                                                                                                  );
                                                                                                                  var data = Map<String, dynamic>();
                                                                                                                  data['name'] = editPopvehicleno.text;
                                                                                                                  data['user_id'] = userid.toString();
                                                                                                                  data['id'] = item['id'];
                                                                                                                  var resData = await apiService.postCall('diesel/editName', data);
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
                                                                                                                    editPopvehicleno.text = '';
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
                                                                                          var resData = await apiService.postCall('diesel/deleteName', data);
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
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                      // var data =
                                                      //     Map<String, dynamic>();
                                                      // data['date'] =
                                                      //     txtController3.text;
                                                      // data['user_id'] =
                                                      //     userid.toString();
                                                      // data['qty_ltr'] =
                                                      //     qtyltr.text;
                                                      // var resData =
                                                      //     await apiService.postCall(
                                                      //         'diesel/addNewDiesel',
                                                      //         data);
                                                      // if (resData['success'] ==
                                                      //     0) {
                                                      //   ToastMsg(
                                                      //     resData['message'],
                                                      //     15,
                                                      //     Colors.red,
                                                      //   );
                                                      // } else {
                                                      //   Navigator.pop(context);
                                                      // }
                                                    },
                                                    child: Text("View"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                              },
                            );
                            init();
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.blue[900],
                                ),
                                Text(
                                  "Add Dies",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontFamily: "Century Gothic",
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
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllpdf?' +
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
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllExcel?' +
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
                      child: Container(
                        padding: EdgeInsets.only(top: 30, bottom: 50),
                        margin: EdgeInsets.symmetric(horizontal: 5),
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
                                  86,
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
                                            "Vehicle Name",
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
                                            "Vehicle Number",
                                            textAlign: TextAlign.center,
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
                                          margin: EdgeInsets.only(top: 15),
                                          child: Text(
                                            "Driver",
                                            textAlign: TextAlign.center,
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
                                          margin: EdgeInsets.only(top: 15),
                                          child: Text(
                                            "Qty Ltr",
                                            textAlign: TextAlign.center,
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
                                              "${data['machinery']}",
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
                                                left: 35,
                                                bottom: 5,
                                                right: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Diesel_ReportVechicalno(
                                                        dvhical: data[
                                                            'vehiclenumber'],
                                                        machinery:
                                                            data['user_id'],
                                                      ),
                                                    ));
                                              },
                                              child: Text(
                                                "${data['vehiclenumber']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                ),
                                              ),
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
                                              "${data['driver']}",
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
                                                left: 30,
                                                bottom: 5,
                                                right: 5),
                                            child: Text(
                                              "${data['qty_ltr']}",
                                              style: TextStyle(
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
                                                                        Row(
                                                                          children: [
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
                                                                          ],
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
                          ],
                        ),
                      ),
                    ),
                  ],
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
                            Column(
                              children: [
                                Text(
                                  "Total used",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${totalused}",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "incoming",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${incoming}",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                                  "${totalstock}",
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
                    ],
                  ),
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
                                                      // readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker4,
                                                      controller:
                                                          txtController4,
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
                                                      "Vehicle Name",
                                                      style: TextStyle(
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
                                                      controller: machinery,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Vehicle Name";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Vehicle Name',
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
                                                      "Vehicle No",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: Container(
                                                      child: TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              vechicalno1,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  // borderRadius:
                                                                  //     BorderRadius.all(
                                                                  //   Radius.circular(30),
                                                                  // ),
                                                                  // borderSide:
                                                                  //     BorderSide.none,
                                                                  ),
                                                              hintStyle: TextStyle(color: Colors.grey),
                                                              // filled: true,
                                                              // fillColor: Colors.white,
                                                              hintText: 'Enter a Vechical No'),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) async {
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['name'] =
                                                              pattern;
                                                          data['user_id'] =
                                                              userid.toString();

                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'diesel/searchName',
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
                                                          suggestsup =
                                                              suggestion['id'];
                                                          vechicalno1.text =
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
                                                      "Driver",
                                                      style: TextStyle(
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
                                                      controller: driver,
                                                      validator: (value) {
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
                                                      "QTY LTR",
                                                      style: TextStyle(
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
                                                      controller: qty_ltr,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      // validator: (value) {
                                                      //   if (value == null ||
                                                      //       value.isEmpty) {
                                                      //     return "Please enter qty_ltr";
                                                      //   }
                                                      //   return null;
                                                      // },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Qty Ltr  ',
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
                                                                  data['machinery'] =
                                                                      machinery
                                                                          .text;
                                                                  data['vehiclenumber'] =
                                                                      vechicalno1
                                                                          .text;
                                                                  data['driver'] =
                                                                      driver
                                                                          .text;
                                                                  data['qty_ltr'] =
                                                                      qty_ltr
                                                                          .text;
                                                                  data['date'] =
                                                                      txtController4
                                                                          .text;

                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();
                                                                  data['isactive'] =
                                                                      "1";
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'diesel',
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
                                                                    machinery
                                                                        .text = '';
                                                                    vehiclenumber
                                                                        .text = '';
                                                                    driver.text =
                                                                        '';
                                                                    qty_ltr.text =
                                                                        '';

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
                        if (userType == 1)
                          TextButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('Add Diesel'),
                                      actions: <Widget>[
                                        Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10,
                                                      right: 10,
                                                      left: 10),
                                                  // padding: EdgeInsets.only(right: 10),
                                                  // margin: EdgeInsets.only(
                                                  //     top: 20, right: 10, left: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black54),
                                                  ),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.grey[700],
                                                    ),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      // enabledBorder: InputBorder.none,
                                                    ),
                                                    value: dropdownValue,
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                    ),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(
                                                        () {
                                                          dropdownValue =
                                                              newValue!;
                                                          log("${dropdownValue}");
                                                        },
                                                      );
                                                    },
                                                    items: <String>[
                                                      'Select',
                                                      'Diesel',
                                                      'Vehical No',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                value,
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                if (dropdownValue ==
                                                    "Vehical No")
                                                  Container(
                                                    // width: 165,
                                                    margin: EdgeInsets.only(
                                                        left: 8,
                                                        right: 6,
                                                        top: 10),
                                                    child: TextFormField(
                                                      controller: vechicalno,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter No";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: 'Vechical No',
                                                      ),
                                                    ),
                                                  ),
                                                if (dropdownValue == "Diesel")
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
                                                if (dropdownValue == "Diesel")
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
                                                if (dropdownValue == "Diesel")
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                if (dropdownValue == "Diesel")
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 10),
                                                        child: Text(
                                                          "Qty Ltr",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        // width: 165,
                                                        margin: EdgeInsets.only(
                                                            left: 8,
                                                            right: 6,
                                                            top: 10),
                                                        child: TextFormField(
                                                          controller: qtyltr,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Qty Ltr";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText: 'Qty Ltr',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            if (dropdownValue == "Diesel")
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
                                                        init();
                                                        if (dropdownValue ==
                                                            "Vehical No") {
                                                          var data1 = Map<
                                                              String,
                                                              dynamic>();
                                                          data1['user_id'] =
                                                              userid.toString();
                                                          data1['name'] =
                                                              vechicalno.text;
                                                          var resdata1 =
                                                              await apiService
                                                                  .postCall(
                                                                      'diesel/createVehicleC',
                                                                      data1);
                                                          if (resdata1[
                                                                  'success'] ==
                                                              0) {
                                                            ToastMsg(
                                                              resdata1[
                                                                  'message'],
                                                              15,
                                                              Colors.red,
                                                            );
                                                          } else {
                                                            ToastMsg(
                                                              resdata1[
                                                                  'message'],
                                                              15,
                                                              Colors.green,
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        }
                                                        if (dropdownValue ==
                                                            "Diesel") {
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['date'] =
                                                              txtController3
                                                                  .text;
                                                          data['user_id'] =
                                                              userid.toString();
                                                          data['qty_ltr'] =
                                                              qtyltr.text;
                                                          var resData =
                                                              await apiService
                                                                  .postCall(
                                                                      'diesel/addNewDiesel',
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
                                                            ToastMsg(
                                                              resData[
                                                                  'message'],
                                                              15,
                                                              Colors.green,
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        }
                                                      },
                                                      child: Text("Save"),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
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
                                                        if (dropdownValue ==
                                                            "Diesel") {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          View1()));
                                                        }
                                                        if (dropdownValue ==
                                                            "Vehical No") {
                                                          if (dropdownValue ==
                                                              "Vehical No") {
                                                            var resData =
                                                                await apiService
                                                                    .getcall(
                                                                        "diesel/getName?user_id=${userid}");
                                                            Navigator.pop(
                                                                context);
                                                            showDialog<void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Name List'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        for (var item
                                                                            in resData['data'])
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
                                                                                            // editcontractornameid = item['id'];
                                                                                            // editcontactorname.text = item['name'];
                                                                                            showDialog<void>(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                return AlertDialog(
                                                                                                  title: const Text('Edit vehical No'),
                                                                                                  actions: <Widget>[
                                                                                                    Column(
                                                                                                      children: [
                                                                                                        // Container(
                                                                                                        //   // margin: EdgeInsets.only(
                                                                                                        //   //     left: 15, right: 15),
                                                                                                        //   decoration: BoxDecoration(
                                                                                                        //     borderRadius:
                                                                                                        //         BorderRadius.circular(10),
                                                                                                        //     color: Colors.white54,
                                                                                                        //   ),
                                                                                                        //   child: DropdownButtonFormField<
                                                                                                        //           String>(
                                                                                                        //       icon: Icon(
                                                                                                        //         Icons.keyboard_arrow_down,
                                                                                                        //         color: Colors.grey[700],
                                                                                                        //       ),
                                                                                                        //       hint: Text("Segment"),
                                                                                                        //       value: dropdownvalue2,
                                                                                                        //       style: TextStyle(
                                                                                                        //           fontFamily:
                                                                                                        //               "Century Gothic",
                                                                                                        //           color: Colors.grey[700]),
                                                                                                        //       onChanged:
                                                                                                        //           (String? newValue) async {
                                                                                                        //         setState(() {
                                                                                                        //           dropdownvalue2 = newValue!;
                                                                                                        //           _page = 0;
                                                                                                        //         });
                                                                                                        //         await init();
                                                                                                        //       },
                                                                                                        //       items: [
                                                                                                        //         for (var data in item)
                                                                                                        //           DropdownMenuItem<String>(
                                                                                                        //             value: data,
                                                                                                        //             child: Row(
                                                                                                        //               children: [
                                                                                                        //                 Container(
                                                                                                        //                   padding:
                                                                                                        //                       EdgeInsets.only(
                                                                                                        //                           left: 10),
                                                                                                        //                   child: Text(
                                                                                                        //                     "${data}",
                                                                                                        //                     style: TextStyle(
                                                                                                        //                       fontFamily:
                                                                                                        //                           "Century Gothic",
                                                                                                        //                     ),
                                                                                                        //                   ),
                                                                                                        //                 ),
                                                                                                        //               ],
                                                                                                        //             ),
                                                                                                        //           )
                                                                                                        //       ]),
                                                                                                        // ),
                                                                                                        TextFormField(
                                                                                                          controller: editPopvehicleno,
                                                                                                          validator: (value) {
                                                                                                            if (value == null || value.isEmpty) {
                                                                                                              return "Please enter Vehicle No";
                                                                                                            }
                                                                                                            return null;
                                                                                                          },
                                                                                                          decoration: InputDecoration(
                                                                                                            border: OutlineInputBorder(),
                                                                                                            hintText: 'Enter a Vechile No',
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
                                                                                                                    if (editPopvehicleno.text.isEmpty) {
                                                                                                                      ToastMsg(
                                                                                                                        "Please enter Vechical No",
                                                                                                                        15,
                                                                                                                        Colors.red,
                                                                                                                      );
                                                                                                                    } else {
                                                                                                                      ToastMsg(
                                                                                                                        "Data Added",
                                                                                                                        15,
                                                                                                                        Colors.green,
                                                                                                                      );
                                                                                                                      var data = Map<String, dynamic>();
                                                                                                                      data['name'] = editPopvehicleno.text;
                                                                                                                      data['user_id'] = userid.toString();
                                                                                                                      data['id'] = item['id'];
                                                                                                                      var resData = await apiService.postCall('diesel/editName', data);
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
                                                                                                                        editPopvehicleno.text = '';
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
                                                                                              var resData = await apiService.postCall('diesel/deleteName', data);
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
                                                          }
                                                        }
                                                        // var data =
                                                        //     Map<String, dynamic>();
                                                        // data['date'] =
                                                        //     txtController3.text;
                                                        // data['user_id'] =
                                                        //     userid.toString();
                                                        // data['qty_ltr'] =
                                                        //     qtyltr.text;
                                                        // var resData =
                                                        //     await apiService.postCall(
                                                        //         'diesel/addNewDiesel',
                                                        //         data);
                                                        // if (resData['success'] ==
                                                        //     0) {
                                                        //   ToastMsg(
                                                        //     resData['message'],
                                                        //     15,
                                                        //     Colors.red,
                                                        //   );
                                                        // } else {
                                                        //   Navigator.pop(context);
                                                        // }
                                                      },
                                                      child: Text("View"),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                              init();
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.blue[900],
                                  ),
                                  Text(
                                    "Add Dies",
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontFamily: "Century Gothic",
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
                        // SizedBox(
                        //   width: 100,
                        // ),
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
                                          var resData = await apiService.getCall(
                                              'http://89.116.229.150:3003/api/diesel/downloadGetAllpdf?' +
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
                                            isExportExcelLoader = true;
                                          });
                                          var resData = await apiService.getCall(
                                              'http://89.116.229.150:3003/api/diesel/downloadGetAllExcel?' +
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
                        child: Container(
                          padding: EdgeInsets.only(top: 30),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: ListView(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Table(
                                  border: TableBorder(
                                      horizontalInside: BorderSide(
                                    color: Colors.grey,
                                  )),
                                  defaultColumnWidth: FixedColumnWidth(
                                    320,
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
                                              "Vehicle Name",
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
                                              "Vehicle Number",
                                              // textAlign: TextAlign.center,
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
                                                top: 15, left: 20),
                                            child: Text(
                                              "Driver",
                                              // textAlign: TextAlign.center,
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
                                              "Qty Ltr",
                                              // textAlign: TextAlign.center,
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
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black,
                                                    fontSize: 15),
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
                                                "${data['machinery']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 35,
                                                  bottom: 5,
                                                  right: 5),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Diesel_ReportVechicalno(
                                                          dvhical: data[
                                                              'vehiclenumber'],
                                                          machinery:
                                                              data['user_id'],
                                                        ),
                                                      ));
                                                },
                                                child: Text(
                                                  "${data['vehiclenumber']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
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
                                                "${data['driver']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 30,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['qty_ltr']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black,
                                                    fontSize: 15),
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
                                                            data[
                                                                'vehiclenumber'];
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
                                                                  child:
                                                                      ListView(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editvehiclename,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter vehiclename";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a vehiclename',
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
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Vehicle No";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Vehicle No',
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
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter driver";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a driver',
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
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                ElevatedButton(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                            Column(
                              children: [
                                Text(
                                  "Total used",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                                Text(
                                  totalused.toString(),
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "incoming",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${incoming}",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                                  "${totalstock}",
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
                    ],
                  ),
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
                        setState(() {
                          qty_ltr.text = "0";
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
                                                          fontSize: 15,
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
                                                      // readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker2,
                                                      controller:
                                                          txtController2,
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
                                                      "Vehicle Name",
                                                      style: TextStyle(
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
                                                      controller: machinery,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Vehicle Name";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Vehicle Name',
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
                                                      "Vehicle No",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    child: Autocomplete<String>(
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
                                                              serachdata = [];
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['name'] =
                                                              textEditingValue
                                                                  .text;
                                                          data['user_id'] =
                                                              userid.toString();
                                                          var resdata = await apiService
                                                              .getUserSuggestion(
                                                                  'diesel/searchName',
                                                                  data);
                                                          log('popopopopo${resdata}');
                                                          searchUSer = resdata;
                                                          for (var data
                                                              in resdata) {
                                                            serachdata.add(
                                                                data['name']);
                                                          }
                                                          // log('fghigh ${serachdata}');
                                                          // serachdata =
                                                          //     resdata[
                                                          //         'name'];
                                                          serachdata
                                                              .retainWhere((s) {
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
                                                      onSelected:
                                                          (dynamic suggestion) {
                                                        log('You just selected $suggestion');
                                                        var getid;
                                                        getid = searchUSer
                                                            .where((x) => x[
                                                                    'name']
                                                                .toLowerCase()
                                                                .contains(suggestion
                                                                    .toLowerCase()))
                                                            .toList();
                                                        log("getid ${getid}");
                                                        for (var item
                                                            in getid) {
                                                          if (item['name'] ==
                                                              suggestion) {
                                                            suggestsup =
                                                                item['id']
                                                                    .toString();
                                                          }
                                                        }
                                                        log('id : ${suggestsup}');
                                                        vechicalno1.text =
                                                            suggestion;
                                                        log("Supplier ${vechicalno1.text}");
                                                      },
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       left: 10,
                                                  //       right: 10,
                                                  //       top: 5),
                                                  //   child: Container(
                                                  //     child: TypeAheadFormField(
                                                  //       textFieldConfiguration:
                                                  //           TextFieldConfiguration(
                                                  //         controller:
                                                  //             vechicalno1,
                                                  //         decoration: InputDecoration(
                                                  //             border: OutlineInputBorder(
                                                  //                 // borderRadius:
                                                  //                 //     BorderRadius.all(
                                                  //                 //   Radius.circular(30),
                                                  //                 // ),
                                                  //                 // borderSide:
                                                  //                 //     BorderSide.none,
                                                  //                 ),
                                                  //             hintStyle: TextStyle(color: Colors.grey),
                                                  //             // filled: true,
                                                  //             // fillColor: Colors.white,
                                                  //             hintText: 'Enter a Vechical No'),
                                                  //       ),
                                                  //       suggestionsCallback:
                                                  //           (pattern) async {
                                                  // var data = Map<String,
                                                  //     dynamic>();
                                                  // data['name'] =
                                                  //     pattern;
                                                  // data['user_id'] =
                                                  //     userid.toString();

                                                  //         return await apiService
                                                  //             .getUserSuggestion(
                                                  //                 'diesel/searchName',
                                                  //                 data);
                                                  //       },
                                                  //       itemBuilder: (context,
                                                  //           dynamic
                                                  //               suggestion) {
                                                  //         return ListTile(
                                                  //           leading: Icon(
                                                  //               Icons.person),
                                                  //           title: Text(
                                                  //               suggestion[
                                                  //                   'name']),
                                                  //         );
                                                  //       },
                                                  //       onSuggestionSelected:
                                                  //           (dynamic
                                                  //               suggestion) {
                                                  //         suggestsup =
                                                  //             suggestion['id'];
                                                  //         vechicalno1.text =
                                                  //             suggestion[
                                                  //                 'name'];
                                                  //       },
                                                  //       validator: (value) {
                                                  //         if (value == "" ||
                                                  //             value == null ||
                                                  //             value.isEmpty) {
                                                  //           return "Code is required, Please enter code";
                                                  //         }
                                                  //         return null;
                                                  //       },
                                                  //     ),
                                                  //   ),
                                                  // ),
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
                                                      "Driver",
                                                      style: TextStyle(
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
                                                      controller: driver,
                                                      validator: (value) {
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
                                                      "QTY LTR",
                                                      style: TextStyle(
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
                                                      controller: qty_ltr,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      // validator: (value) {
                                                      //   if (value == null ||
                                                      //       value.isEmpty) {
                                                      //     return "Please enter qty_ltr";
                                                      //   }
                                                      //   return null;
                                                      // },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Qty Ltr  ',
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
                                                                init();

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
                                                                  data['machinery'] =
                                                                      machinery
                                                                          .text;
                                                                  data['vehiclenumber'] =
                                                                      vechicalno1
                                                                          .text;
                                                                  data['driver'] =
                                                                      driver
                                                                          .text;
                                                                  data['qty_ltr'] =
                                                                      qty_ltr
                                                                          .text;
                                                                  data['date'] =
                                                                      txtController2
                                                                          .text;

                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();
                                                                  data['isactive'] =
                                                                      "1";
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'diesel',
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
                                                                    machinery
                                                                        .text = '';
                                                                    vehiclenumber
                                                                        .text = '';
                                                                    driver.text =
                                                                        '';
                                                                    qty_ltr.text =
                                                                        '';

                                                                    Navigator.pop(
                                                                        context);
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
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontSize: 15,
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
