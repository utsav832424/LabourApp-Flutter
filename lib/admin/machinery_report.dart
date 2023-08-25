import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/admin/machinarySupplier.dart';
import 'package:abc_2_1/admin/vehicalno.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Machinery_report extends StatefulWidget {
  Machinery_report({Key? key}) : super(key: key);

  @override
  State<Machinery_report> createState() => _Machinery_reportState();
}

class _Machinery_reportState extends State<Machinery_report> {
  var dropdownValue = null;
  Future openFile({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);

    if (file == null) return;

    OpenFile.open(file.path);
  }

  bool isExportExcelLoader = false;

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
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  TextEditingController suppliername = TextEditingController();
  TextEditingController vehicle = TextEditingController();
  TextEditingController vehicle_no = TextEditingController();
  TextEditingController operator = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController editsuppliername = TextEditingController();
  TextEditingController editvehicle = TextEditingController();
  TextEditingController editvehicleno = TextEditingController();
  TextEditingController editoperator = TextEditingController();
  TextEditingController editunit = TextEditingController();
  TextEditingController editqty = TextEditingController();
  TextEditingController popvehicleno = TextEditingController();
  TextEditingController editPopvehicleno = TextEditingController();
  TextEditingController vechicalsugg = TextEditingController();
  var suggestveh;
  var suggestsup;

  bool loader = true;
  List data = [];
  List searchUSer = [];
  late ScrollController _scrollController;
  final loginForm = GlobalKey<FormState>();
  bool isExportPdfLoader = false;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List machinery = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  final txtController2 = TextEditingController();
  final txtController3 = TextEditingController();
  var totalqty = 0;

