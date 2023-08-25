import 'dart:developer';
import 'dart:io';

import 'package:abc_2_1/admin/service.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Vehical extends StatefulWidget {
  const Vehical({super.key});

  @override
  State<Vehical> createState() => _VehicalState();
}

class _VehicalState extends State<Vehical> {
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

  final txtController3 = TextEditingController();
  final txtController = TextEditingController();
  final qtyltr = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  bool isExportPdfLoader = false;

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
  TextEditingController vehicalno = TextEditingController();
  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
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
    date.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
        "vihical?from_date=${txtController.text}&to_date=${txtController2.text}&offset=0&length=20&user_id=${userid}");
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

  bool isExportExcelLoader = false;

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
                                        "Vehical Report",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontFamily: "Century Gothic",
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
                                            'http://89.116.229.150:3003/api/vihical/downloadGetAllpdf?' +
                                                query);

                                        setState(() {
                                          isExportPdfLoader = false;
                                        });
                                        if (resData['success'] == 1) {
                                          openFile(
                                              url:
                                                   'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                              filename:
                                                  'vihical${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                                  'vehical${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                                              "Name",
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
                                              "Vehical No",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic"),
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
                                              "Registration Date",
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
                                              "RC Book",
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
                                              "PUC",
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
                                              "Fitness",
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
                                              "Form 10",
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
                                              "CNG Kit",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Century Gothic"),
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
                                                bottom: 5,
                                              ),
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 12,
                                                  bottom: 5,
                                                  right: 5),
                                              child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ServiceVehical(
                                                            vehicalId:
                                                                data['id'],
                                                          ),
                                                        ));
                                                  },
                                                  child: Text(
                                                    "${data['name']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
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
                                                  right: 10),
                                              child: Text(
                                                "${data['vehical']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 25,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['insurance']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5, bottom: 5),
                                              child: Text(
                                                "${data['registration_date']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 30,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['rc_book']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 50,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['puc']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 50,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['fitness']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 30,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['form_10']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 35,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['cng_kit']}",
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
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 10,
                                                  bottom: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
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
                                                                                editname,
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Please enter Vehical name";
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
                                                                                  param['insurance'] = editinsurance.text;
                                                                                  param['registration_date'] = editregistrationdate.text;
                                                                                  param['rc_book'] = editrcbook.text;
                                                                                  param['puc'] = editpuc.text;
                                                                                  param['fitness'] = editfitness.text;
                                                                                  param['form_10'] = editform10.text;
                                                                                  param['cng_kit'] = editcngkit.text;
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
                                                          'vihical/delete/${data['id']}',
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
                  right: 10,
                  bottom: 20,
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
                              initialChildSize: 0.9,
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
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker5,
                                                      controller: date,
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
                                                      "Vehical Name",
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
                                                      controller: name,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please Enter Vehical Name";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Vehical Name',
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
                                                      "Vehical No..",
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
                                                      controller: vehicalno,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Vehical No";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Vehical No',
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
                                                      "Insurance",
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
                                                      controller: insurance,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Insurance";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Insurance',
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
                                                      "Registration Date",
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
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker4,
                                                      controller:
                                                          registration_date,
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
                                                      "RC Book",
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
                                                      controller: rc_book,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter RC Book";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a RC Book  ',
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
                                                      "PUC",
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
                                                      controller: puc,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter PUC";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a PUC  ',
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
                                                      "Fitness",
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
                                                      controller: fitness,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Fitness";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Fitness  ',
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
                                                      "Form 10",
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
                                                      controller: form_10,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Form 10";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Form 10  ',
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
                                                      "CNG Kit",
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
                                                      controller: cng_kit,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter CNG Kit";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a CNG Kit  ',
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

                                                                  data['date'] =
                                                                      date.text;
                                                                  data['name'] =
                                                                      name.text;
                                                                  data['insurance'] =
                                                                      insurance
                                                                          .text;
                                                                  data['registration_date'] =
                                                                      registration_date
                                                                          .text;
                                                                  data['rc_book'] =
                                                                      rc_book
                                                                          .text;
                                                                  data['puc'] =
                                                                      puc.text;
                                                                  data['fitness'] =
                                                                      fitness
                                                                          .text;
                                                                  data['form_10'] =
                                                                      form_10
                                                                          .text;
                                                                  data['cng_kit'] =
                                                                      cng_kit
                                                                          .text;
                                                                  data['vehical'] =
                                                                      vehicalno
                                                                          .text;
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'vihical',
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
                                                                    date.text =
                                                                        '';
                                                                    name.text =
                                                                        '';
                                                                    insurance
                                                                        .text = '';
                                                                    registration_date
                                                                        .text = '';
                                                                    rc_book.text =
                                                                        '';
                                                                    puc.text =
                                                                        '';
                                                                    fitness.text =
                                                                        '';
                                                                    form_10.text =
                                                                        '';
                                                                    cng_kit.text =
                                                                        '';
                                                                    vehicalno
                                                                        .text = '';

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
                      children: [
                        SizedBox(
                          width: 100,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
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
                        const SizedBox(
                          width: 50,
                        ),
                        Container(
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
                                    fontFamily: "Century Gothic",
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
                        SizedBox(
                          width: 500,
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
                                              'http://89.116.229.150:3003/api/vihical/downloadGetAllpdf?' +
                                                  query);

                                          setState(() {
                                            isExportPdfLoader = false;
                                          });
                                          if (resData['success'] == 1) {
                                            openFile(
                                                url:
                                                     'http://89.116.229.150:3003/getfile?url=${resData['fileLink']}',
                                                filename:
                                                    'vehical${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.pdf');
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
                                                    'vehical${DateFormat('dd-MM-yyyy H-m-s').format(DateTime.now())}.xlsx');
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
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Table(
                                  border: TableBorder(
                                      horizontalInside: BorderSide(
                                    color: Colors.grey,
                                  )),
                                  defaultColumnWidth: FixedColumnWidth(
                                    200,
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
                                              "Name",
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
                                              "Vehical No",
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
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              "Insurance",
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
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              "Registration Date",
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
                                              "RC Book",
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
                                                top: 15, left: 45),
                                            child: Text(
                                              "PUC",
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
                                                top: 15, left: 30),
                                            child: Text(
                                              "Fitness",
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
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              "Form 10",
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
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              "CNG Kit",
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
                                                // textAlign: TextAlign.center,
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
                                                  left: 5,
                                                  bottom: 5,
                                                  right: 5),
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 12,
                                                  bottom: 5,
                                                  right: 5),
                                              child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ServiceVehical(
                                                            vehicalId:
                                                                data['id'],
                                                          ),
                                                        ));
                                                  },
                                                  child: Text(
                                                    "${data['name']}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Century Gothic",
                                                        fontSize: 15),
                                                  ),
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
                                              child: Text(
                                                "${data['vehical']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 25,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['insurance']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5, bottom: 5),
                                              child: Text(
                                                "${data['registration_date']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 30,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['rc_book']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 50,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['puc']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 50,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['fitness']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 30,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['form_10']}",
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
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 35,
                                                  bottom: 5,
                                                  right: 5),
                                              child: Text(
                                                "${data['cng_kit']}",
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
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  left: 10,
                                                  bottom: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
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
                                                        vehicalno.text =
                                                            data['cng_kit'];

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
                                                                                  param['insurance'] = editinsurance.text;
                                                                                  param['registration_date'] = editregistrationdate.text;
                                                                                  param['rc_book'] = editrcbook.text;
                                                                                  param['puc'] = editpuc.text;
                                                                                  param['fitness'] = editfitness.text;
                                                                                  param['form_10'] = editform10.text;
                                                                                  param['cng_kit'] = editcngkit.text;
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
                                                          'vihical/delete/${data['id']}',
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                              initialChildSize: 0.9,
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
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker5,
                                                      controller: date,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please Vehical Enter Date";
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
                                                      "Vehical Name",
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
                                                      controller: name,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please Vehical enter Name";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Name',
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
                                                      "Vehical No",
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
                                                      controller: vehicalno,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Vehical No";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Vehical No',
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
                                                      "Insurance",
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
                                                      controller: insurance,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Insurance";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Insurance',
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
                                                      "Registration Date",
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
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Date',
                                                      ),
                                                      onTap: _selDatePicker4,
                                                      controller:
                                                          registration_date,
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
                                                      "RC Book",
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
                                                      controller: rc_book,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter RC Book";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a RC Book  ',
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
                                                      "PUC",
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
                                                      controller: puc,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter PUC";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a PUC  ',
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
                                                      "Fitness",
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
                                                      controller: fitness,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Fitness";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Fitness  ',
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
                                                      "Form 10",
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
                                                      controller: form_10,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please enter Form 10";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a Form 10  ',
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
                                                      "CNG Kit",
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
                                                      controller: cng_kit,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'Enter a CNG Kit  ',
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

                                                                  data['date'] =
                                                                      date.text;
                                                                  data['name'] =
                                                                      name.text;
                                                                  data['insurance'] =
                                                                      insurance
                                                                          .text;
                                                                  data['registration_date'] =
                                                                      registration_date
                                                                          .text;
                                                                  data['rc_book'] =
                                                                      rc_book
                                                                          .text;
                                                                  data['puc'] =
                                                                      puc.text;
                                                                  data['fitness'] =
                                                                      fitness
                                                                          .text;
                                                                  data['form_10'] =
                                                                      form_10
                                                                          .text;
                                                                  data['cng_kit'] =
                                                                      cng_kit
                                                                          .text;
                                                                  data['vehical'] =
                                                                      vehicalno
                                                                          .text;
                                                                  data['user_id'] =
                                                                      userid
                                                                          .toString();

                                                                  print(data);
                                                                  var login = await apiService
                                                                      .postCall(
                                                                          'vihical',
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
                                                                    date.text =
                                                                        '';
                                                                    name.text =
                                                                        '';
                                                                    insurance
                                                                        .text = '';
                                                                    registration_date
                                                                        .text = '';
                                                                    rc_book.text =
                                                                        '';
                                                                    puc.text =
                                                                        '';
                                                                    fitness.text =
                                                                        '';
                                                                    form_10.text =
                                                                        '';
                                                                    cng_kit.text =
                                                                        '';
                                                                    vehicalno
                                                                        .text = '';

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
