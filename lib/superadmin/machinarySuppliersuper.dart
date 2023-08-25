import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class machinarySupplierSuper extends StatefulWidget {
  machinarySupplierSuper({Key? key, required this.vecno, required this.adminid})
      : super(key: key);
  final adminid;
  final vecno;

  @override
  State<machinarySupplierSuper> createState() => _machinarySupplierSuperState();
}

class _machinarySupplierSuperState extends State<machinarySupplierSuper> {
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
        // txtController.text = DateFormat.yMd().format(pickedDate);
        txtController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  ApiService apiService = ApiService();
  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
  List itemdrop = [];
  List userData = [];
  String itemdropchoose = '';
  late SharedPreferences pref;
  bool isExportPdfLoader = false;
  bool isExportExcelLoader = false;
  TextEditingController editsuppliername = TextEditingController();
  TextEditingController editvehicle = TextEditingController();
  TextEditingController editvehicleno = TextEditingController();
  TextEditingController editoperator = TextEditingController();
  TextEditingController editunit = TextEditingController();
  TextEditingController editqty = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  List searchUSer = [];
  var contractornameid;
  List materialUSer = [];
  var materialnameid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
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

  init() async {
    var resdata = await apiService.getcall(
        'machinery/getSupplierAllC?from_date=${txtController.text}&to_date=${txtController2.text}&suppliername=${widget.vecno}');
    log("${resdata}");
    setState(() {
      userData = resdata['data']['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: SafeArea(
            child: Container(
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
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
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
                                      "Supplier details",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     init();
                              //   },
                              //   icon: Icon(
                              //     Icons.refresh,
                              //     color: Colors.blue[900],
                              //   ),
                              // ),
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
                          margin: EdgeInsets.only(top: 20, left: 10),
                          child: Column(
                            children: [
                              Text(
                                "From Date:",
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  // style: TextStyle(fontSize: 11),
                                  onTap: _selDatePicker,
                                  controller: txtController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
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
                                    fontSize: 12),
                              ),
                              Container(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  // style: TextStyle(fontSize: 11),
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
                                          'user_id=${widget.adminid.toString()}';
                                      query +=
                                          '&suppliername=${widget.vecno.toString()}';
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
                                          'http://89.116.229.150:3003/api/machinery/downloadGetAllSupplierPdf?' +
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
                                      'assets/pdf.png',
                                      height: 40,
                                      // color: Colors.blue,
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: isExportPdfLoader
                                  ? null
                                  : () async {
                                      var query = '';
                                      query +=
                                          'user_id=${widget.adminid.toString()}';
                                      query +=
                                          '&suppliername=${widget.vecno.toString()}';
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
                                          'http://89.116.229.150:3003/api/machinery/downloadGetAllSupplierExcel?' +
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
                                      'assets/exel.png',
                                      height: 40,
                                      // color: Colors.blue,
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
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    defaultColumnWidth: FixedColumnWidth(
                                      85.0,
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "suppliername Name",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "vehicle",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "vehicle no",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "operator",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "unit",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "qty",
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
                                      for (var data in userData)
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
                                                    fontSize: 15,
                                                  ),
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
                                                  "${data['vehicle']}",
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
                                                  "${data['operator']}",
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
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          editsuppliername
                                                                  .text =
                                                              data[
                                                                  'suppliername'];
                                                          editvehicle.text =
                                                              data['vehicle'];
                                                          editvehicleno.text =
                                                              data[
                                                                  'vehicle_no'];
                                                          editoperator.text =
                                                              data['operator'];
                                                          editunit.text =
                                                              data['unit'];
                                                          editqty.text =
                                                              data['qty'];
                                                          txtController1.text =
                                                              data['date'];
                                                          contractornameid = data[
                                                              'suppliername1'];
                                                          materialnameid =
                                                              data['vehicle2'];
                                                          log("con : ${contractornameid}");
                                                          log("vechi : ${materialnameid}");
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Supplier Details'),
                                                                actions: <
                                                                    Widget>[
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
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Date',
                                                                            ),
                                                                            onTap:
                                                                                _selDatePicker5,
                                                                            controller:
                                                                                txtController1,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
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
                                                                                editsuppliername,
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                pattern;
                                                                            param['user_id'] =
                                                                                data["user_id"];

                                                                            param['type'] =
                                                                                1;
                                                                            // log("${param}");
                                                                            return await apiService.getUserSuggestion('machinery/searchName',
                                                                                param);
                                                                          },
                                                                          itemBuilder:
                                                                              (context, dynamic suggestion) {
                                                                            return ListTile(
                                                                              leading: Icon(Icons.person),
                                                                              title: Text(suggestion['name']),
                                                                            );
                                                                          },
                                                                          onSuggestionSelected:
                                                                              (dynamic suggestion) {
                                                                            contractornameid =
                                                                                suggestion['id'];
                                                                            editsuppliername.text =
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
                                                                          // readOnly: true,
                                                                          controller:
                                                                              editvehicle,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter Vehicle";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Vehicle',
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
                                                                                editvehicleno,
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                pattern;
                                                                            param['user_id'] =
                                                                                data["user_id"];

                                                                            param['type'] =
                                                                                2;
                                                                            // log("${param}");
                                                                            return await apiService.getUserSuggestion('machinery/searchName',
                                                                                param);
                                                                          },
                                                                          itemBuilder:
                                                                              (context, dynamic suggestion) {
                                                                            return ListTile(
                                                                              leading: Icon(Icons.person),
                                                                              title: Text(suggestion['name']),
                                                                            );
                                                                          },
                                                                          onSuggestionSelected:
                                                                              (dynamic suggestion) {
                                                                            materialnameid =
                                                                                suggestion['id'];
                                                                            editvehicleno.text =
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
                                                                              editoperator,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter Operator";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Operator',
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
                                                                        TextFormField(
                                                                          // readOnly: true,
                                                                          controller:
                                                                              editqty,
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
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.green[100],
                                                                              onPrimary: Colors.blue[900],
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              if (editsuppliername.text.isEmpty) {
                                                                                ToastMsg(
                                                                                  "Please enter Name",
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                var param = Map<String, dynamic>();
                                                                                param['date'] = txtController1.text;
                                                                                param['suppliername'] = contractornameid;
                                                                                param['vehicle'] = editvehicle.text;
                                                                                param['vehicle_no'] = materialnameid;
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
                                                          size: 20,
                                                        ),
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
                                                                                    'machinery/delete/${data['id']}',
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
            ),
          ),
        );
      } else {
        return Scaffold(
          body: SafeArea(
            child: Container(
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
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
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
                                      "Supplier details",
                                      style: TextStyle(
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     init();
                              //   },
                              //   icon: Icon(
                              //     Icons.refresh,
                              //     color: Colors.blue[900],
                              //   ),
                              // ),
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
                          margin: EdgeInsets.only(top: 20, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "From Date:",
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
                                  onTap: _selDatePicker,
                                  controller: txtController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
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
                                    fontFamily: "Century Gothic",
                                    fontSize: 12),
                              ),
                              Container(
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
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
                                          'user_id=${widget.adminid.toString()}';
                                      query +=
                                          '&suppliername=${widget.vecno.toString()}';
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
                                          'http://89.116.229.150:3003/api/machinery/downloadGetAllSupplierPdf?' +
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
                                      'assets/pdf.png',
                                      height: 40,
                                      // color: Colors.blue,
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: isExportPdfLoader
                                  ? null
                                  : () async {
                                      var query = '';
                                      query +=
                                          'user_id=${widget.adminid.toString()}';
                                      query +=
                                          '&suppliername=${widget.vecno.toString()}';
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
                                          'http://89.116.229.150:3003/api/machinery/downloadGetAllSupplierExcel?' +
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
                                      'assets/exel.png',
                                      height: 40,
                                      // color: Colors.blue,
                                    ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.only(top: 20, right: 20),
                      //   child: Row(
                      //     children: [
                      //       GestureDetector(
                      //         onTap: isExportPdfLoader
                      //             ? null
                      //             : () async {
                      //                 var query = '';
                      //                 query +=
                      //                     'user_id=${userid.toString()}';
                      //                 // from_date=${txtController.text}&to_date=${txtController2.text}
                      //                 if (txtController.text != '') {
                      //                   query +=
                      //                       '&from_date=${txtController.text}';
                      //                 }

                      //                 if (txtController2.text != '') {
                      //                   query +=
                      //                       '&to_date=${txtController2.text}';
                      //                 }
                      //                 query +=
                      //                     '&type=${_selectedIndex + 1}';
                      //                 log('query $query');
                      //                 setState(() {
                      //                   isExportPdfLoader = true;
                      //                 });
                      //                 var resData = await apiService.getCall(
                      //                     'http://89.116.229.150:3003/api/assetTransfer/downloadGetAllpdf?' +
                      //                         query);

                      //                 setState(() {
                      //                   isExportPdfLoader = false;
                      //                 });
                      //                 if (resData['success'] == 1) {
                      //                   openFile(
                      //                       url:
                      //                           'http://89.116.229.150/~levelup/valiant_api' +
                      //                               resData['fileLink'],
                      //                       filename:
                      //                           'assetTransfer${now}.pdf');
                      //                 } else {
                      //                   ToastMsg(
                      //                     resData['message'],
                      //                     15,
                      //                     Colors.red,
                      //                   );
                      //                 }
                      //               },
                      //         child: isExportPdfLoader
                      //             ? CircularProgressIndicator()
                      //             : Image.asset(
                      //                 "assets/pdf.png",
                      //                 height: 40,
                      //               ),
                      //       ),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       // GestureDetector(
                      //       //   onTap: isExportPdfLoader
                      //       //       ? null
                      //       //       : () async {
                      //       //           var query = '';
                      //       //           query +=
                      //       //               'user_id=${userid.toString()}';
                      //       //           // from_date=${txtController.text}&to_date=${txtController2.text}
                      //       //           if (txtController.text != '') {
                      //       //             query +=
                      //       //                 '&from_date=${txtController.text}';
                      //       //           }
                      //       //           query +=
                      //       //               '&type=${_selectedIndex + 1}';
                      //       //           if (txtController2.text != '') {
                      //       //             query +=
                      //       //                 '&to_date=${txtController2.text}';
                      //       //           }
                      //       //           log('query $query');
                      //       //           setState(() {
                      //       //             isExportExcelLoader = true;
                      //       //           });
                      //       //           var resData = await apiService.getCall(
                      //       //               'http://89.116.229.150:3003/api/assetTransfer/downloadGetAllExcel?' +
                      //       //                   query);

                      //       //           setState(() {
                      //       //             isExportExcelLoader = false;
                      //       //           });
                      //       //           if (resData['success'] == 1) {
                      //       //             openFile(
                      //       //                 url:
                      //       //                     'http://89.116.229.150/~levelup/valiant_api' +
                      //       //                         resData['fileLink'],
                      //       //                 filename:
                      //       //                     'assetTransfer${now}.xlsx');
                      //       //           } else {
                      //       //             ToastMsg(
                      //       //               resData['message'],
                      //       //               15,
                      //       //               Colors.red,
                      //       //             );
                      //       //           }
                      //       //         },
                      //       //   child: isExportExcelLoader
                      //       //       ? CircularProgressIndicator()
                      //       //       : Image.asset(
                      //       //           "assets/exel.png",
                      //       //           height: 40,
                      //       //         ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
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
                              margin: EdgeInsets.only(top: 15),
                              // margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    defaultColumnWidth: FixedColumnWidth(
                                      170.0,
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "suppliername Name",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "vehicle",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "vehicle no",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "operator",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "unit",
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "qty",
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
                                      for (var data in userData)
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
                                                    fontSize: 15,
                                                  ),
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
                                                  "${data['vehicle']}",
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
                                                  "${data['operator']}",
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
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          log("${data}");
                                                          editsuppliername
                                                                  .text =
                                                              data[
                                                                  'suppliername'];
                                                          editvehicle.text =
                                                              data['vehicle'];
                                                          editvehicleno.text =
                                                              data[
                                                                  'vehicle_no'];
                                                          editoperator.text =
                                                              data['operator'];
                                                          editunit.text =
                                                              data['unit'];
                                                          editqty.text =
                                                              data['qty'];
                                                          txtController1.text =
                                                              data['date'];
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Supplier Name'),
                                                                actions: <
                                                                    Widget>[
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              TextFormField(
                                                                            // readOnly:
                                                                            //     true,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Date',
                                                                            ),
                                                                            onTap:
                                                                                _selDatePicker5,
                                                                            controller:
                                                                                txtController1,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
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
                                                                          child:
                                                                              Autocomplete<String>(
                                                                            fieldViewBuilder: (context,
                                                                                textEditingController,
                                                                                focusNode,
                                                                                onEditingComplete) {
                                                                              textEditingController.text = data['suppliername'];
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
                                                                              if (textEditingValue.text == '') {
                                                                                return const Iterable<String>.empty();
                                                                              } else {
                                                                                List<String> serachdata = [];
                                                                                var param = Map<String, dynamic>();
                                                                                param['name'] = textEditingValue.text;
                                                                                param['user_id'] = data['user_id'];
                                                                                data['type'] = 1;
                                                                                var resdata = await apiService.getUserSuggestion('machinery/searchName', param);
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
                                                                              getid = searchUSer.where((x) => x['name'].toLowerCase().contains(suggestion.toLowerCase())).toList();
                                                                              log("getid ${getid}");
                                                                              for (var item in getid) {
                                                                                if (item['name'] == suggestion) {
                                                                                  contractornameid = item['id'];
                                                                                }
                                                                              }
                                                                              log('id : ${contractornameid}');
                                                                              editsuppliername.text = suggestion;
                                                                              log("Supplier ${editsuppliername.text}");
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
                                                                              editvehicle,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter Vehicle";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Vehicle',
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Autocomplete<String>(
                                                                            fieldViewBuilder: (context,
                                                                                textEditingController,
                                                                                focusNode,
                                                                                onEditingComplete) {
                                                                              textEditingController.text = data['vehicle_no'];
                                                                              return TextFormField(
                                                                                controller: textEditingController,
                                                                                focusNode: focusNode,
                                                                                onEditingComplete: onEditingComplete,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                  hintText: 'Enter a Vehicle No"',
                                                                                ),
                                                                              );
                                                                            },
                                                                            optionsBuilder:
                                                                                (TextEditingValue textEditingValue) async {
                                                                              if (textEditingValue.text == '') {
                                                                                return const Iterable<String>.empty();
                                                                              } else {
                                                                                List<String> serachdata = [];
                                                                                var param = Map<String, dynamic>();
                                                                                param['name'] = textEditingValue.text;
                                                                                param['user_id'] = data['user_id'];
                                                                                data['type'] = 2;
                                                                                var resdata = await apiService.getUserSuggestion('machinery/searchName', param);
                                                                                log('popopopopo${resdata}');
                                                                                materialUSer = resdata;
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
                                                                              getid = materialUSer.where((x) => x['name'].toLowerCase().contains(suggestion.toLowerCase())).toList();
                                                                              log("getid ${getid}");
                                                                              for (var item in getid) {
                                                                                if (item['name'] == suggestion) {
                                                                                  materialnameid = item['id'];
                                                                                }
                                                                              }
                                                                              log('id : ${materialnameid}');
                                                                              editvehicleno.text = suggestion;
                                                                              log("Supplier ${editvehicleno.text}");
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
                                                                              editoperator,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return "Please enter Operator";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Enter a Operator',
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
                                                                        TextFormField(
                                                                          // readOnly: true,
                                                                          controller:
                                                                              editqty,
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
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.green[100],
                                                                              onPrimary: Colors.blue[900],
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              if (editsuppliername.text.isEmpty) {
                                                                                ToastMsg(
                                                                                  "Please enter Name",
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                var param = Map<String, dynamic>();
                                                                                param['date'] = txtController1.text;
                                                                                param['suppliername'] = contractornameid;
                                                                                param['vehicle_no'] = materialnameid;
                                                                                param['vehicle'] = editvehicle.text;
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
                                                          size: 20,
                                                        ),
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
                                                                                    'machinery/delete/${data['id']}',
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