  @override
  void initState() {
    super.initState();
    txtController3.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    txtController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    txtController2.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
    var resData = await apiService.getcall(
        "machinery?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}");
    log("${resData}");
    if (mounted) {
      setState(() {
        machinery = resData['data'];
        loader = false;
      });
    }

    var resData1 = await apiService.getcall(
        "machinery/getTotalQty?from_date=${txtController.text}&to_date=${txtController2.text}&user_id=${userid}");
    log("${resData1}");
    if (mounted) {
      setState(() {
        loader = false;
        totalqty = resData1['data'][0]['total_qty'];
        log("${totalqty}");
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
        txtController2.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "machinery?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
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

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
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
                                        "Machinery Report",
                                        style: TextStyle(
                                          fontFamily: "Century Gothic",
                                          fontSize: 15,
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
                        TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: dropdownValue == "Supplier Name"
                                        ? Text('Add  Supplier Name')
                                        : Text("Add Vehicle No"),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
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
                                            child:
                                                DropdownButtonFormField<String>(
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
                                              onChanged: (String? newValue) {
                                                setState(
                                                  () {
                                                    dropdownValue = newValue!;
                                                    log("${dropdownValue}");
                                                  },
                                                );
                                              },
                                              items: <String>[
                                                'Select',
                                                'Supplier Name',
                                                'Vehical No',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: popvehicleno,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter Vehicle No";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter a Vehicle No',
                                              labelText: 'Enter No',
                                            ),
                                          ),
                                          // Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.start,
                                          //     children: [
                                          //       Container(
                                          //         margin: EdgeInsets.only(
                                          //             top: 20, left: 10),
                                          //         child: Text(
                                          //           "Vehicle No",
                                          //           style: TextStyle(
                                          //               fontFamily:
                                          //                   "Century Gothic",
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         ),
                                          //       ),
                                          //       Container(
                                          //         margin: EdgeInsets.only(
                                          //             left: 10,
                                          //             right: 10,
                                          //             top: 5),
                                          //         child: Container(
                                          //           child: TypeAheadFormField(
                                          //             textFieldConfiguration:
                                          //                 TextFieldConfiguration(
                                          //               controller:
                                          //                   vechicalsugg,
                                          //               decoration: InputDecoration(
                                          //                   border: OutlineInputBorder(
                                          //                       // borderRadius:
                                          //                       //     BorderRadius.all(
                                          //                       //   Radius.circular(30),
                                          //                       // ),
                                          //                       // borderSide:
                                          //                       //     BorderSide.none,
                                          //                       ),
                                          //                   hintStyle: TextStyle(color: Colors.grey),
                                          //                   // filled: true,
                                          //                   // fillColor: Colors.white,
                                          //                   hintText: 'Enter a Vechical No'),
                                          //             ),
                                          //             suggestionsCallback:
                                          //                 (pattern) async {
                                          //               var data = Map<String,
                                          //                   dynamic>();
                                          //               data['name'] =
                                          //                   pattern;
                                          //               data['user_id'] =
                                          //                   userid.toString();
                                          //               data['type'] = 2;
                                          //               return await apiService
                                          //                   .getUserSuggestion(
                                          //                       'machinery/searchName',
                                          //                       data);
                                          //             },
                                          //             itemBuilder: (context,
                                          //                 dynamic
                                          //                     suggestion) {
                                          //               return ListTile(
                                          //                 leading: Icon(
                                          //                     Icons.person),
                                          //                 title: Text(
                                          //                     suggestion[
                                          //                         'name']),
                                          //               );
                                          //             },
                                          //             onSuggestionSelected:
                                          //                 (dynamic
                                          //                     suggestion) {
                                          //               suggestveh =
                                          //                   suggestion['id'];
                                          //               vechicalsugg.text =
                                          //                   suggestion[
                                          //                       'name'];
                                          //             },
                                          //             validator: (value) {
                                          //               if (value == "" ||
                                          //                   value == null ||
                                          //                   value.isEmpty) {
                                          //                 return "Code is required, Please enter code";
                                          //               }
                                          //               return null;
                                          //             },
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
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
                                                      if (popvehicleno
                                                          .text.isEmpty) {
                                                        ToastMsg(
                                                          "Please enter Vehicle No",
                                                          15,
                                                          Colors.red,
                                                        );
                                                      } else {
                                                        ToastMsg(
                                                          "Data Added",
                                                          15,
                                                          Colors.green,
                                                        );
                                                        var data = Map<String,
                                                            dynamic>();
                                                        data['name'] =
                                                            popvehicleno.text;
                                                        data['user_id'] =
                                                            userid.toString();
                                                        data['type'] =
                                                            dropdownValue;
                                                        var resData =
                                                            await apiService
                                                                .postCall(
                                                                    'machinery/addName',
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
                                                          popvehicleno.text =
                                                              '';
                                                          Navigator.pop(
                                                              context);
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
                                                          await apiService.getcall(
                                                              "machinery/getName?type=${dropdownValue == 'Supplier Name' ? 1 : 2}&user_id=${userid.toString()}");
                                                      log("${resData}");
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
                                                                          CrossAxisAlignment
                                                                              .start,
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
                                                                                                        return "Please enter Vechile No";
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
                                                                                                                var resData = await apiService.postCall('machinery/editName', data);
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
                                                                                        var resData = await apiService.postCall('machinery/deleteName', data);
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
                                });
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.blue[900],
                              ),
                              Text("Add")
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
                                  fontFamily: "Century Gothic",
                                  fontSize: 15,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
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
                              // GestureDetector(
                              //   onTap: _selDatePicker,
                              //   child: Text(
                              //     "23/12/2022",
                              //     style: TextStyle(
                              //         color: Colors.blue[900],
                              //         // fontWeight: FontWeight.bold,
                              //         fontSize: 16),
                              //   ),
                              // ),
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
                                            'http://89.116.229.150:3003/api/machinery/downloadGetAllpdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'MachineryR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                            'http://89.116.229.150:3003/api/machinery/downloadGetAllExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'MachineryR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                        padding: EdgeInsets.only(
                          top: 30,
                        ),
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
                                    ),
                                  ),
                                  defaultColumnWidth: FixedColumnWidth(
                                    85.0,
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Date",
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Suppliername",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Vehicle",
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Vehicle No",
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Operator",
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Unit",
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Qty",
                                              style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        if (userType == 2)
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "Action",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    for (var data in machinery)
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                "${data['date']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 20,
                                                  right: 5,
                                                  bottom: 5),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            machinarySupplier(
                                                                userid: data[
                                                                    'user_id'],
                                                                vecno: data[
                                                                    'suppliername1']),
                                                      ));
                                                },
                                                child: Text(
                                                  "${data['suppliername']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${data['vehicle']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VechileNo(
                                                                userid: data[
                                                                    'user_id'],
                                                                vecno: data[
                                                                    'vehicle2']),
                                                      ));
                                                },
                                                child: Text(
                                                  "${data['vehicle_no']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${data['operator']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${data['unit']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${data['qty']}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          if (userType == 2)
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        editsuppliername.text =
                                                            data[
                                                                'suppliername'];
                                                        editvehicle.text =
                                                            data['vehicle'];
                                                        editvehicleno.text =
                                                            data['vehicle_no'];
                                                        editoperator.text =
                                                            data['operator'];
                                                        editunit.text =
                                                            data['unit'];
                                                        editqty.text =
                                                            data['qty'];

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
                                                                                editsuppliername,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Suppliername";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Suppliername',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editvehicle,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Vehicle";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Vehicle',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editvehicleno,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Vehicle no";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Vehicle no',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editoperator,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Operator";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Operator',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editunit,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Unit";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Unit',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            controller:
                                                                                editqty,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Qty";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Qty',
                                                                            ),
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
                                                                                if (editsuppliername.text.isEmpty) {
                                                                                  ToastMsg(
                                                                                    "Please enter Name",
                                                                                    15,
                                                                                    Colors.red,
                                                                                  );
                                                                                } else {
                                                                                  var param = Map<String, dynamic>();
                                                                                  param['vehicle'] = editvehicle.text;
                                                                                  param['vehicle_no'] = editvehicleno.text;
                                                                                  param['operator'] = editoperator.text;
                                                                                  param['unit'] = editunit.text;
                                                                                  param['qty'] = editqty.text;
                                                                                  param['id'] = data['id'];
                                                                                  var resData = await apiService.postCall('machinery/editMachinery', param);
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
                                                                              child: Text(
                                                                                "Save",
                                                                                style: TextStyle(
                                                                                  fontFamily: "Century Gothic",
                                                                                ),
                                                                              ),
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
                                                    GestureDetector(
                                                      onTap: () async {
                                                        // var data = Map<String, dynamic>();
                                                        // data['name'] = addcontactorname.text;
                                                        // data['user_id'] = userid.toString();
                                                        var resData =
                                                            await apiService
                                                                .getcall(
                                                          'machinery/delete/${data['id']}',
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Total Qty",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                            SizedBox(
                              width: 80,
                            ),
                            Container(
                              child: Text(
                                "${totalqty}",
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
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          // unit.text = '0';
                          // qty.text = '0';
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
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker4,
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Suppliername",
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
                                                    child: Container(
                                                      child: TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              suppliername,
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
                                                          data['type'] = 1;
                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'machinery/searchName',
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
                                                          suppliername.text =
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
                                                      "Vehicle",
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
                                                      controller: vehicle,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter vehicle";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a vehicle',
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
                                                    child: Container(
                                                      child: TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              vechicalsugg,
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
                                                          data['type'] = 2;
                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'machinery/searchName',
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
                                                          suggestveh =
                                                              suggestion['id'];
                                                          vechicalsugg.text =
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
                                                      "Operator",
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
                                                      controller: operator,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter operator";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a operator',
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
                                                      "Unit",
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
                                                      controller: unit,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter unit";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a unit',
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
                                                      "QTY",
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
                                                      controller: qty,
                                                      // validator: (value) {
                                                      //   if (value == null ||
                                                      //       value.isEmpty) {
                                                      //     return "Please enter qty";
                                                      //   }
                                                      //   return null;
                                                      // },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: 'Enter a qty',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(
                                              //   height: 20,
                                              // ),
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
                                                                  data['suppliername'] =
                                                                      suggestsup;
                                                                  data['vehicle'] =
                                                                      vehicle
                                                                          .text;
                                                                  data['vehicle_no'] =
                                                                      suggestveh;
                                                                  data['operator'] =
                                                                      operator
                                                                          .text;
                                                                  data['unit'] =
                                                                      unit.text;
                                                                  data['qty'] =
                                                                      qty.text;
                                                                  data['date'] =
                                                                      txtController3
                                                                          .text;
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();
                                                                  data['isactive'] =
                                                                      "1";

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'machinery',
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
                                                                    suppliername
                                                                        .text = '';
                                                                    vehicle.text =
                                                                        '';
                                                                    vehicle_no
                                                                        .text = '';
                                                                    operator.text =
                                                                        '';
                                                                    unit.text =
                                                                        '';
                                                                    qty.text =
                                                                        '';

                                                                    Navigator.pop(
                                                                        context);
                                                                    init();
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
                                        "Machinery Report",
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
                                    // init();
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
                        TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: dropdownValue == "Supplier Name"
                                        ? Text('Add  Supplier Name')
                                        : Text("Add Vehicle No"),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
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
                                            child:
                                                DropdownButtonFormField<String>(
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
                                              onChanged: (String? newValue) {
                                                setState(
                                                  () {
                                                    dropdownValue = newValue!;
                                                    log("${dropdownValue}");
                                                  },
                                                );
                                              },
                                              items: <String>[
                                                'Select',
                                                'Supplier Name',
                                                'Vehical No',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: popvehicleno,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter Vehicle No";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter a Vehicle No',
                                              labelText: 'Enter No',
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
                                                      if (popvehicleno
                                                          .text.isEmpty) {
                                                        ToastMsg(
                                                          "Please enter Vehicle No",
                                                          15,
                                                          Colors.red,
                                                        );
                                                      } else {
                                                        ToastMsg(
                                                          "Data Added",
                                                          15,
                                                          Colors.green,
                                                        );
                                                        var data = Map<String,
                                                            dynamic>();
                                                        data['name'] =
                                                            popvehicleno.text;
                                                        data['user_id'] =
                                                            userid.toString();
                                                        data['type'] =
                                                            dropdownValue;
                                                        var resData =
                                                            await apiService
                                                                .postCall(
                                                                    'machinery/addName',
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
                                                          popvehicleno.text =
                                                              '';
                                                          Navigator.pop(
                                                              context);
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
                                                          await apiService.getcall(
                                                              "machinery/getName?type=${dropdownValue == 'Supplier Name' ? 1 : 2}&user_id=${userid.toString()}");
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
                                                                          CrossAxisAlignment
                                                                              .start,
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
                                                                                                        return "Please enter Vechile No";
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
                                                                                                                var resData = await apiService.postCall('machinery/editName', data);
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
                                                                                        var resData = await apiService.postCall('machinery/deleteName', data);
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
                                });
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.blue[900],
                              ),
                              Text("Add")
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
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
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Container(
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
                        ),
                        SizedBox(
                          width: 50,
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
                                              'http://89.116.229.150:3003/api/machinery/downloadGetAllpdf?' +
                                                  query);

                                          setState(() {
                                            isExportPdfLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                    'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'MachineryR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                              'http://89.116.229.150:3003/api/machinery/downloadGetAllExcel?' +
                                                  query);

                                          setState(() {
                                            isExportExcelLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                    'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'MachineryR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                    //             // GestureDetector(
                    //             //   onTap: _selDatePicker,
                    //             //   child: Text(
                    //             //     "23/12/2022",
                    //             //     style: TextStyle(
                    //             //         color: Colors.blue[900],
                    //             //         // fontWeight: FontWeight.bold,
                    //             //         fontSize: 16),
                    //             //   ),
                    //             // ),
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
                                padding: EdgeInsets.only(top: 30),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Table(
                                      border: TableBorder(
                                          horizontalInside: BorderSide(
                                        color: Colors.grey,
                                      )),
                                      defaultColumnWidth: FixedColumnWidth(
                                        220.0,
                                      ),
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Suppliername",
                                                  // textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Vehicle",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Vehicle No",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Operator",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Unit",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "Qty",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            if (userType == 2)
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Action",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        for (var data in machinery)
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "${data['date']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            left: 20,
                                                            right: 5,
                                                            bottom: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  machinarySupplier(
                                                                      userid: data[
                                                                          'user_id'],
                                                                      vecno: data[
                                                                          'suppliername1']),
                                                            ));
                                                      },
                                                      child: Text(
                                                        "${data['suppliername']}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontSize: 15),
                                                      ),
                                                    )),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "${data['vehicle']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                VechileNo(
                                                                    userid: data[
                                                                        'user_id'],
                                                                    vecno: data[
                                                                        'vehicle2']),
                                                          ));
                                                    },
                                                    child: Text(
                                                      "${data['vehicle_no']}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "Century Gothic",
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "${data['operator']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "${data['unit']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "${data['qty']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              if (userType == 2)
                                                TableCell(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              editsuppliername
                                                                      .text =
                                                                  data[
                                                                      'suppliername'];
                                                              editvehicle.text =
                                                                  data[
                                                                      'vehicle'];
                                                              editvehicleno
                                                                      .text =
                                                                  data[
                                                                      'vehicle_no'];
                                                              editoperator
                                                                      .text =
                                                                  data[
                                                                      'operator'];
                                                              editunit.text =
                                                                  data['unit'];
                                                              editqty.text =
                                                                  data['qty'];

                                                              showDialog<void>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Edit Contactor Name'),
                                                                    actions: <
                                                                        Widget>[
                                                                      Container(
                                                                        height:
                                                                            300,
                                                                        child:
                                                                            ListView(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                TextFormField(
                                                                                  // readOnly: true,
                                                                                  controller: editsuppliername,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Please enter Suppliername";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    hintText: 'Enter a Suppliername',
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                TextFormField(
                                                                                  // readOnly: true,
                                                                                  controller: editvehicle,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Please enter Vehicle";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    hintText: 'Enter a Vehicle',
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                TextFormField(
                                                                                  // readOnly: true,
                                                                                  controller: editvehicleno,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Please enter Vehicle no";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    hintText: 'Enter a Vehicle no',
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                TextFormField(
                                                                                  // readOnly: true,
                                                                                  controller: editoperator,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Please enter Operator";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    hintText: 'Enter a Operator',
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                TextFormField(
                                                                                  // readOnly: true,
                                                                                  controller: editunit,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Please enter Unit";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    hintText: 'Enter a Unit',
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                TextFormField(
                                                                                  // readOnly: true,
                                                                                  controller: editqty,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Please enter Qty";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    border: OutlineInputBorder(),
                                                                                    hintText: 'Enter a Qty',
                                                                                  ),
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
                                                                                      if (editsuppliername.text.isEmpty) {
                                                                                        ToastMsg(
                                                                                          "Please enter Name",
                                                                                          15,
                                                                                          Colors.red,
                                                                                        );
                                                                                      } else {
                                                                                        var param = Map<String, dynamic>();
                                                                                        param['vehicle'] = editvehicle.text;
                                                                                        param['vehicle_no'] = editvehicleno.text;
                                                                                        param['operator'] = editoperator.text;
                                                                                        param['unit'] = editunit.text;
                                                                                        param['qty'] = editqty.text;
                                                                                        param['id'] = data['id'];
                                                                                        var resData = await apiService.postCall('machinery/editMachinery', param);
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
                                                                                    child: Text(
                                                                                      "Save",
                                                                                      style: TextStyle(
                                                                                        fontFamily: "Century Gothic",
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
                                                          GestureDetector(
                                                            onTap: () async {
                                                              // var data = Map<String, dynamic>();
                                                              // data['name'] = addcontactorname.text;
                                                              // data['user_id'] = userid.toString();
                                                              var resData =
                                                                  await apiService
                                                                      .getcall(
                                                                'machinery/delete/${data['id']}',
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
                                                      )),
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
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Total Qty",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                            SizedBox(
                              width: 80,
                            ),
                            Container(
                              child: Text(
                                "${totalqty}",
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
                          // qty.text = "0";
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
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker3,
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
                                                      "Suppliername",
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
                                                          data['type'] = 1;
                                                          var resdata = await apiService
                                                              .getUserSuggestion(
                                                                  'machinery/searchName',
                                                                  data);
                                                          // log('popopopopo${resdata}');
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
                                                                item['id'];
                                                          }
                                                        }
                                                        log('id : ${suggestsup}');
                                                        suppliername.text =
                                                            suggestion;
                                                        log("Supplier ${suppliername.text}");
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
                                                  //             suppliername,
                                                  //         decoration: InputDecoration(
                                                  //             border: OutlineInputBorder(
                                                  //                 // borderRadius:
                                                  //                 //     BorderRadius.all(
                                                  //                 //   Radius.circular(30),
                                                  //                 // ),
                                                  //                 // borderSide:
                                                  //                 //     BorderSide.none,
                                                  //                 ),
                                                  //             hintStyle: TextStyle(color: Colors.black),
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
                                                  // data['type'] = 1;
                                                  //         return await apiService
                                                  //             .getUserSuggestion(
                                                  //                 'machinery/searchName',
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
                                                  //         suppliername.text =
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
                                              //  Container(
                                              //       margin: EdgeInsets.only(
                                              //         left: 10,
                                              //         right: 10,
                                              //       ),
                                              //       child:
                                              //           TypeAheadFormField(
                                              //         textFieldConfiguration:
                                              //             TextFieldConfiguration(
                                              //           controller:
                                              //               suppliername,
                                              //           decoration: InputDecoration(
                                              //               border: OutlineInputBorder(
                                              //                   // borderRadius:
                                              //                   //     BorderRadius.all(
                                              //                   //   Radius.circular(30),
                                              //                   // ),
                                              //                   // borderSide:
                                              //                   //     BorderSide.none,
                                              //                   ),
                                              //               hintStyle: TextStyle(color: Colors.black),
                                              //               // filled: true,
                                              //               // fillColor: Colors.white,
                                              //               hintText: 'Enter a suppliername'),
                                              //         ),
                                              //         suggestionsCallback:
                                              //             (pattern) async {
                                              //           var data = Map<
                                              //               String,
                                              //               dynamic>();
                                              //           data['name'] =
                                              //               pattern;
                                              //           return await apiService
                                              //               .getUserSuggestion(
                                              //                   'labour/searchContractorName',
                                              //                   data);
                                              //         },
                                              //         itemBuilder: (context,
                                              //             dynamic
                                              //                 suggestion) {
                                              //           return ListTile(
                                              //             leading: Icon(
                                              //                 Icons.person),
                                              //             title: Text(
                                              //                 suggestion[
                                              //                     'name']),
                                              //           );
                                              //         },
                                              //         onSuggestionSelected:
                                              //             (dynamic
                                              //                 suggestion) {
                                              //           suppliername =
                                              //               suggestion[
                                              //                   'id'];
                                              //           suppliername
                                              //                   .text =
                                              //               suggestion[
                                              //                   'name'];
                                              //         },
                                              //         validator: (value) {
                                              //           if (value == "" ||
                                              //               value == null ||
                                              //               value.isEmpty) {
                                              //             return "Code is required, Please enter code";
                                              //           }
                                              //           return null;
                                              //         },
                                              //       ),
                                              //     ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20, left: 10),
                                                    child: Text(
                                                      "Vehicle",
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
                                                      controller: vehicle,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter vehicle";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a vehicle',
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
                                                          data['type'] = 2;
                                                          var resdata = await apiService
                                                              .getUserSuggestion(
                                                                  'machinery/searchName',
                                                                  data);
                                                          // log('popopopopo${resdata}');
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
                                                            suggestveh =
                                                                item['id'];
                                                          }
                                                        }
                                                        log('id : ${suggestveh}');
                                                        vechicalsugg.text =
                                                            suggestion;
                                                        log("Supplier ${vechicalsugg.text}");
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
                                                  //             vechicalsugg,
                                                  //         decoration: InputDecoration(
                                                  //             border: OutlineInputBorder(
                                                  //                 // borderRadius:
                                                  //                 //     BorderRadius.all(
                                                  //                 //   Radius.circular(30),
                                                  //                 // ),
                                                  //                 // borderSide:
                                                  //                 //     BorderSide.none,
                                                  //                 ),
                                                  //             hintStyle: TextStyle(color: Colors.black),
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
                                                  // data['type'] = 2;
                                                  //         return await apiService
                                                  //             .getUserSuggestion(
                                                  //                 'machinery/searchName',
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
                                                  //         suggestveh =
                                                  //             suggestion['id'];
                                                  //         vechicalsugg.text =
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
                                                      "Operator",
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
                                                      controller: operator,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter operator";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a operator',
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
                                                      "Unit",
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
                                                      controller: unit,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter unit";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a unit',
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
                                                      "QTY",
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
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller: qty,
                                                      // validator: (value) {
                                                      //   if (value == null ||
                                                      //       value.isEmpty) {
                                                      //     return "Please enter qty";
                                                      //   }
                                                      //   return null;
                                                      // },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: 'Enter a qty',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // SizedBox(
                                              //   height: 20,
                                              // ),
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
                                                                  data['suppliername'] =
                                                                      suggestsup;
                                                                  data['vehicle'] =
                                                                      vehicle
                                                                          .text;
                                                                  data['vehicle_no'] =
                                                                      suggestveh;
                                                                  data['operator'] =
                                                                      operator
                                                                          .text;
                                                                  data['unit'] =
                                                                      unit.text;
                                                                  data['qty'] =
                                                                      qty.text;
                                                                  data['date'] =
                                                                      txtController2
                                                                          .text;
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();
                                                                  data['isactive'] =
                                                                      "1";

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'machinery',
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
                                                                    suppliername
                                                                        .text = '';
                                                                    vehicle.text =
                                                                        '';
                                                                    vehicle_no
                                                                        .text = '';
                                                                    operator.text =
                                                                        '';
                                                                    unit.text =
                                                                        '';
                                                                    qty.text =
                                                                        '';

                                                                    Navigator.pop(
                                                                        context);
                                                                    init();
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
