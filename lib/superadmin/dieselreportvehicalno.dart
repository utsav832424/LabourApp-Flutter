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

class Dieselreportvehicalno extends StatefulWidget {
  Dieselreportvehicalno(
      {Key? key, required this.machinery, required this.dvhical})
      : super(key: key);
  final machinery;
  final dvhical;

  @override
  State<Dieselreportvehicalno> createState() => _DieselreportvehicalnoState();
}

class _DieselreportvehicalnoState extends State<Dieselreportvehicalno> {
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

  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();
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

  TextEditingController machinery = TextEditingController();
  TextEditingController vehiclenumber = TextEditingController();
  TextEditingController driver = TextEditingController();
  TextEditingController qty_ltr = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController editvehiclenumber = TextEditingController();
  TextEditingController editdriver = TextEditingController();
  TextEditingController editqtyltr = TextEditingController();
  TextEditingController editvehiclename = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  var suggestsup;
  List searchUSer = [];
  var contractornameid;
  List materialUSer = [];
  var materialnameid;
  bool loader = true;
  List data = [];
  late ScrollController _scrollController;
  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();

  var token = "";
  var userid = 0;
  var userType = 0;
  late List diesel = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();
  var totalused = 0;
  var incoming = 0;
  var yesterdaystock = 0;
  var totalstock = 0;
  var totalqty = 0;
  int _page = 0;
  int _limit = 10;
  bool isLoad = false;
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
    setState(() {
      loader = true;
    });

    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    userType = prefs.getInt('type')!.toInt();
    var resData = await apiService.getcall(
        "diesel/getVehicalAllC?vehiclenumber=${widget.dvhical}&from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${widget.machinery}");
    log("${resData}");
    if (mounted) {
      setState(() {
        diesel = resData['data']['data'];
        totalqty = resData['data']['total']['total_qty'];

        loader = false;
        // totalused = resData['total_used'];
        // incoming = resData['incoming'];
        // yesterdaystock = resData['yesterday'];
        // totalstock = resData['total_stock'];
      });
    }
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

  final now = DateFormat("yyyy-MM-dd").format(DateTime.now());

  final txtController2 = TextEditingController();
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

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();

    var resData = await apiService.getcall(
        "diesel?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20");
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

