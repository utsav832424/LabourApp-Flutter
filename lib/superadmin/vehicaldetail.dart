import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/apiservice.dart';
import 'package:abc_2_1/superadmin/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Vehicaldetail extends StatefulWidget {
  Vehicaldetail({Key? key, required this.user_id, required this.refresh})
      : super(key: key);
  final user_id;
  final void Function(Map<String, dynamic> filters) refresh;

  @override
  State<Vehicaldetail> createState() => _VehicaldetailState();
}

class _VehicaldetailState extends State<Vehicaldetail> {
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

  bool isExportPdfLoader = false;
  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  TextEditingController date = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController insurance = TextEditingController();
  TextEditingController registration_date = TextEditingController();
  TextEditingController rc_book = TextEditingController();
  TextEditingController puc = TextEditingController();
  TextEditingController fitness = TextEditingController();
  TextEditingController form_10 = TextEditingController();
  TextEditingController cng_kit = TextEditingController();
  TextEditingController editinsurance = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController editregistrationdate = TextEditingController();
  TextEditingController editrcbook = TextEditingController();
  TextEditingController editpuc = TextEditingController();
  TextEditingController editfitness = TextEditingController();
  TextEditingController editform10 = TextEditingController();
  TextEditingController editcngkit = TextEditingController();
  TextEditingController editvehical = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  TextEditingController txtController5 = TextEditingController();
  void _selDatePicker7() {
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

  void _selDatePicker8() {
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
        txtController5.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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
        init();
      });
    });
  }

  bool isExportExcelLoader = false;

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List diesel = [];
  var ErrorMessage = "";
  late SharedPreferences prefs;
  ApiService apiService = ApiService();

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
        "vihical?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${widget.user_id}");
    log("${resData}");
    if (mounted) {
      setState(() {
        diesel = resData['data'];
        loader = false;
      });
    }
  }

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
        registration_date.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  void _selDatePicker6() {
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
        editregistrationdate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        init();
      });
    });
  }

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
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
        // txtController.text = DateFormat.yMd().format(pickedDate);
        date.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      "Vehical Report",
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
                                    fontFamily: "Century Gothic",
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
                                            'http://89.116.229.150:3003/api/vihical/downloadGetAllPdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'vihicalRSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                            'http://89.116.229.150:3003/api/vihical/downloadGetAllExcel?' +
                                                query);
                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'vehicalRSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                      border: TableBorder(
                                          horizontalInside: BorderSide(
                                        color: Colors.grey,
                                      )),
                                      defaultColumnWidth: FixedColumnWidth(
                                        85,
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
                                                    fontFamily:
                                                        "Century Gothic",
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
                                                  "Name",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Century Gothic",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 15, right: 18),
                                                child: Text(
                                                  "Insurance",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Registration Date",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "RC Book",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "PUC",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Fitness",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Form 10",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "CNG Kit",
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
                                            TableCell(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  "Vehical No",
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 5,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['date']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 12,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SServiceVehical(
                                                              vehicalId:
                                                                  data['id'],
                                                            ),
                                                          ));
                                                    },
                                                    child: Text(
                                                      "${data['name']}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Century Gothic",
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 25,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['insurance']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 5,
                                                          bottom: 5),
                                                  child: Text(
                                                    "${data['registration_date']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 30,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['rc_book']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 50,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['puc']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 50,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['fitness']}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "Century Gothic",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 30,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['form_10']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 35,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['cng_kit']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          left: 35,
                                                          bottom: 5,
                                                          right: 5),
                                                  child: Text(
                                                    "${data['vehical']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
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
                                                            log("${data}");
                                                            txtController1
                                                                    .text =
                                                                data['date'];
                                                            editinsurance.text =
                                                                data[
                                                                    'insurance'];
                                                            editname.text =
                                                                data['name'];
                                                            editregistrationdate
                                                                    .text =
                                                                data[
                                                                    'registration_date'];
                                                            editrcbook.text =
                                                                data['rc_book'];
                                                            editpuc.text =
                                                                data['puc'];
                                                            editfitness.text =
                                                                data['fitness'];
                                                            editform10.text =
                                                                data['form_10'];
                                                            editcngkit.text =
                                                                data['cng_kit'];
                                                            editvehical.text =
                                                                data['vehical'];

                                                            showDialog<void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Edit Vehicle Report'),
                                                                  actions: <
                                                                      Widget>[
                                                                    Container(
                                                                      height:
                                                                          300,
                                                                      child:
                                                                          ListView(
                                                                        children: [
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                txtController1,
                                                                            onTap:
                                                                                _selDatePicker7,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter date";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a date',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editname,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter name";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a name',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editinsurance,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter insurance";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a insurance',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            // margin:
                                                                            //     EdgeInsets.only(
                                                                            //   left:
                                                                            //       10,
                                                                            //   right:
                                                                            //       10,
                                                                            // ),
                                                                            child:
                                                                                TextFormField(
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a RegistrationDate',
                                                                              ),
                                                                              onTap: _selDatePicker6,
                                                                              controller: editregistrationdate,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter RegistrationDate";
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
                                                                                editrcbook,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter RC Book";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Rc book',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editpuc,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter PUC";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a PUC',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editfitness,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Fitness";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Fitness',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editform10,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Form 10";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Form 10',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editcngkit,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter CNG kit";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a CNG Kit',
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            // readOnly: true,
                                                                            controller:
                                                                                editvehical,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Vehical No";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                              hintText: 'Enter a Vehical No',
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
                                                                                if (editinsurance.text.isEmpty) {
                                                                                  ToastMsg(
                                                                                    "Please enter insurance",
                                                                                    15,
                                                                                    Colors.red,
                                                                                  );
                                                                                } else {
                                                                                  var param = Map<String, dynamic>();
                                                                                  param['date'] = txtController1.text;
                                                                                  param['name'] = editname.text;
                                                                                  param['insurance'] = editinsurance.text;
                                                                                  param['registration_date'] = editregistrationdate.text;
                                                                                  param['rc_book'] = editrcbook.text;
                                                                                  param['puc'] = editpuc.text;
                                                                                  param['fitness'] = editfitness.text;
                                                                                  param['form_10'] = editform10.text;
                                                                                  param['cng_kit'] = editcngkit.text;
                                                                                  param['vehical'] = editvehical.text;
                                                                                  param['id'] = data['id'];
                                                                                  var resData = await apiService.postCall('vihical/editMachinery', param);
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
                                                                              child: Text(
                                                                                "Save",
                                                                              ),
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
                                                                  title: Container(
                                                                      padding: EdgeInsets.only(
                                                                        top: 10,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
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
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
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
                                                                                      'vihical/delete/${data['id']}',
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
                                        "Vehical Report",
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
                                            'http://89.116.229.150:3003/api/vihical/downloadGetAllPdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'vihicalRSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                            'http://89.116.229.150:3003/api/vihical/downloadGetAllExcel?' +
                                                query);

                                        setState(() {
                                          isExportExcelLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                  'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'vehicalRSuper${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                padding: EdgeInsets.only(top: 30),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    border: TableBorder(
                                        horizontalInside: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    defaultColumnWidth: FixedColumnWidth(
                                      160,
                                    ),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 15,
                                                  left: 10,
                                                  bottom: 15),
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
                                                  left: 10,
                                                  bottom: 15),
                                              child: Text(
                                                "Name",
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
                                                  right: 18,
                                                  bottom: 15),
                                              child: Text(
                                                "Insurance",
                                                // textAlign: TextAlign.center,
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
                                                  top: 15, bottom: 15),
                                              child: Text(
                                                "Registration Date",
                                                // textAlign: TextAlign.center,
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
                                                  left: 10,
                                                  bottom: 15),
                                              child: Text(
                                                "RC Book",
                                                // textAlign: TextAlign.center,
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
                                                  left: 40,
                                                  bottom: 15),
                                              child: Text(
                                                "PUC",
                                                // textAlign: TextAlign.center,
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
                                                  left: 28,
                                                  bottom: 15),
                                              child: Text(
                                                "Fitness",
                                                // textAlign: TextAlign.center,
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
                                                  left: 15,
                                                  bottom: 15),
                                              child: Text(
                                                "Form 10",
                                                // textAlign: TextAlign.center,
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
                                                  left: 15,
                                                  bottom: 15),
                                              child: Text(
                                                "CNG Kit",
                                                // textAlign: TextAlign.center,
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
                                                  left: 15,
                                                  bottom: 15),
                                              child: Text(
                                                "Vehical No",
                                                // textAlign: TextAlign.center,
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
                                                margin: EdgeInsets.only(
                                                    top: 15,
                                                    left: 10,
                                                    bottom: 15),
                                                child: Text(
                                                  "Action",
                                                  // textAlign: TextAlign.center,
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
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 5,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  "${data['date']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    left: 12,
                                                    bottom: 5,
                                                    right: 5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SServiceVehical(
                                                            vehicalId:
                                                                data['id'],
                                                          ),
                                                        ));
                                                  },
                                                  child: Text(
                                                    "${data['name']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
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
                                                  "${data['insurance']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "Century Gothic",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, left: 5, bottom: 5),
                                                child: Text(
                                                  "${data['registration_date']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    right: 5),
                                                child: Text(
                                                  "${data['rc_book']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    left: 50,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  "${data['puc']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    left: 50,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Text(
                                                  "${data['fitness']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    right: 5),
                                                child: Text(
                                                  "${data['form_10']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    right: 5),
                                                child: Text(
                                                  "${data['cng_kit']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                    right: 5),
                                                child: Text(
                                                  "${data['vehical']}",
                                                  style: TextStyle(
                                                      fontSize: 15,
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
                                                          log("${data}");
                                                          txtController1.text =
                                                              data['date'];
                                                          editinsurance.text =
                                                              data['insurance'];
                                                          editname.text =
                                                              data['name'];
                                                          editregistrationdate
                                                                  .text =
                                                              data[
                                                                  'registration_date'];
                                                          editrcbook.text =
                                                              data['rc_book'];
                                                          editpuc.text =
                                                              data['puc'];
                                                          editfitness.text =
                                                              data['fitness'];
                                                          editform10.text =
                                                              data['form_10'];
                                                          editcngkit.text =
                                                              data['cng_kit'];
                                                          editvehical.text =
                                                              data['vehical'];

                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit Vehical Name'),
                                                                actions: [
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: txtController1,
                                                                              onTap: _selDatePicker7,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter date";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a date',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editname,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter name";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a name',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editinsurance,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter insurance";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a insurance',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a RegistrationDate',
                                                                              ),
                                                                              onTap: _selDatePicker6,
                                                                              controller: editregistrationdate,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter RegistrationDate";
                                                                                }
                                                                                return null;
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editrcbook,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter RC Book";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a Rc book',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editpuc,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter PUC";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a PUC',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editfitness,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter Fitness";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a Fitness',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editform10,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter Form 10";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a Form 10',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editcngkit,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter CNG kit";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a CNG Kit',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              // readOnly: true,
                                                                              controller: editvehical,
                                                                              validator: (value) {
                                                                                if (value == null || value.isEmpty) {
                                                                                  return "Please enter Vehical No";
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter a Vehical No',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
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
                                                                            if (editinsurance.text.isEmpty) {
                                                                              ToastMsg(
                                                                                "Please enter insurance",
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              var param = Map<String, dynamic>();
                                                                              param['date'] = txtController1.text;
                                                                              param['name'] = editname.text;
                                                                              param['insurance'] = editinsurance.text;
                                                                              param['registration_date'] = editregistrationdate.text;
                                                                              param['rc_book'] = editrcbook.text;
                                                                              param['puc'] = editpuc.text;
                                                                              param['fitness'] = editfitness.text;
                                                                              param['form_10'] = editform10.text;
                                                                              param['cng_kit'] = editcngkit.text;
                                                                              param['vehical'] = editvehical.text;
                                                                              param['id'] = data['id'];
                                                                              var resData = await apiService.postCall('vihical/editMachinery', param);
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
                                                                                  var resData = await apiService.getcall(
                                                                                    'vihical/delete/${data['id']}',
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
