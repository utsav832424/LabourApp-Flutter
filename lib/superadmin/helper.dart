import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/contractordetail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SHelper extends StatefulWidget {
  SHelper(
      {Key? key,
      required this.data,
      this.contarator,
      this.action,
      required this.type,
      required this.refresh})
      : super(key: key);
  final data;
  final type;
  final contarator;
  final action;
  final void Function(Map<String, dynamic> filters) refresh;

  @override
  State<SHelper> createState() => _SHelperState();
}

class _SHelperState extends State<SHelper> {
  final txtController = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
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
  TextEditingController edithelperfullday = TextEditingController();
  TextEditingController edithelperothrs = TextEditingController();

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;
  List searchUSer = [];
  var contractornameid;
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
    userType = prefs.getInt('type')!.toInt();
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
            child: Scrollbar(
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
                    columnWidths: userType == 1
                        ? {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(4),
                            3: FlexColumnWidth(4),
                          }
                        : {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(2),
                          },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15),
                              child: Text(
                                "DATE",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 16),
                              child: Text(
                                "CONTRACTOR NAME",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "FULL DAY",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "O.T HRS",
                                style: TextStyle(
                                    fontFamily: "Century Gothic",
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (widget.type == 2 && widget.action == 1)
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Action",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                      for (var data in widget.data)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${data['date']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 15),
                                child: GestureDetector(
                                  onTap: widget.type == 1
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SContractorDetail(
                                                contractor_id:
                                                    data['contractorname_id'],
                                                tabindex: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: Text(
                                    "${widget.type == 1 ? data['sitename'] : data['contractorname']}",
                                    style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 15),
                                child: Text(
                                  "${data['helperfullday']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 15),
                                child: Text(
                                  "${data['helperothrs']}",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            if (widget.type == 2 && widget.action == 1)
                              TableCell(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // editname.text = data['name'];
                                        log("${data}");
                                        addcontactorname.text =
                                            data['contractorname'];
                                        txtController1.text = data['date'];
                                        edithelperfullday.text =
                                            data['helperfullday'].toString();
                                        edithelperothrs.text =
                                            data['helperothrs'].toString();
                                        contractornameid =
                                            data['contractorname_id'];
                                        log(" con  : ${contractornameid}");
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Edit Helper'),
                                              actions: <Widget>[
                                                Container(
                                                  // height: 200,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Column(
                                                      children: [
                                                        Container(
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
                                                                _selDatePicker,
                                                            controller:
                                                                txtController1,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Please enter Date";
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TypeAheadFormField(
                                                          textFieldConfiguration:
                                                              TextFieldConfiguration(
                                                            controller:
                                                                addcontactorname,
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
                                                                hintText: 'Enter Helper'),
                                                          ),
                                                          suggestionsCallback:
                                                              (pattern) async {
                                                            var param = Map<
                                                                String,
                                                                dynamic>();
                                                            param['name'] =
                                                                pattern;
                                                            param['user_id'] =
                                                                data['user_id'];
                                                            return await apiService
                                                                .getUserSuggestion(
                                                                    'labour/searchContractorName',
                                                                    param);
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
                                                            log("${contractornameid}");
                                                            addcontactorname
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
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          // readOnly: true,
                                                          controller:
                                                              edithelperfullday,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter helper Full Day";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a helper Full Day',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          // readOnly: true,
                                                          controller:
                                                              edithelperothrs,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter helper othrs";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a helper othrs',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
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
                                                              var param = Map<
                                                                  String,
                                                                  dynamic>();
                                                              param['date'] =
                                                                  txtController1
                                                                      .text;
                                                              param['contractorname'] =
                                                                  contractornameid;
                                                              param['helperfullday'] =
                                                                  edithelperfullday
                                                                      .text;
                                                              param['helperothrs'] =
                                                                  edithelperothrs
                                                                      .text;

                                                              param['id'] =
                                                                  data['id'];
                                                              var resData =
                                                                  await apiService
                                                                      .postCall(
                                                                          'labour/editContractor',
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
                                                              }
                                                              widget.refresh({
                                                                "reload": true
                                                              });
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
                                    SizedBox(
                                      width: 15,
                                    ),
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
                                                                var resData =
                                                                    await apiService
                                                                        .getcall(
                                                                  'labour/deleteContractorReport/${data['id']}',
                                                                );
                                                                log("$resData");
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

                                                                  widget
                                                                      .refresh({
                                                                    "reload":
                                                                        true
                                                                  });
                                                                } else {
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors.red,
                                                                  );
                                                                  widget
                                                                      .refresh({
                                                                    "reload":
                                                                        true
                                                                  });
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
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Container(
            child: Scrollbar(
              child: ListView(
                children: [
                  SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder(
                          horizontalInside: BorderSide(
                        color: Colors.grey,
                      )),
                      columnWidths: userType == 1
                          ? {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(4),
                              3: FlexColumnWidth(4),
                            }
                          : {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(2),
                              4: FlexColumnWidth(2),
                            },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10),
                                child: Text(
                                  "DATE",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "CONTRACTOR NAME",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "FULL DAY",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "O.T HRS",
                                  style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            if (widget.type == 2 && widget.contarator != null)
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Action",
                                    style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (var data in widget.data)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${data['date']}",
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
                                  child: GestureDetector(
                                    onTap: widget.type == 1
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SContractorDetail(
                                                  contractor_id:
                                                      data['contractorname_id'],
                                                  tabindex: 2,
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      "${data['contractorname']}",
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
                                    "${data['helperfullday']}",
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
                                    "${data['helperothrs']}",
                                    style: TextStyle(
                                        fontFamily: "Century Gothic",
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              if (widget.type == 2 && widget.contarator != null)
                                TableCell(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // editname.text = data['name'];
                                          edithelperfullday.text =
                                              data['helperfullday'].toString();
                                          edithelperothrs.text =
                                              data['helperothrs'].toString();
                                          addcontactorname.text =
                                              data['contractorname'];
                                          txtController1.text = data['date'];
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Edit Helper'),
                                                actions: <Widget>[
                                                  Container(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child:
                                                                TextFormField(
                                                              readOnly: true,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                hintText:
                                                                    'Enter a Date',
                                                              ),
                                                              onTap:
                                                                  _selDatePicker,
                                                              controller:
                                                                  txtController1,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Please enter Date";
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            child: Autocomplete<
                                                                String>(
                                                              fieldViewBuilder:
                                                                  (context,
                                                                      textEditingController,
                                                                      focusNode,
                                                                      onEditingComplete) {
                                                                textEditingController
                                                                        .text =
                                                                    data[
                                                                        'contractorname'];
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
                                                                      serachdata =
                                                                      [];
                                                                  var param = Map<
                                                                      String,
                                                                      dynamic>();
                                                                  param['name'] =
                                                                      textEditingValue
                                                                          .text;
                                                                  param['user_id'] =
                                                                      data[
                                                                          'user_id'];
                                                                  var resdata =
                                                                      await apiService.getUserSuggestion(
                                                                          'labour/searchContractorName',
                                                                          param);
                                                                  log('popopopopo${resdata}');
                                                                  searchUSer =
                                                                      resdata;
                                                                  for (var data
                                                                      in resdata) {
                                                                    serachdata
                                                                        .add(data[
                                                                            'name']);
                                                                  }
                                                                  serachdata
                                                                      .retainWhere(
                                                                          (s) {
                                                                    return s
                                                                        .toLowerCase()
                                                                        .contains(textEditingValue
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
                                                                            suggestion.toLowerCase()))
                                                                    .toList();
                                                                log("getid ${getid}");
                                                                for (var item
                                                                    in getid) {
                                                                  if (item[
                                                                          'name'] ==
                                                                      suggestion) {
                                                                    contractornameid =
                                                                        item[
                                                                            'id'];
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
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextFormField(
                                                            // readOnly: true,
                                                            controller:
                                                                edithelperfullday,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Please enter helper Full Day";
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  'Enter a helper Full Day',
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          TextFormField(
                                                            // readOnly: true,
                                                            controller:
                                                                edithelperothrs,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Please enter helper othrs";
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  'Enter a helper othrs',
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .green[100],
                                                                onPrimary:
                                                                    Colors.blue[
                                                                        900],
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                init();
                                                                var param = Map<
                                                                    String,
                                                                    dynamic>();
                                                                param['date'] =
                                                                    txtController1
                                                                        .text;
                                                                param['contractorname'] =
                                                                    contractornameid;
                                                                param['helperfullday'] =
                                                                    edithelperfullday
                                                                        .text;
                                                                param['helperothrs'] =
                                                                    edithelperothrs
                                                                        .text;

                                                                param['id'] =
                                                                    data['id'];
                                                                var resData =
                                                                    await apiService
                                                                        .postCall(
                                                                            'labour/editContractor',
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
                                                                }
                                                                widget.refresh({
                                                                  "reload": true
                                                                });
                                                              },
                                                              child:
                                                                  Text("Save"),
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
                                      SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(builder:
                                                    (BuildContext context,
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
                                                                    'labour/deleteContractorReport/${data['id']}',
                                                                  );
                                                                  log("$resData");
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

                                                                    widget
                                                                        .refresh({
                                                                      "reload":
                                                                          true
                                                                    });
                                                                  } else {
                                                                    ToastMsg(
                                                                      resData[
                                                                          'message'],
                                                                      15,
                                                                      Colors
                                                                          .red,
                                                                    );
                                                                    widget
                                                                        .refresh({
                                                                      "reload":
                                                                          true
                                                                    });
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
