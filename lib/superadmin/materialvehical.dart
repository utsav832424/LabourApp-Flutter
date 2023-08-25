import 'dart:developer';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Materialvehical extends StatefulWidget {
  Materialvehical({Key? key, required this.vehicalno, required this.adminid})
      : super(key: key);
  final adminid;
  final vehicalno;

  @override
  State<Materialvehical> createState() => _MaterialvehicalState();
}

class _MaterialvehicalState extends State<Materialvehical> {
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

  TextEditingController txtController1 = TextEditingController();
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
  final txtController3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtController3.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
        "materials/getVehical?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${widget.adminid}&vehical=${widget.vehicalno}");
    log("${resData}");
    if (mounted) {
      setState(() {
        materials = resData['data']['data'];
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
  List searchUSer = [];
  var contractornameid;
  List materialUSer = [];
  var materialnameid;
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
                                                            namecontroller.text;

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
                                                              "materials/getName?user_id=${userid}&type=${dropdownValue}");
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
                                                                                                                data['id'] = item['id'].toString();
                                                                                                                var resData = await apiService.postCall('materials/editMaterial', data);
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
                                        query +=
                                            'user_id=${widget.adminid.toString()}';
                                        query +=
                                            '&vehical=${widget.vehicalno.toString()}';
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
                                            'http://89.116.229.150:3003/api/materials/downloadGetAllVehicalPdf?' +
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
                                        query +=
                                            'user_id=${widget.adminid.toString()}';
                                        query +=
                                            '&vehical=${widget.vehicalno.toString()}';
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
                                            'http://89.116.229.150:3003/api/materials/downloadGetAllVehicalExcel?' +
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
                                // padding: EdgeInsets.only(top: 30),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: SingleChildScrollView(
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
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "Date",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                                "Material",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
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
                                                "Challan No",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                                        editname.text = data[
                                                            'suppliername'];
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
                                                        txtController1.text =
                                                            data['date'];
                                                        contractornameid =
                                                            data['supplier'];
                                                        materialnameid =
                                                            data['vehicle'];
                                                        log("con : ${contractornameid}");
                                                        log("vechi : ${materialnameid}");
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Vechical Details'),
                                                              actions: <Widget>[
                                                                Container(
                                                                  height: 300,
                                                                  child:
                                                                      ListView(
                                                                    children: [
                                                                      Container(
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
                                                                              hintText: 'Enter a suppliername'),
                                                                        ),
                                                                        suggestionsCallback:
                                                                            (pattern) async {
                                                                          var param = Map<
                                                                              String,
                                                                              dynamic>();
                                                                          param['name'] =
                                                                              pattern;
                                                                          param['user_id'] =
                                                                              data["user_id"];

                                                                          param['type'] =
                                                                              1;
                                                                          // log("${param}");
                                                                          return await apiService.getUserSuggestion(
                                                                              'materials/searchName',
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
                                                                      TextFormField(
                                                                        // readOnly:
                                                                        //     true,
                                                                        controller:
                                                                            editmaterial,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return "Please enter Material";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          hintText:
                                                                              'Enter a Material',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
                                                                        // readOnly: true,
                                                                        controller:
                                                                            editqtyltr,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
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
                                                                          if (value == null ||
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
                                                                      TypeAheadFormField(
                                                                        textFieldConfiguration:
                                                                            TextFieldConfiguration(
                                                                          controller:
                                                                              editvehiclenumber,
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
                                                                          var param = Map<
                                                                              String,
                                                                              dynamic>();
                                                                          param['name'] =
                                                                              pattern;
                                                                          param['user_id'] =
                                                                              data["user_id"];

                                                                          param['type'] =
                                                                              2;
                                                                          // log("${param}");
                                                                          return await apiService.getUserSuggestion(
                                                                              'materials/searchName',
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
                                                                          materialnameid =
                                                                              suggestion['id'];
                                                                          editvehiclenumber.text =
                                                                              suggestion['name'];
                                                                          log("materialnameid ${materialnameid}");
                                                                        },
                                                                        validator:
                                                                            (value) {
                                                                          if (value == "" ||
                                                                              value == null ||
                                                                              value.isEmpty) {
                                                                            return "Enter Vehicle No";
                                                                          }
                                                                          return null;
                                                                        },
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
                                                                          if (value == null ||
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
                                                                            init();
                                                                            if (editname.text.isEmpty) {
                                                                              ToastMsg(
                                                                                "Please enter Name",
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              var param = Map<String, dynamic>();
                                                                              param['date'] = txtController1.text;
                                                                              param['suppliername'] = contractornameid;
                                                                              param['material'] = editmaterial.text;
                                                                              param['unit'] = editunit.text;
                                                                              param['vehicle_no'] = materialnameid;
                                                                              param['challan_no'] = editchallanno.text;
                                                                              param['qty'] = editqtyltr.text;
                                                                              param['id'] = data['id'];
                                                                              var resData = await apiService.postCall('materials/editMaterial', param);
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
                                                      width: 15,
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
                                                                                init();
                                                                                var resData = await apiService.getcall(
                                                                                  'materials/delete/${data['id']}',
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
                                        "Material Vechical",
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
                                    fontFamily: "Century Gothic",
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
                                      fontFamily: "Century Gothic",
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
                                              'user_id=${widget.adminid.toString()}';
                                          query +=
                                              '&vehical=${widget.vehicalno.toString()}';
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
                                              'http://89.116.229.150:3003/api/materials/downloadGetAllVehicalPdf?' +
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
                                              'user_id=${widget.adminid.toString()}';
                                          query +=
                                              '&vehical=${widget.vehicalno.toString()}';
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
                                              'http://89.116.229.150:3003/api/materials/downloadGetAllVehicalExcel?' +
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
                                // padding: EdgeInsets.only(top: 30),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    defaultColumnWidth: FixedColumnWidth(
                                      175.0,
                                    ),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Date",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Suppliername",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Material",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Qty",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Unit",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Vehicle No",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Challan No",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          if (userType == 2)
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Action",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 15,
                                                  ),
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
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${data['suppliername']}",
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${data['material']}",
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${data['qty']}",
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${data['unit']}",
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${data['vehicle_no']}",
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${data['challan_no']}",
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
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // editname.text = data['name'];
                                                        editname.text = data[
                                                            'suppliername'];
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
                                                        txtController1.text =
                                                            data['date'];
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Vechical'),
                                                              actions: <Widget>[
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
                                                                              data['suppliername'];
                                                                          return TextFormField(
                                                                            controller:
                                                                                textEditingController,
                                                                            focusNode:
                                                                                focusNode,
                                                                            onEditingComplete:
                                                                                onEditingComplete,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Name',
                                                                            ),
                                                                          );
                                                                        },
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                textEditingValue.text;
                                                                            param['user_id'] =
                                                                                data['user_id'];
                                                                            data['type'] =
                                                                                1;
                                                                            var resdata =
                                                                                await apiService.getUserSuggestion('materials/searchName', param);
                                                                            log('popopopopo${resdata}');
                                                                            searchUSer =
                                                                                resdata;
                                                                            for (var data
                                                                                in resdata) {
                                                                              serachdata.add(data['name']);
                                                                            }
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
                                                                    TextFormField(
                                                                      // readOnly:
                                                                      //     true,
                                                                      controller:
                                                                          editmaterial,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return "Please enter Material";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            'Enter  Material Name',
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextFormField(
                                                                      // readOnly: true,
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
                                                                    Container(
                                                                      child: Autocomplete<
                                                                          String>(
                                                                        fieldViewBuilder: (context,
                                                                            textEditingController,
                                                                            focusNode,
                                                                            onEditingComplete) {
                                                                          textEditingController.text =
                                                                              data['vehicle_no'];
                                                                          return TextFormField(
                                                                            controller:
                                                                                textEditingController,
                                                                            focusNode:
                                                                                focusNode,
                                                                            onEditingComplete:
                                                                                onEditingComplete,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Vehicle No"',
                                                                            ),
                                                                          );
                                                                        },
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                textEditingValue.text;
                                                                            param['user_id'] =
                                                                                data['user_id'];
                                                                            data['type'] =
                                                                                2;
                                                                            var resdata =
                                                                                await apiService.getUserSuggestion('materials/searchName', param);
                                                                            log('popopopopo${resdata}');
                                                                            materialUSer =
                                                                                resdata;
                                                                            for (var data
                                                                                in resdata) {
                                                                              serachdata.add(data['name']);
                                                                            }
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
                                                                          getid = materialUSer
                                                                              .where((x) => x['name'].toLowerCase().contains(suggestion.toLowerCase()))
                                                                              .toList();
                                                                          log("getid ${getid}");
                                                                          for (var item
                                                                              in getid) {
                                                                            if (item['name'] ==
                                                                                suggestion) {
                                                                              materialnameid = item['id'];
                                                                            }
                                                                          }
                                                                          log('id : ${materialnameid}');
                                                                          editvehiclenumber.text =
                                                                              suggestion;
                                                                          log("Supplier ${editvehiclenumber.text}");
                                                                        },
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
                                                                            param['date'] =
                                                                                txtController1.text;
                                                                            param['suppliername'] =
                                                                                contractornameid;
                                                                            param['vehicle_no'] =
                                                                                materialnameid;
                                                                            param['material'] =
                                                                                editmaterial.text;
                                                                            param['unit'] =
                                                                                editunit.text;
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