  bool isExportExcelLoader = false;
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
                                  "Diesel Vehicalno Report",
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
                                  fontFamily: "Century Gothic",
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
                                    fontFamily: "Century Gothic",
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Container(
                                width: 100,
                                child: TextFormField(
                                  readOnly: true,
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
                                        query += 'user_id=${widget.machinery}';
                                        query +=
                                            '&vehiclenumber=${widget.dvhical}';
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
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllVechicalPdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'dieselSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                        query += 'user_id=${widget.machinery}';
                                        query +=
                                            '&vehiclenumber=${widget.dvhical}';
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
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllVechicalExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'dieselSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                  scrollDirection: Axis.vertical,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (userType == 2)
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Action",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
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
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Text(
                                                  "${data['date']}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black,
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
                                                  right: 5,
                                                ),
                                                child: Text(
                                                  "${data['machinery']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 35,
                                                  bottom: 5,
                                                  right: 5,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.of(context)
                                                    //     .push(PageRouteBuilder(
                                                    //   pageBuilder: (_, __, ___) =>
                                                    //       Dieselreportvehicalno(
                                                    //           // vecno: data['vehicle2'],
                                                    //           // adminid: data['user_id'],
                                                    //           ),
                                                    // ));
                                                  },
                                                  child: Text(
                                                    "${data['vehiclenumber']}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
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
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 30,
                                                  bottom: 5,
                                                  right: 5,
                                                ),
                                                child: Text(
                                                  "${data['qty_ltr']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            if (userType == 2)
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                          editvehiclenumber
                                                                  .text =
                                                              data[
                                                                  'vehiclenumber'];
                                                          editdriver.text =
                                                              data['driver'];
                                                          editqtyltr.text =
                                                              data['qty_ltr'];
                                                          txtController1.text =
                                                              data['date'];
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Vehicle Details'),
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['name'] =
                                                                                pattern;
                                                                            param['user_id'] =
                                                                                data["user_id"];
                                                                            // log("${param}");
                                                                            return await apiService.getUserSuggestion('diesel/searchName',
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
                                                                            editvehiclenumber.text =
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
                                                                                'Enter a qty',
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
                                                                              init();
                                                                              if (editvehiclename.text.isEmpty) {
                                                                                ToastMsg(
                                                                                  "Please enter Name",
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                var param = Map<String, dynamic>();
                                                                                param['date'] = txtController1.text;
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
                                                                                  init();
                                                                                  var resData = await apiService.getcall(
                                                                                    'diesel/delete/${data['id']}',
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
                                                          // var data = Map<String, dynamic>();
                                                          // data['name'] = addcontactorname.text;
                                                          // data['user_id'] = userid.toString();
                                                          // var resData =
                                                          //     await apiService
                                                          //         .getcall(
                                                          //   'diesel/delete/${data['id']}',
                                                          // );
                                                          // if (resData['sucess'] ==
                                                          //     1) {
                                                          //   ToastMsg(
                                                          //     resData['message'],
                                                          //     15,
                                                          //     Colors.green,
                                                          //   );
                                                          //   init();
                                                          // }
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
                // Positioned(
                //   left: 0,
                //   right: 0,
                //   bottom: 0,
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(top: 10, bottom: 10),
                //         decoration: BoxDecoration(
                //           color: Colors.green[100],
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             Column(
                //               children: [
                //                 Text(
                //                   "Total used",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   "${totalused}",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             Column(
                //               children: [
                //                 Text(
                //                   "incoming",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   "${incoming}",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             Column(
                //               children: [
                //                 Text(
                //                   "Total Stock",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   "${totalstock}",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                if (userType == 1)
                  Positioned(
                    bottom: 60,
                    left: 120,
                    child: TextButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
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
                                              left: 10, top: 10),
                                          child: Text(
                                            "Date",
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: TextFormField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
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
                                        SizedBox(
                                          height: 20,
                                        ),
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // width: 165,
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 6, top: 10),
                                              child: TextFormField(
                                                controller: qtyltr,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter Qty Ltr";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Qty Ltr',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                                var data =
                                                    Map<String, dynamic>();
                                                data['date'] =
                                                    txtController3.text;
                                                data['user_id'] =
                                                    userid.toString();
                                                data['qty_ltr'] = qtyltr.text;
                                                var resData =
                                                    await apiService.postCall(
                                                        'diesel/addNewDiesel',
                                                        data);
                                                if (resData['success'] == 0) {
                                                  ToastMsg(
                                                    resData['message'],
                                                    15,
                                                    Colors.red,
                                                  );
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("Save"),
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
                              "Add Diesel",
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
                                  "Diesel Vehicalno Report",
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
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
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
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Container(
                                  // width: 100,
                                  child: TextFormField(
                                    readOnly: true,
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
                                        query += 'user_id=${widget.machinery}';
                                        query +=
                                            '&vehiclenumber=${widget.dvhical}';
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
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllVechicalPdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'dieselSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                        query += 'user_id=${widget.machinery}';
                                        query +=
                                            '&vehiclenumber=${widget.dvhical}';
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
                                            'http://89.116.229.150:3003/api/diesel/downloadGetAllVechicalExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'dieselSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    defaultColumnWidth: FixedColumnWidth(
                                      225,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                top: 15,
                                              ),
                                              child: Text(
                                                "Vehicle Name",
                                                style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 15),
                                              child: Text(
                                                "Vehicle Number",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (userType == 2)
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Action",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
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
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Text(
                                                  "${data['date']}",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    color: Colors.black,
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
                                                  right: 5,
                                                ),
                                                child: Text(
                                                  "${data['machinery']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 80,
                                                  bottom: 5,
                                                  right: 5,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.of(context)
                                                    //     .push(PageRouteBuilder(
                                                    //   pageBuilder: (_, __, ___) =>
                                                    //       Dieselreportvehicalno(
                                                    //           // vecno: data['vehicle2'],
                                                    //           // adminid: data['user_id'],
                                                    //           ),
                                                    // ));
                                                  },
                                                  child: Text(
                                                    "${data['vehiclenumber']}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 80,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  "${data['driver']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 90,
                                                  bottom: 5,
                                                  right: 5,
                                                ),
                                                child: Text(
                                                  "${data['qty_ltr']}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            if (userType == 2)
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 5,
                                                    left: 80,
                                                    bottom: 5,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          log("${data}");
                                                          editvehiclename.text =
                                                              data['machinery'];
                                                          editvehiclenumber
                                                                  .text =
                                                              data[
                                                                  'vehiclenumber'];
                                                          editdriver.text =
                                                              data['driver'];
                                                          editqtyltr.text =
                                                              data['qty_ltr'];
                                                          txtController1.text =
                                                              data['date'];
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Diesel Vechical'),
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
                                                                        Container(
                                                                          child:
                                                                              Autocomplete<String>(
                                                                            fieldViewBuilder: (context,
                                                                                textEditingController,
                                                                                focusNode,
                                                                                onEditingComplete) {
                                                                              textEditingController.text = data['vehiclenumber'];
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
                                                                                var resdata = await apiService.getUserSuggestion('diesel/searchName', param);
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
                                                                              editvehiclenumber.text = suggestion;
                                                                              log("Supplier ${editvehiclenumber.text}");
                                                                            },
                                                                          ),
                                                                        ),
                                                                        // TextFormField(
                                                                        //   // readOnly: true,
                                                                        //   controller:
                                                                        //       editvehiclenumber,
                                                                        //   validator:
                                                                        //       (value) {
                                                                        //     if (value == null ||
                                                                        //         value.isEmpty) {
                                                                        //       return "Please enter Vehicle No";
                                                                        //     }
                                                                        //     return null;
                                                                        //   },
                                                                        //   decoration:
                                                                        //       InputDecoration(
                                                                        //     border:
                                                                        //         OutlineInputBorder(),
                                                                        //     hintText:
                                                                        //         'Enter a Vehicle No',
                                                                        //   ),
                                                                        // ),
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
                                                                                'Enter a qty',
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
                                                                              init();
                                                                              if (editvehiclename.text.isEmpty) {
                                                                                ToastMsg(
                                                                                  "Please enter Name",
                                                                                  15,
                                                                                  Colors.red,
                                                                                );
                                                                              } else {
                                                                                var param = Map<String, dynamic>();
                                                                                param['date'] = txtController1.text;
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
                                                                                  init();
                                                                                  var resData = await apiService.getcall(
                                                                                    'diesel/delete/${data['id']}',
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
                                                          // var data = Map<String, dynamic>();
                                                          // data['name'] = addcontactorname.text;
                                                          // data['user_id'] = userid.toString();
                                                          // var resData =
                                                          //     await apiService
                                                          //         .getcall(
                                                          //   'diesel/delete/${data['id']}',
                                                          // );
                                                          // if (resData['sucess'] ==
                                                          //     1) {
                                                          //   ToastMsg(
                                                          //     resData['message'],
                                                          //     15,
                                                          //     Colors.green,
                                                          //   );
                                                          //   init();
                                                          // }
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
                // Positioned(
                //   left: 0,
                //   right: 0,
                //   bottom: 0,
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(top: 10, bottom: 10),
                //         decoration: BoxDecoration(
                //           color: Colors.green[100],
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             Column(
                //               children: [
                //                 Text(
                //                   "Total used",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   "${totalused}",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             Column(
                //               children: [
                //                 Text(
                //                   "incoming",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   "${incoming}",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             Column(
                //               children: [
                //                 Text(
                //                   "Total Stock",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   "${totalstock}",
                //                   style: TextStyle(
                //                     fontFamily: "Century Gothic",
                //                     color: Colors.blue[900],
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                if (userType == 1)
                  Positioned(
                    bottom: 60,
                    left: 120,
                    child: TextButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
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
                                              left: 10, top: 10),
                                          child: Text(
                                            "Date",
                                            style: TextStyle(
                                              fontFamily: "Century Gothic",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: TextFormField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
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
                                        SizedBox(
                                          height: 20,
                                        ),
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
                                                  fontFamily: "Century Gothic",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // width: 165,
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 6, top: 10),
                                              child: TextFormField(
                                                controller: qtyltr,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter Qty Ltr";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Qty Ltr',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                                var data =
                                                    Map<String, dynamic>();
                                                data['date'] =
                                                    txtController3.text;
                                                data['user_id'] =
                                                    userid.toString();
                                                data['qty_ltr'] = qtyltr.text;
                                                var resData =
                                                    await apiService.postCall(
                                                        'diesel/addNewDiesel',
                                                        data);
                                                if (resData['success'] == 0) {
                                                  ToastMsg(
                                                    resData['message'],
                                                    15,
                                                    Colors.red,
                                                  );
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("Save"),
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
                              "Add Diesel",
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
