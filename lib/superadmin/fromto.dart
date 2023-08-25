import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/fromreceiver.dart';
import 'package:abc_2_1/superadmin/fromtodetail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SFromto extends StatefulWidget {
  SFromto(
      {Key? key, required this.data, required this.type, required this.refresh})
      : super(key: key);
  final data;
  final type;
  final void Function(Map<String, dynamic> filters) refresh;
  @override
  State<SFromto> createState() => _SFromtoState();
}

class _SFromtoState extends State<SFromto> {
  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  late TextEditingController fromDateController;
  DateTime fromSelectedDate = DateTime.now();

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
  TextEditingController editcontractorname = TextEditingController();
  TextEditingController editreceivername = TextEditingController();
  TextEditingController editqty = TextEditingController();
  TextEditingController items1 = TextEditingController();
  TextEditingController items2 = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  List searchUSer = [];
  var contractornameid;
  List materialUSer = [];
  var materialnameid;
  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List labour = [];
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

  init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token').toString();
    userid = prefs.getInt('user_id')!.toInt();
    userType = prefs.getInt('type')!.toInt();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Table(
                  border: TableBorder(
                      horizontalInside: BorderSide(
                    color: Colors.grey,
                  )),
                  columnWidths: {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "${widget.type == 1 ? 'Admin' : 'CONTRACTOR NAME'}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              child: Text(
                                "DATE",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20),
                              child: Text(
                                "${widget.type == 1 ? 'Admin' : 'Receiver Name'} ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Item",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Qty",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Action",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    for (var item in widget.data)
                      TableRow(children: [
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              onTap: widget.type == 1
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FromtoDetail(
                                                user_id: item['user_id']),
                                          ));
                                    }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 32),
                                child: Text(
                                  "${widget.type == 1 ? item['sitename'] : item['receivername']} ",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['date']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Fromreceiver(
                                        refresh: (filters) {
                                          if (filters['refresh']) {
                                            init();
                                          }
                                        },
                                        name:
                                            "${widget.type == 1 ? item['sitename'] : item['receivername']} ",
                                        id: item["user_id"]),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 32),
                                child: Text(
                                  "${widget.type == 1 ? item['sitename'] : item['receivername']} ",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['name']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['qty']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    log("${item}");
                                    editreceivername.text =
                                        item['receivername'];
                                    editqty.text = item['qty'].toString();
                                    txtController1.text = item['date'];
                                    items2.text = item['name'];
                                    contractornameid = item['item'];
                                    log("con : ${contractornameid}");
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Edit From Receiver'),
                                          actions: <Widget>[
                                            Container(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: TextFormField(
                                                        // readOnly:
                                                        //     true,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Date',
                                                        ),
                                                        onTap: _selDatePicker5,
                                                        controller:
                                                            txtController1,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Date";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editreceivername,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Receiver name";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Receiver name',
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TypeAheadFormField(
                                                      textFieldConfiguration:
                                                          TextFieldConfiguration(
                                                        controller: items2,
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
                                                        var param = Map<String,
                                                            dynamic>();
                                                        param['name'] = pattern;
                                                        param['user_id'] =
                                                            item["user_id"];
                                                        return await apiService
                                                            .getUserSuggestion(
                                                                'assetTransfer/searchItemName',
                                                                param);
                                                      },
                                                      itemBuilder: (context,
                                                          dynamic suggestion) {
                                                        return ListTile(
                                                          leading: Icon(
                                                              Icons.person),
                                                          title: Text(
                                                              suggestion[
                                                                  'name']),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (dynamic suggestion) {
                                                        items2.text =
                                                            suggestion['name'];
                                                        contractornameid =
                                                            suggestion['id']
                                                                .toString();
                                                        log('contractornameid : ${contractornameid}');
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
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: editqty,
                                                      validator: (value) {
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
                                                        hintText: 'Qty',
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
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
                                                          init();
                                                          var param = Map<
                                                              String,
                                                              dynamic>();
                                                          param['date'] =
                                                              txtController1
                                                                  .text;
                                                          param['receivername'] =
                                                              editreceivername
                                                                  .text;
                                                          param['item'] =
                                                              contractornameid;
                                                          param['qty'] =
                                                              editqty.text;
                                                          param["type"] =
                                                              item['type'];
                                                          param['id'] =
                                                              item['id'];
                                                          var resData =
                                                              await apiService
                                                                  .postCall(
                                                                      'assetTransfer/edit',
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
                                                            init();
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
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                          builder:
                                              (BuildContext context, setState) {
                                        return AlertDialog(
                                          actionsPadding: EdgeInsets.zero,
                                          titlePadding: EdgeInsets.zero,
                                          contentPadding: EdgeInsets.zero,
                                          title: Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Text(
                                                "Confirm Delete",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontSize: 20),
                                              )),
                                          content: Container(
                                            padding: EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                              right: 10,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                      TextButton(
                                                          onPressed: () async {
                                                            var resData =
                                                                await apiService
                                                                    .getcall(
                                                              'assetTransfer/delete/${item['id']}',
                                                            );

                                                            Navigator.pop(
                                                                context);
                                                            log('$resData');
                                                            if (resData[
                                                                    'success'] ==
                                                                1) {
                                                              ToastMsg(
                                                                resData[
                                                                    'message'],
                                                                15,
                                                                Colors.green,
                                                              );
                                                              widget.refresh({
                                                                'refresh': true
                                                              });
                                                            } else {
                                                              ToastMsg(
                                                                resData[
                                                                    'message'],
                                                                15,
                                                                Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Century Gothic",
                                                                color:
                                                                    Colors.red),
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
                                // GestureDetector(
                                //   onTap: () async {
                                //     // var data = Map<String, dynamic>();
                                //     // data['name'] = addcontactorname.text;
                                //     // data['user_id'] = userid.toString();
                                //     var resData = await apiService.getcall(
                                //       'assetTransfer/delete/${item['id']}',
                                //     );
                                //     if (resData['sucess'] == 1) {
                                //       ToastMsg(
                                //         resData['message'],
                                //         15,
                                //         Colors.green,
                                //       );
                                //     }
                                //   },
                                //   child: Icon(
                                //     Icons.delete,
                                //     size: 15,
                                //     color: Colors.red,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ]),
                  ],
                ),
                // if (loader)
                //   Positioned(
                //       child: Container(
                //           color: Colors.grey.withOpacity(0.5),
                //           child: Center(
                //               child: CircularProgressIndicator(
                //             color: Colors.green,
                //           ))))
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Table(
                  border: TableBorder(
                      horizontalInside: BorderSide(
                    color: Colors.grey,
                  )),
                  columnWidths: {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "${widget.type == 1 ? 'Admin' : 'CONTRACTOR NAME'}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "DATE",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20),
                              child: Text(
                                "Receiver Name",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Item",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Qty",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Action",
                                style: TextStyle(
                                  fontFamily: "Century Gothic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    for (var item in widget.data)
                      TableRow(children: [
                        if (widget.type == 1) ...[
                          TableCell(
                            child: GestureDetector(
                              onTap: widget.type == 1
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FromtoDetail(
                                                user_id: item['user_id']),
                                          ));
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${widget.type == 1 ? item['sitename'] : item['receivername']} ",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['date']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Fromreceiver(
                                        refresh: (filters) {
                                          if (filters['refresh']) {
                                            init();
                                          }
                                        },
                                        name:
                                            "${widget.type == 1 ? item['sitename'] : item['receivername']} ",
                                        id: item["user_id"]),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${widget.type == 1 ? item['sitename'] : item['receivername']} ",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['name']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['qty']}",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        log("${item}");
                                        editreceivername.text =
                                            item['receivername'];
                                        editqty.text = item['qty'].toString();
                                        txtController1.text = item['date'];
                                        // addcontactorname.text =
                                        //     data['contractorname'];
                                        // labourfullday.text =
                                        //     data['labourfullday'].toString();
                                        // labourothrs.text =
                                        //     data['labourothrs'].toString();

                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Edit From Receiver'),
                                              actions: <Widget>[
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: TextFormField(
                                                        // readOnly:
                                                        //     true,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Enter a Date',
                                                        ),
                                                        onTap: _selDatePicker5,
                                                        controller:
                                                            txtController1,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return "Please enter Date";
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editreceivername,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Receiver name";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Receiver name',
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      child:
                                                          Autocomplete<String>(
                                                        fieldViewBuilder: (context,
                                                            textEditingController,
                                                            focusNode,
                                                            onEditingComplete) {
                                                          textEditingController
                                                                  .text =
                                                              item['name'];
                                                          return TextFormField(
                                                            controller:
                                                                textEditingController,
                                                            focusNode:
                                                                focusNode,
                                                            onEditingComplete:
                                                                onEditingComplete,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
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
                                                                serachdata = [];
                                                            var param = Map<
                                                                String,
                                                                dynamic>();
                                                            param['name'] =
                                                                textEditingValue
                                                                    .text;
                                                            param['user_id'] =
                                                                item['user_id'];
                                                            var resdata =
                                                                await apiService
                                                                    .getUserSuggestion(
                                                                        'assetTransfer/searchItemName',
                                                                        param);
                                                            log('popopopopo${resdata}');
                                                            searchUSer =
                                                                resdata;
                                                            for (var data
                                                                in resdata) {
                                                              serachdata.add(
                                                                  data['name']);
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
                                                              contractornameid =
                                                                  item['id'];
                                                            }
                                                          }
                                                          log('id : ${contractornameid}');
                                                          items1.text =
                                                              suggestion;
                                                          log("Supplier ${items1.text}");
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: editqty,
                                                      validator: (value) {
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
                                                        hintText: 'Qty',
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
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
                                                          init();
                                                          var param = Map<
                                                              String,
                                                              dynamic>();
                                                          param['date'] =
                                                              txtController1
                                                                  .text;
                                                          param['receivername'] =
                                                              editreceivername
                                                                  .text;
                                                          param['item'] =
                                                              contractornameid;
                                                          param['qty'] =
                                                              editqty.text;
                                                          param["type"] =
                                                              item['type'];
                                                          param['id'] =
                                                              item['id'];
                                                          var resData =
                                                              await apiService
                                                                  .postCall(
                                                                      'assetTransfer/edit',
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
                                                            init();
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
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 15,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                              builder: (BuildContext context,
                                                  setState) {
                                            return AlertDialog(
                                              actionsPadding: EdgeInsets.zero,
                                              titlePadding: EdgeInsets.zero,
                                              contentPadding: EdgeInsets.zero,
                                              title: Container(
                                                  padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                  ),
                                                  child: Text(
                                                    "Confirm Delete",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 20),
                                                  )),
                                              content: Container(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: SingleChildScrollView(
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
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Cancel")),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                init();
                                                                var resData =
                                                                    await apiService
                                                                        .getcall(
                                                                  'assetTransfer/delete/${item['id']}',
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                                if (resData[
                                                                        'sucess'] ==
                                                                    1) {
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors
                                                                        .green,
                                                                  );
                                                                } else {
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors.red,
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Century Gothic",
                                                                    color: Colors
                                                                        .red),
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
                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     // var data = Map<String, dynamic>();
                                    //     // data['name'] = addcontactorname.text;
                                    //     // data['user_id'] = userid.toString();
                                    //     var resData = await apiService.getcall(
                                    //       'assetTransfer/delete/${item['id']}',
                                    //     );
                                    //     if (resData['sucess'] == 1) {
                                    //       ToastMsg(
                                    //         resData['message'],
                                    //         15,
                                    //         Colors.green,
                                    //       );
                                    //     }
                                    //   },
                                    //   child: Icon(
                                    //     Icons.delete,
                                    //     size: 15,
                                    //     color: Colors.red,
                                    //   ),
                                    // ),
                                  ],
                                )),
                          ),
                        ],
                      ]),
                  ],
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
