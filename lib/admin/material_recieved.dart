import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/admin/suppliername_material.dart';
import 'package:abc_2_1/admin/vehicaldetail.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Material_recieved extends StatefulWidget {
  Material_recieved({Key? key}) : super(key: key);

  @override
  State<Material_recieved> createState() => _Material_recievedState();
}

class _Material_recievedState extends State<Material_recieved> {
  Future openFile({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);

    if (file == null) return;

    OpenFile.open(file.path);
  }

  final now = DateFormat("yyyy-MM-dd").format(DateTime.now());

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
        // txtController.text = DateFormat.yMd().format(picke dDate);
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  TextEditingController suppliername = TextEditingController();
  TextEditingController material = TextEditingController();
  TextEditingController vehicle_no = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController challan_no = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController editmaterial = TextEditingController();
  TextEditingController editvehiclenumber = TextEditingController();
  TextEditingController editchallanno = TextEditingController();
  TextEditingController editqtyltr = TextEditingController();
  TextEditingController editunit = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  bool isExportPdfLoader = false;
  var dropdownvalue2 = null;
  List searchUSer = [];

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

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;
  var supliername;
  var vehicalno;
  TextEditingController vsplier = TextEditingController();
  var token = "";
  var userid = 0;
  var userType = 0;
  late List materials = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();
  List item = [];

  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
  var totalqty = 0;
  final txtController3 = TextEditingController();

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
    userType = prefs.getInt('type')!.toInt();
    setState(() {
      loader = true;
    });

    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "materials?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}");
    log("${resData}");
    if (mounted) {
      setState(() {
        materials = resData['data'];
        loader = false;
      });
    }
    var resData1 = await apiService.getcall(
        "materials/getTotalQty?from_date=${txtController.text}&to_date=${txtController2.text}&user_id=${userid}");
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
        txtController3.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall(
        "materials?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
  }

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
  bool isExportExcelLoader = false;
  String dropdownValue = 'Select';

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
                                        "Material Recieved",
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
                        if (userType == 1)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // dropdownValue = '';
                                namecontroller.text = '';
                              });
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Add supplier/ vehical Name'),
                                      actions: <Widget>[
                                        Column(
                                          children: [
                                            Container(
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
                                                            style: TextStyle(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
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
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: namecontroller,
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
                                                        if (namecontroller
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
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['user_id'] =
                                                              userid.toString();
                                                          data['name'] =
                                                              namecontroller
                                                                  .text;

                                                          data['type'] =
                                                              dropdownValue;
                                                          var resData =
                                                              await apiService
                                                                  .postCall(
                                                                      'materials/addMaterialName',
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
                                                                    "materials/getName?user_id=${userid}&type=${dropdownValue == 'Supplier Name' ? 1 : 2}");
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
                                                                                        editname.text = item['name'];
                                                                                        showDialog<void>(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: const Text('Add supplier/ vehical No'),
                                                                                              actions: <Widget>[
                                                                                                Column(
                                                                                                  children: [
                                                                                                    TextFormField(
                                                                                                      controller: editname,
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
                                                                                                                if (editname.text.isEmpty) {
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
                                                                                                                  var data = Map<String, dynamic>();
                                                                                                                  data['name'] = editname.text;
                                                                                                                  data['user_id'] = userid.toString();
                                                                                                                  data['id'] = item['id'].toString();
                                                                                                                  var resData = await apiService.postCall('materials/editName', data);
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
                                                                                          var resData = await apiService.postCall('materials/deleteName', data);
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
                                  readOnly: true,
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
                                            'http://89.116.229.150:3003/api/materials/downloadGetAllpdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                   'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'materialsR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                            'http://89.116.229.150:3003/api/materials/downloadGetAllExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'materialsR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                    100.0,
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
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Suppliername",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Material",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Qty",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Unit",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Vehicle No",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Challan No",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
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
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    for (var data in materials)
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Suppliername_Material(
                                                                supplierNameM: data[
                                                                    'supplier']),
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
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${data['material']}",
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         SContractorDetail(
                                                  //       contractor_id: data[
                                                  //           'contractorname_id'],
                                                  //       tabindex: 2,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          Vehicalno(
                                                              vehicalno: data[
                                                                  'vehicle']),
                                                    ),
                                                  );
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
                                                "${data['challan_no']}",
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
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // editname.text = data['name'];
                                                      editname.text =
                                                          data['suppliername'];
                                                      editmaterial.text =
                                                          data['material'];
                                                      editchallanno.text =
                                                          data['challan_no'];
                                                      editvehiclenumber.text =
                                                          data['vehicle_no'];
                                                      editunit.text =
                                                          data['unit'];
                                                      editqtyltr.text =
                                                          data['qty'];

                                                      showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Edit Supliername'),
                                                            actions: <Widget>[
                                                              Container(
                                                                height: 300,
                                                                child: ListView(
                                                                  children: [
                                                                    TextFormField(
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          editname,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter supliername";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter suplier name',
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextFormField(
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          editmaterial,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Material Name";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter Material Name',
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      controller:
                                                                          editqtyltr,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Qty";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter a Qty',
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
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Unit";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter a Unit',
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
                                                                        if (value ==
                                                                                null ||
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
                                                                          editchallanno,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter challan no";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter a Challan No',
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
                                                                            param['unit'] =
                                                                                editunit.text;
                                                                            param['vehicle_no'] =
                                                                                editvehiclenumber.text;
                                                                            param['challan_no'] =
                                                                                editchallanno.text;
                                                                            param['qty'] =
                                                                                editqtyltr.text;
                                                                            param['id'] =
                                                                                data['id'];
                                                                            var resData =
                                                                                await apiService.postCall('materials/editMaterial', param);
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
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
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
                                                    width: 15,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      // var data = Map<String, dynamic>();
                                                      // data['name'] = addcontactorname.text;
                                                      // data['user_id'] = userid.toString();
                                                      var resData =
                                                          await apiService
                                                              .getcall(
                                                        'materials/delete/${data['id']}',
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
                          // qty.text = '0';
                          // unit.text = '0';
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
                                                                FontWeight
                                                                    .bold),
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
                                                          fontSize: 15,
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
                                                              hintStyle: TextStyle(color: Colors.black),
                                                              // filled: true,
                                                              // fillColor: Colors.white,
                                                              hintText: 'Enter a suppliername'),
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
                                                          // log("${data}");
                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'materials/searchName',
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
                                                          supliername =
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
                                                        "Material Name",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      child: TextFormField(
                                                        controller: material,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter material";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter  material',
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
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
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
                                                          hintText:
                                                              'Enter a qty',
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
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        "Vehicle No",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child: TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller: vsplier,
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
                                                              hintText: 'Enter a Vehicle No'),
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
                                                                  'materials/searchName',
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
                                                          vehicalno =
                                                              suggestion['id'];
                                                          vsplier.text =
                                                              suggestion[
                                                                  'name'];
                                                        },
                                                        validator: (value) {
                                                          if (value == "" ||
                                                              value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Vehicle No";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   margin: EdgeInsets.only(
                                                    //       left: 10,
                                                    //       right: 10,
                                                    //       top: 5),
                                                    //   child: TextFormField(
                                                    //     controller: vehicle_no,
                                                    //     validator: (value) {
                                                    //       if (value == null ||
                                                    //           value.isEmpty) {
                                                    //         return "Please enter Vehicle No";
                                                    //       }
                                                    //       return null;
                                                    //     },
                                                    //     decoration:
                                                    //         InputDecoration(
                                                    //       border:
                                                    //           OutlineInputBorder(),
                                                    //       hintText:
                                                    //           'Enter a Vehicle No',
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
                                                        "Challan No",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      child: TextFormField(
                                                        controller: challan_no,
                                                        // validator: (value) {
                                                        //   if (value == null ||
                                                        //       value.isEmpty) {
                                                        //     return "Please enter Challan No";
                                                        //   }
                                                        //   return null;
                                                        // },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Challan No',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
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
                                                                    data['suppliername'] =
                                                                        supliername;
                                                                    data['material'] =
                                                                        material
                                                                            .text;
                                                                    data['vehicle_no'] =
                                                                        vehicalno;
                                                                    data['challan_no'] =
                                                                        challan_no
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
                                                                    var login =
                                                                        await apiService.postCall(
                                                                            'materials',
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
                                                                      suppliername
                                                                          .text = '';
                                                                      material.text =
                                                                          '';
                                                                      vehicle_no
                                                                          .text = '';
                                                                      challan_no
                                                                          .text = '';
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
                                                              fontSize: 15,
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
                                },
                              ),
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
                        ),
                      ),
                    ),
                  )
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
                                        "Material Recieved",
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
                        if (userType == 1)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // dropdownValue = '';
                                namecontroller.text = '';
                              });
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Add supplier/ vehical Name'),
                                      actions: <Widget>[
                                        Column(
                                          children: [
                                            Container(
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
                                                onChanged: (String? newValue) {
                                                  setState(
                                                    () {
                                                      dropdownValue = newValue!;
                                                    },
                                                  );
                                                },
                                                items: <String>[
                                                  'Select',
                                                  'Supplier Name',
                                                  'Vehical No',
                                                ].map<DropdownMenuItem<String>>(
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
                                                            style: TextStyle(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
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
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: namecontroller,
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
                                                        if (namecontroller
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
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['user_id'] =
                                                              userid.toString();
                                                          data['name'] =
                                                              namecontroller
                                                                  .text;

                                                          data['type'] =
                                                              dropdownValue;
                                                          var resData =
                                                              await apiService
                                                                  .postCall(
                                                                      'materials/addMaterialName',
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
                                                                    "materials/getName?user_id=${userid}&type=${dropdownValue == 'Supplier Name' ? 1 : 2}");
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
                                                                                        editname.text = item['name'];
                                                                                        showDialog<void>(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: const Text('Add supplier/ vehical No'),
                                                                                              actions: <Widget>[
                                                                                                Column(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      // padding: EdgeInsets.only(right: 10),
                                                                                                      // margin: EdgeInsets.only(
                                                                                                      //     top: 20, right: 10, left: 10),
                                                                                                      decoration: BoxDecoration(
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                        color: Colors.white,
                                                                                                        border: Border.all(color: Colors.black54),
                                                                                                      ),
                                                                                                      child: DropdownButtonFormField<String>(
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
                                                                                                            },
                                                                                                          );
                                                                                                        },
                                                                                                        items: <String>[
                                                                                                          'Select',
                                                                                                          'supplier Name',
                                                                                                          'Vehical No',
                                                                                                        ].map<DropdownMenuItem<String>>((String value) {
                                                                                                          return DropdownMenuItem<String>(
                                                                                                            value: value,
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                Container(
                                                                                                                  padding: EdgeInsets.only(left: 10),
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
                                                                                                      controller: editname,
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
                                                                                                                if (editname.text.isEmpty) {
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
                                                                                                                  var data = Map<String, dynamic>();
                                                                                                                  data['name'] = editname.text;
                                                                                                                  data['user_id'] = userid.toString();
                                                                                                                  data['id'] = item['id'].toString();
                                                                                                                  var resData = await apiService.postCall('materials/editName', data);
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
                                                                                          var resData = await apiService.postCall('materials/deleteName', data);
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
                                            'http://89.116.229.150:3003/api/materials/downloadGetAllpdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                   'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'materialsR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                            'http://89.116.229.150:3003/api/materials/downloadGetAllExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                   'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'materialsR${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                    195.0,
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
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Suppliername",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Material",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Qty",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Unit",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Vehicle No",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Challan No",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Century Gothic",
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
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    for (var data in materials)
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Suppliername_Material(
                                                                supplierNameM: data[
                                                                    'supplier']),
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
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "${data['material']}",
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         SContractorDetail(
                                                  //       contractor_id: data[
                                                  //           'contractorname_id'],
                                                  //       tabindex: 2,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          Vehicalno(
                                                              vehicalno: data[
                                                                  'vehicle']),
                                                    ),
                                                  );
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
                                                "${data['challan_no']}",
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
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // editname.text = data['name'];
                                                      editname.text =
                                                          data['suppliername'];
                                                      editmaterial.text =
                                                          data['material'];
                                                      editchallanno.text =
                                                          data['challan_no'];
                                                      editvehiclenumber.text =
                                                          data['vehicle_no'];
                                                      editunit.text =
                                                          data['unit'];
                                                      editqtyltr.text =
                                                          data['qty'];

                                                      showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Edit Supliername'),
                                                            actions: <Widget>[
                                                              Container(
                                                                height: 300,
                                                                child: ListView(
                                                                  children: [
                                                                    TextFormField(
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          editname,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter supliername";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter suplier name',
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextFormField(
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          editmaterial,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Material Name";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter Material Name',
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      controller:
                                                                          editqtyltr,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Qty";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter a Qty',
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
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Unit";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter a Unit',
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
                                                                        if (value ==
                                                                                null ||
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
                                                                          editchallanno,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter challan no";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter a Challan No',
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
                                                                            param['unit'] =
                                                                                editunit.text;
                                                                            param['vehicle_no'] =
                                                                                editvehiclenumber.text;
                                                                            param['challan_no'] =
                                                                                editchallanno.text;
                                                                            param['qty'] =
                                                                                editqtyltr.text;
                                                                            param['id'] =
                                                                                data['id'];
                                                                            var resData =
                                                                                await apiService.postCall('materials/editMaterial', param);
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
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
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
                                                    width: 15,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      // var data = Map<String, dynamic>();
                                                      // data['name'] = addcontactorname.text;
                                                      // data['user_id'] = userid.toString();
                                                      var resData =
                                                          await apiService
                                                              .getcall(
                                                        'materials/delete/${data['id']}',
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
                            Row(
                              children: [
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                          // qty.text = '0';
                          // unit.text = '0';
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
                                                                FontWeight
                                                                    .bold),
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
                                                          fontSize: 15,
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
                                                          Autocomplete<String>(
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
                                                            var data = Map<
                                                                String,
                                                                dynamic>();
                                                            data['name'] =
                                                                textEditingValue
                                                                    .text;
                                                            data['user_id'] =
                                                                userid
                                                                    .toString();
                                                            data['type'] = 1;

                                                            var resdata =
                                                                await apiService
                                                                    .getUserSuggestion(
                                                                        'materials/searchName',
                                                                        data);
                                                            // log('popopopopo${resdata}');
                                                            searchUSer =
                                                                resdata;
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
                                                          log('You just selected $suggestion');
                                                          var getid;
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
                                                            if (item['name'] ==
                                                                suggestion) {
                                                              supliername =
                                                                  item['id'];
                                                            }
                                                          }
                                                          log('id : ${supliername}');
                                                          suppliername.text =
                                                              suggestion;
                                                          log("Supplier ${suppliername.text}");
                                                        },
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   margin: EdgeInsets.only(
                                                    //     left: 10,
                                                    //     right: 10,
                                                    //   ),
                                                    //   child: TypeAheadFormField(
                                                    //     textFieldConfiguration:
                                                    //         TextFieldConfiguration(
                                                    //       controller:
                                                    //           suppliername,
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
                                                    //           hintText: 'Enter a suppliername'),
                                                    //     ),
                                                    //     suggestionsCallback:
                                                    //         (pattern) async {
                                                    //       var data = Map<String,
                                                    //           dynamic>();
                                                    //       data['name'] =
                                                    //           pattern;
                                                    //       data['user_id'] =
                                                    //           userid.toString();
                                                    //       data['type'] = 1;
                                                    //       return await apiService
                                                    //           .getUserSuggestion(
                                                    //               'materials/searchName',
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
                                                    //       supliername =
                                                    //           suggestion['id'];
                                                    //       suppliername.text =
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
                                                        "Material Name",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      child: TextFormField(
                                                        controller: material,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter material";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter  material',
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
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
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
                                                          hintText:
                                                              'Enter a qty',
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
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        "Vehicle No",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child:
                                                          Autocomplete<String>(
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
                                                            var data = Map<
                                                                String,
                                                                dynamic>();
                                                            data['name'] =
                                                                textEditingValue
                                                                    .text;
                                                            data['user_id'] =
                                                                userid
                                                                    .toString();
                                                            data['type'] = 2;

                                                            var resdata =
                                                                await apiService
                                                                    .getUserSuggestion(
                                                                        'materials/searchName',
                                                                        data);
                                                            // log('popopopopo${resdata}');
                                                            searchUSer =
                                                                resdata;
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
                                                          log('You just selected $suggestion');
                                                          var getid;
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
                                                            if (item['name'] ==
                                                                suggestion) {
                                                              vehicalno =
                                                                  item['id'];
                                                            }
                                                          }
                                                          log('id : ${vehicalno}');
                                                          vsplier.text =
                                                              suggestion;
                                                          log("Supplier ${vsplier.text}");
                                                        },
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   margin: EdgeInsets.only(
                                                    //     left: 10,
                                                    //     right: 10,
                                                    //   ),
                                                    //   child: TypeAheadFormField(
                                                    //     textFieldConfiguration:
                                                    //         TextFieldConfiguration(
                                                    //       controller: vsplier,
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
                                                    //           hintText: 'Enter a Vehicle No'),
                                                    //     ),
                                                    //     suggestionsCallback:
                                                    //         (pattern) async {
                                                    // var data = Map<String,
                                                    //     dynamic>();
                                                    // data['name'] =
                                                    //     pattern;
                                                    // data['user_id'] =
                                                    //     userid.toString();
                                                    // data['type'] = 2;
                                                    //       return await apiService
                                                    //           .getUserSuggestion(
                                                    //               'materials/searchName',
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
                                                    //       vehicalno =
                                                    //           suggestion['id'];
                                                    //       vsplier.text =
                                                    //           suggestion[
                                                    //               'name'];
                                                    //     },
                                                    //     validator: (value) {
                                                    //       if (value == "" ||
                                                    //           value == null ||
                                                    //           value.isEmpty) {
                                                    //         return "Please enter Vehicle No";
                                                    //       }
                                                    //       return null;
                                                    //     },
                                                    //   ),
                                                    // ),
                                                    // Container(
                                                    //   margin: EdgeInsets.only(
                                                    //       left: 10,
                                                    //       right: 10,
                                                    //       top: 5),
                                                    //   child: TextFormField(
                                                    //     controller: vehicle_no,
                                                    //     validator: (value) {
                                                    //       if (value == null ||
                                                    //           value.isEmpty) {
                                                    //         return "Please enter Vehicle No";
                                                    //       }
                                                    //       return null;
                                                    //     },
                                                    //     decoration:
                                                    //         InputDecoration(
                                                    //       border:
                                                    //           OutlineInputBorder(),
                                                    //       hintText:
                                                    //           'Enter a Vehicle No',
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
                                                        "Challan No",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Century Gothic",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                      child: TextFormField(
                                                        controller: challan_no,
                                                        // validator: (value) {
                                                        //   if (value == null ||
                                                        //       value.isEmpty) {
                                                        //     return "Please enter Challan No";
                                                        //   }
                                                        //   return null;
                                                        // },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Challan No',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
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
                                                                    data['suppliername'] =
                                                                        supliername;
                                                                    data['material'] =
                                                                        material
                                                                            .text;
                                                                    data['vehicle_no'] =
                                                                        vehicalno;
                                                                    data['challan_no'] =
                                                                        challan_no
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
                                                                    var login =
                                                                        await apiService.postCall(
                                                                            'materials',
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
                                                                      suppliername
                                                                          .text = '';
                                                                      material.text =
                                                                          '';
                                                                      vehicle_no
                                                                          .text = '';
                                                                      challan_no
                                                                          .text = '';
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
                                                              fontSize: 15,
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
                                },
                              ),
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
                        ),
                      ),
                    ),
                  )
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
