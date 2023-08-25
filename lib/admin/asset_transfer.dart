import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/admin/fromto.dart';
import 'package:abc_2_1/admin/receivedto.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Asset_Transfer extends StatefulWidget {
  Asset_Transfer({Key? key}) : super(key: key);

  @override
  State<Asset_Transfer> createState() => _Asset_TransferState();
}

class _Asset_TransferState extends State<Asset_Transfer>
    with TickerProviderStateMixin {
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

  final txtController = TextEditingController();
  late TabController _controller;
  int _selectedIndex = 0;
  var type = 1;
  var editcontractornameid = 0;
  var contractornameid = 0;
  final loginForm = GlobalKey<FormState>();
  late TextEditingController fromDateController;
  DateTime fromSelectedDate = DateTime.now();
  bool isExportPdfLoader = false;

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

  bool isExportExcelLoader = false;

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
  TextEditingController additemname = TextEditingController();
  TextEditingController addreceivername = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController additemmid = TextEditingController();
  TextEditingController editname = TextEditingController();

  bool loader = true;
  List data = [];
  List searchUSer = [];
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
      "assetTransfer?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&type=${_selectedIndex + 1}&user_id=${userid}",
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
                                            "Asset transfer",
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
                            TextButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Add Item',
                                        style: TextStyle(
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Column(
                                          children: [
                                            TextFormField(
                                              controller: additemname,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter Item";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Item',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.green[100],
                                                        onPrimary:
                                                            Colors.blue[900],
                                                      ),
                                                      onPressed: () async {
                                                        if (additemname
                                                            .text.isEmpty) {
                                                          ToastMsg(
                                                            "Please enter Item",
                                                            15,
                                                            Colors.red,
                                                          );
                                                        } else {
                                                          var param = Map<
                                                              String,
                                                              dynamic>();
                                                          param['name'] =
                                                              additemname.text;
                                                          param['user_id'] =
                                                              userid;
                                                          // param['id'] =
                                                          //     data['id'];
                                                          var resData =
                                                              await apiService
                                                                  .postCall(
                                                                      'assetTransfer/addItem',
                                                                      param);

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
                                                            ToastMsg(
                                                              resData[
                                                                  'message'],
                                                              15,
                                                              Colors.green,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Text("Save"),
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
                                                                    "assetTransfer/getName?user_id=${userid}");
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
                                                                                              title: const Text('Add Item'),
                                                                                              actions: <Widget>[
                                                                                                Column(
                                                                                                  children: [
                                                                                                    TextFormField(
                                                                                                      controller: editname,
                                                                                                      validator: (value) {
                                                                                                        if (value == null || value.isEmpty) {
                                                                                                          return "Please enter item";
                                                                                                        }
                                                                                                        return null;
                                                                                                      },
                                                                                                      decoration: InputDecoration(
                                                                                                        border: OutlineInputBorder(),
                                                                                                        hintText: 'Enter a item',
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
                                                                                                                    "Please enter item",
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
                                                                                                                  var resData = await apiService.postCall('assetTransfer/editName', data);
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
                                                                                          var resData = await apiService.postCall('assetTransfer/deleteName', data);
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
                                                )
                                              ],
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
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue[900],
                                    ),
                                    Text(
                                      "Add Item",
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
                                            query +=
                                                '&type=${_selectedIndex + 1}';
                                            log('query $query');
                                            setState(() {
                                              isExportPdfLoader = true;
                                            });
                                            var resData = await apiService.getCall(
                                                'http://89.116.229.150:3003/api/assetTransfer/downloadGetAllpdf?' +
                                                    query);

                                            setState(() {
                                              isExportPdfLoader = false;
                                            });
                                            if (resData['success'] == 1) {
                                              openFile(
                                                  url:
                                                      'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                  filename:
                                                      'assetTransfer${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                                'user_id=${userid.toString()}';
                                            // from_date=${txtController.text}&to_date=${txtController2.text}
                                            if (txtController.text != '') {
                                              query +=
                                                  '&from_date=${txtController.text}';
                                            }
                                            query +=
                                                '&type=${_selectedIndex + 1}';
                                            if (txtController2.text != '') {
                                              query +=
                                                  '&to_date=${txtController2.text}';
                                            }
                                            log('query $query');
                                            setState(() {
                                              isExportExcelLoader = true;
                                            });
                                            var resData = await apiService.getCall(
                                                'http://89.116.229.150:3003/api/assetTransfer/downloadGetAllExcel?' +
                                                    query);

                                            setState(() {
                                              isExportExcelLoader = false;
                                            });
                                            if (resData['success'] == 1) {
                                              openFile(
                                                  url:
                                                      'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                  filename:
                                                      'assetTransfer${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                child: Tab(text: "In Comming"),
                              ),
                            ),
                            Container(
                              child: Tab(text: "Out Going"),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              Fromto(data: labour),
                              Receivedto(data: labour),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (userType == 1)
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
                          setState(() {
                            additemname.text = '';
                            addreceivername.text = '';
                            qty.text = '';
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
                                                      ),
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
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "${_selectedIndex == 0 ? "Received" : "Sender"} Name",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Century Gothic",
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // width: 165,
                                                      margin: EdgeInsets.only(
                                                        left: 8,
                                                        right: 6,
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            addreceivername,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Receiver Name";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              '${_selectedIndex == 0 ? "Received" : "Sender"} Name',
                                                        ),
                                                      ),
                                                    ),
                                                    //  Container(
                                                    //     margin: EdgeInsets.only(
                                                    //       left: 10,
                                                    //       right: 10,
                                                    //     ),
                                                    //     child:
                                                    //         TypeAheadFormField(
                                                    //       textFieldConfiguration:
                                                    //           TextFieldConfiguration(
                                                    //         controller:
                                                    //             contractorname,
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
                                                    //             hintText: 'Enter Contactorname'),
                                                    //       ),
                                                    //       suggestionsCallback:
                                                    //           (pattern) async {
                                                    //         var data = Map<
                                                    //             String,
                                                    //             dynamic>();
                                                    //         data['name'] =
                                                    //             pattern;
                                                    //         return await apiService
                                                    //             .getUserSuggestion(
                                                    //                 'labour/searchContractorName',
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
                                                    //         contractornameid =
                                                    //             suggestion[
                                                    //                 'id'];
                                                    //         contractorname
                                                    //                 .text =
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
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "Item",
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
                                                      ),
                                                      child: TypeAheadFormField(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              additemname,
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
                                                              hintText: 'Enter Item'),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) async {
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['name'] =
                                                              pattern;
                                                          data['user_id'] =
                                                              userid;
                                                          return await apiService
                                                              .getUserSuggestion(
                                                                  'assetTransfer/searchItemName',
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
                                                          additemname.text =
                                                              suggestion[
                                                                  'name'];
                                                          additemmid.text =
                                                              suggestion['id']
                                                                  .toString();
                                                          log('${additemmid.text}');
                                                        },
                                                        validator: (value) {
                                                          if (value == "" ||
                                                              value == null ||
                                                              value.isEmpty) {
                                                            return "Item is required, Please enter Item";
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
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "Qty",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Century Gothic",
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // width: 165,
                                                      margin: EdgeInsets.only(
                                                        left: 8,
                                                        right: 6,
                                                      ),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller: qty,
                                                        // validator: (value) {
                                                        //   if (value == null ||
                                                        //       value.isEmpty) {
                                                        //     return "Please enter Qty";
                                                        //   }
                                                        //   return null;
                                                        // },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: 'Qty',
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
                                                            .spaceAround,
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
                                                                    data['qty'] =
                                                                        qty.text;
                                                                    data['item'] =
                                                                        additemmid
                                                                            .text;
                                                                    data['receivername'] =
                                                                        addreceivername
                                                                            .text;
                                                                    data['date'] =
                                                                        txtController3
                                                                            .text;
                                                                    data['user_id'] =
                                                                        userid
                                                                            .toString();
                                                                    data['type'] =
                                                                        _selectedIndex +
                                                                            1;
                                                                    print(data);
                                                                    var login =
                                                                        await apiService.postCall(
                                                                            'assetTransfer/addAsset',
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
                                                                      Date.text =
                                                                          '';
                                                                      additemname
                                                                          .text = '';
                                                                      addreceivername
                                                                          .text = '';
                                                                      qty.text =
                                                                          '';
                                                                      Navigator.pop(
                                                                          context);
                                                                      init();
                                                                    }
                                                                  }
                                                                },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 30,
                                                                    left: 30,
                                                                    top: 10,
                                                                    bottom: 10),
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
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 30,
                                                                    left: 30,
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Text(
                                                              "Close",
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
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Icon(
                                  Icons.arrow_back,
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
                                            "Asset transfer",
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
                            TextButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Add Item',
                                          style: TextStyle(
                                            fontFamily: "Century Gothic",
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: additemname,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter Item";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Item',
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      // width: MediaQuery.of(context)
                                                      //     .size
                                                      //     .width,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Colors.green[100],
                                                          onPrimary:
                                                              Colors.blue[900],
                                                        ),
                                                        onPressed: () async {
                                                          if (additemname
                                                              .text.isEmpty) {
                                                            ToastMsg(
                                                              "Please enter Item",
                                                              15,
                                                              Colors.red,
                                                            );
                                                          } else {
                                                            var param = Map<
                                                                String,
                                                                dynamic>();
                                                            param['name'] =
                                                                additemname
                                                                    .text;
                                                            param['user_id'] =
                                                                userid;
                                                            // param['id'] =
                                                            //     data['id'];
                                                            var resData =
                                                                await apiService
                                                                    .postCall(
                                                                        'assetTransfer/addItem',
                                                                        param);

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
                                                              ToastMsg(
                                                                resData[
                                                                    'message'],
                                                                15,
                                                                Colors.green,
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: Text("Save"),
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
                                                                      "assetTransfer/getName?user_id=${userid}");
                                                          log("${resData}");
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
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
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
                                                                                          // editcontractornameid = item['id'];
                                                                                          editname.text = item['name'];
                                                                                          showDialog<void>(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AlertDialog(
                                                                                                title: const Text('Add Item'),
                                                                                                actions: <Widget>[
                                                                                                  Column(
                                                                                                    children: [
                                                                                                      TextFormField(
                                                                                                        controller: editname,
                                                                                                        validator: (value) {
                                                                                                          if (value == null || value.isEmpty) {
                                                                                                            return "Please enter item";
                                                                                                          }
                                                                                                          return null;
                                                                                                        },
                                                                                                        decoration: InputDecoration(
                                                                                                          border: OutlineInputBorder(),
                                                                                                          hintText: 'Enter a item',
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
                                                                                                                      "Please enter item",
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
                                                                                                                    var resData = await apiService.postCall('assetTransfer/editName', data);
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
                                                                                            var resData = await apiService.postCall('assetTransfer/deleteName', data);
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
                                                  )
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
                                  Container(
                                    width: 110,
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
                                          "Add Item",
                                          style: TextStyle(
                                            color: Colors.blue[900],
                                            fontFamily: "Century Gothic",
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
                                        fontFamily: "Century Gothic",
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
                                            query +=
                                                '&type=${_selectedIndex + 1}';
                                            log('query $query');
                                            setState(() {
                                              isExportPdfLoader = true;
                                            });
                                            var resData = await apiService.getCall(
                                                'http://89.116.229.150:3003/api/assetTransfer/downloadGetAllpdf?' +
                                                    query);

                                            setState(() {
                                              isExportPdfLoader = false;
                                            });
                                            if (resData['success'] == 1) {
                                              openFile(
                                                  url:
                                                      'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                  filename:
                                                      'assetTransfer${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                                'user_id=${userid.toString()}';
                                            // from_date=${txtController.text}&to_date=${txtController2.text}
                                            if (txtController.text != '') {
                                              query +=
                                                  '&from_date=${txtController.text}';
                                            }
                                            query +=
                                                '&type=${_selectedIndex + 1}';
                                            if (txtController2.text != '') {
                                              query +=
                                                  '&to_date=${txtController2.text}';
                                            }
                                            log('query $query');
                                            setState(() {
                                              isExportExcelLoader = true;
                                            });
                                            var resData = await apiService.getCall(
                                                'http://89.116.229.150:3003/api/assetTransfer/downloadGetAllExcel?' +
                                                    query);

                                            setState(() {
                                              isExportExcelLoader = false;
                                            });
                                            if (resData['success'] == 1) {
                                              openFile(
                                                  url:
                                                      'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                  filename:
                                                      'assetTransfer${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                child: Tab(text: "In Comming"),
                              ),
                            ),
                            Container(
                              child: Tab(
                                text: "Out Going",
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              Fromto(data: labour),
                              Receivedto(data: labour),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (userType == 1)
                  Positioned(
                    right: 30,
                    bottom: 30,
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
                                minChildSize: 0.5,
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
                                                      ),
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
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "${_selectedIndex == 0 ? "Received" : "Sender"} Name",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
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
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            addreceivername,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Receiver Name";
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              '${_selectedIndex == 0 ? "Received" : "Sender"} Name',
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
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "Item",
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
                                                                userid;
                                                            var resdata =
                                                                await apiService
                                                                    .getUserSuggestion(
                                                                        'assetTransfer/searchItemName',
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
                                                              additemmid
                                                                  .text = item[
                                                                      'id']
                                                                  .toString();
                                                            }
                                                          }
                                                          log('id : ${additemmid.text}');
                                                          additemname.text =
                                                              suggestion;
                                                          log("Supplier ${additemname.text}");
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
                                                    //           additemname,
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
                                                    //           hintText: 'Enter Item'),
                                                    //     ),
                                                    //     suggestionsCallback:
                                                    //         (pattern) async {
                                                    // var data = Map<String,
                                                    //     dynamic>();
                                                    // data['name'] =
                                                    //     pattern;
                                                    // data['user_id'] =
                                                    //     userid;
                                                    //       return await apiService
                                                    //           .getUserSuggestion(
                                                    //               'assetTransfer/searchItemName',
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
                                                    //       additemname.text =
                                                    //           suggestion[
                                                    //               'name'];
                                                    //       additemmid.text =
                                                    //           suggestion['id']
                                                    //               .toString();
                                                    //       log('${additemmid.text}');
                                                    //     },
                                                    //     validator: (value) {
                                                    //       if (value == "" ||
                                                    //           value == null ||
                                                    //           value.isEmpty) {
                                                    //         return "Item is required, Please enter Item";
                                                    //       }
                                                    //       return null;
                                                    //     },
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
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        "Qty",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Century Gothic",
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
                                                      ),
                                                      child: TextFormField(
                                                        controller: qty,
                                                        // validator: (value) {
                                                        //   if (value == null ||
                                                        //       value.isEmpty) {
                                                        //     return "Please enter Qty";
                                                        //   }
                                                        //   return null;
                                                        // },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: 'Qty',
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
                                                            .spaceAround,
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
                                                                    data['qty'] =
                                                                        qty.text;
                                                                    data['item'] =
                                                                        additemmid
                                                                            .text;
                                                                    data['receivername'] =
                                                                        addreceivername
                                                                            .text;
                                                                    data['date'] =
                                                                        txtController3
                                                                            .text;
                                                                    data['user_id'] =
                                                                        userid
                                                                            .toString();
                                                                    data['type'] =
                                                                        _selectedIndex +
                                                                            1;
                                                                    print(data);
                                                                    var login =
                                                                        await apiService.postCall(
                                                                            'assetTransfer/addAsset',
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
                                                                      Date.text =
                                                                          '';
                                                                      additemname
                                                                          .text = '';
                                                                      addreceivername
                                                                          .text = '';
                                                                      qty.text =
                                                                          '';
                                                                      Navigator.pop(
                                                                          context);
                                                                      init();
                                                                    }
                                                                  }
                                                                },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 30,
                                                                    left: 30,
                                                                    top: 10,
                                                                    bottom: 10),
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
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 30,
                                                                    left: 30,
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child: Text(
                                                              "Close",
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
