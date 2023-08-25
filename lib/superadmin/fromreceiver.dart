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

class Fromreceiver extends StatefulWidget {
  Fromreceiver({Key? key, this.name, this.id, required this.refresh})
      : super(key: key);
  final name;
  final id;
  final void Function(Map<String, dynamic> filters) refresh;
  @override
  State<Fromreceiver> createState() => _FromreceiverState();
}

class _FromreceiverState extends State<Fromreceiver> {
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
        // init();
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
      });
    });
  }

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
  late SharedPreferences pref;
  ApiService apiService = ApiService();
  var userid;
  List itemdrop = [];
  String itemdropchoose = '';
  List userData = [];
  TextEditingController editreceivername = TextEditingController();
  TextEditingController editqty = TextEditingController();
  bool isExportPdfLoader = false;
  bool isExportExcelLoader = false;
  TextEditingController items1 = TextEditingController();
  TextEditingController items2 = TextEditingController();
  TextEditingController txtController1 = TextEditingController();
  List searchUSer = [];
  var contractornameid;
  List materialUSer = [];
  var materialnameid;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    userid = pref.getInt("user_id");
    getitem();
    getuser();
  }

  getitem() async {
    var resdata = await apiService.getCall(
        "http://89.116.229.150:3003/api/assetTransfer/getUserWiseItem/${widget.id}");
    log("${resdata}");
    setState(() {
      itemdrop = resdata["data"];
    });
  }

  getuser() async {
    var resdata = await apiService.getCall(
        "http://89.116.229.150:3003/api/assetTransfer/getAssestByName?from_date=${txtController.text}&to_date=${txtController2.text}&user_id=${userid}&receivername=${widget.name}");
    // "http://89.116.229.150:3003/api/assetTransfer/getAssestByName/${widget.id}/${widget.name}");
    log("${resdata}");
    setState(() {
      userData = resdata["data"];
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

  getuserbyItem() async {
    var item = new Map<String, dynamic>();
    
    item['receivername'] = widget.name;
    item['id'] = widget.id;
    item['item'] = itemdropchoose;
    item['from_date'] = txtController.text;
    item['to_date'] = txtController2.text;
    var resdata =
        await apiService.postCall("assetTransfer/getAssestByItem", item);
    log("${resdata}");
    setState(() {
      userData = resdata["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return Scaffold(
            body: Container(
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
                                      "Asset transfer details",
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
                      // TextButton(
                      //   onPressed: () {
                      //     showDialog<void>(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: const Text(
                      //             'Add Item',
                      //             style: TextStyle(
                      //               fontFamily: "Century Gothic",
                      //             ),
                      //           ),
                      //           actions: <Widget>[
                      //             Column(
                      //               children: [
                      //                 TextFormField(
                      //                   controller: additemname,
                      //                   validator: (value) {
                      //                     if (value == null ||
                      //                         value.isEmpty) {
                      //                       return "Please enter Item";
                      //                     }
                      //                     return null;
                      //                   },
                      //                   decoration: InputDecoration(
                      //                     border: OutlineInputBorder(),
                      //                     hintText: 'Item',
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Container(
                      //                   width: MediaQuery.of(context)
                      //                       .size
                      //                       .width,
                      //                   child: ElevatedButton(
                      //                     style: ElevatedButton.styleFrom(
                      //                       primary: Colors.green[100],
                      //                       onPrimary: Colors.blue[900],
                      //                     ),
                      //                     onPressed: () async {
                      //                       if (additemname
                      //                           .text.isEmpty) {
                      //                         ToastMsg(
                      //                           "Please enter Item",
                      //                           15,
                      //                           Colors.red,
                      //                         );
                      //                       } else {
                      //                         var param =
                      //                             Map<String, dynamic>();
                      //                         param['name'] =
                      //                             additemname.text;
                      //                         param['user_id'] = userid;
                      //                         // param['id'] =
                      //                         //     data['id'];
                      //                         var resData =
                      //                             await apiService.postCall(
                      //                                 'assetTransfer/addItem',
                      //                                 param);

                      //                         if (resData['success'] ==
                      //                             0) {
                      //                           ToastMsg(
                      //                             resData['message'],
                      //                             15,
                      //                             Colors.red,
                      //                           );
                      //                         } else {
                      //                           Navigator.pop(context);
                      //                           ToastMsg(
                      //                             resData['message'],
                      //                             15,
                      //                             Colors.green,
                      //                           );
                      //                         }
                      //                       }
                      //                     },
                      //                     child: Text("Save"),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 10,
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //         color: Colors.green[100],
                      //         borderRadius: BorderRadius.circular(20)),
                      //     child: Row(
                      //       children: [
                      //         Icon(
                      //           Icons.add,
                      //           color: Colors.blue[900],
                      //         ),
                      //         Text(
                      //           "Add Item",
                      //           style: TextStyle(
                      //             color: Colors.blue[900],
                      //             fontFamily: "Century Gothic",
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
                      // Container(
                      //   margin: EdgeInsets.only(top: 20, right: 20),
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/pdf.png',
                      //         height: 40,
                      //         // color: Colors.blue,
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       Image.asset(
                      //         'assets/exel.png',
                      //         height: 40,
                      //         // color: Colors.blue,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Container(
                        margin: EdgeInsets.only(top: 20, right: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: isExportPdfLoader
                                  ? null
                                  : () async {
                                      var query = '';
                                      query += 'id=${widget.id.toString()}';
                                      query += '&name=${widget.name}';
                                      query +=
                                          '&item=${itemdropchoose.toString()}';
                                      // from_date=${txtController.text}&to_date=${txtController2.text}
                                      if (txtController.text != '') {
                                        query +=
                                            '&from_date=${txtController.text}';
                                      }

                                      if (txtController2.text != '') {
                                        query +=
                                            '&to_date=${txtController2.text}';
                                      }
                                      // query +=
                                      //     '&type=${_selectedIndex + 1}';
                                      log('query $query');
                                      setState(() {
                                        isExportPdfLoader = true;
                                      });
                                      var resData = await apiService.getCall(
                                          'http://89.116.229.150:3003/api/assetTransfer/downloadAssetAllByNamePdf?' +
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
                                      query += 'id=${widget.id.toString()}';
                                      query +=
                                          '&name=${widget.name.toString()}';
                                      query +=
                                          '&item=${itemdropchoose.toString()}';
                                      // from_date=${txtController.text}&to_date=${txtController2.text}
                                      if (txtController.text != '') {
                                        query +=
                                            '&from_date=${txtController.text}';
                                      }
                                      // query +=
                                      //     '&type=${_selectedIndex + 1}';
                                      if (txtController2.text != '') {
                                        query +=
                                            '&to_date=${txtController2.text}';
                                      }
                                      log('query $query');
                                      setState(() {
                                        isExportExcelLoader = true;
                                      });
                                      var resData = await apiService.getCall(
                                          'http://89.116.229.150:3003/api/assetTransfer/downloadAssetAllByNameExcel?' +
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
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    margin:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        hint: Text("Select Item"),
                        value: itemdropchoose.isEmpty ? null : itemdropchoose,
                        onChanged: (String? newValue) async {
                          setState(() {
                            itemdropchoose = newValue!;
                            log("${itemdropchoose}");
                            getuserbyItem();
                          });
                        },
                        items: [
                          for (var data in itemdrop)
                            DropdownMenuItem<String>(
                              value: '${data['id']}',
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "${data['name']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                        ]),
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
                              padding: EdgeInsets.only(top: 10),
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
                                      80.0,
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
                                                "Receiver Name",
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
                                                "Item",
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
                                                "Action",
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
                                        ],
                                      ),
                                      for (var data in userData)
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
                                                  "${data['receivername']}",
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
                                                  "${data['item_name']}",
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
                                                          // addcontactorname.text =
                                                          //     data['contractorname'];
                                                          // labourfullday.text =
                                                          //     data['labourfullday'].toString();
                                                          // labourothrs.text =
                                                          //     data['labourothrs'].toString();
                                                          log("${data}");
                                                          editreceivername
                                                                  .text =
                                                              data[
                                                                  'receivername'];
                                                          editqty.text =
                                                              data['qty']
                                                                  .toString();
                                                          txtController1.text =
                                                              data['date'];
                                                          items2.text =
                                                              data['item_name'];
                                                          contractornameid =
                                                              data['item'];
                                                          log("con : ${contractornameid}");
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit From Receiver'),
                                                                actions: <
                                                                    Widget>[
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
                                                                      TextFormField(
                                                                        controller:
                                                                            editreceivername,
                                                                        validator:
                                                                            (value) {
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
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TypeAheadFormField(
                                                                        textFieldConfiguration:
                                                                            TextFieldConfiguration(
                                                                          controller:
                                                                              items2,
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
                                                                          var param = Map<
                                                                              String,
                                                                              dynamic>();
                                                                          param['name'] =
                                                                              pattern;
                                                                          param['user_id'] =
                                                                              data["user_id"];
                                                                          return await apiService.getUserSuggestion(
                                                                              'assetTransfer/searchItemName',
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
                                                                          items2.text =
                                                                              suggestion['name'];
                                                                          contractornameid =
                                                                              suggestion['id'].toString();
                                                                          log('contractornameid : ${contractornameid}');
                                                                        },
                                                                        validator:
                                                                            (value) {
                                                                          if (value == "" ||
                                                                              value == null ||
                                                                              value.isEmpty) {
                                                                            return "Item is required, Please enter Item";
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
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
                                                                              'Qty',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['date'] =
                                                                                txtController1.text;
                                                                            param['receivername'] =
                                                                                editreceivername.text;
                                                                            param['item'] =
                                                                                contractornameid;
                                                                            param['qty'] =
                                                                                editqty.text;
                                                                            param["type"] =
                                                                                data['type'];
                                                                            param['id'] =
                                                                                data['id'];
                                                                            var resData =
                                                                                await apiService.postCall('assetTransfer/edit', param);
                                                                            if (resData['success'] ==
                                                                                0) {
                                                                              ToastMsg(
                                                                                resData['message'],
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              ToastMsg(
                                                                                resData['message'],
                                                                                15,
                                                                                Colors.green,
                                                                              );
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
                                                          size: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
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
                                                                                    'assetTransfer/delete/${data['id']}',
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                  if (resData['success'] == 1) {
                                                                                    ToastMsg(
                                                                                      resData['message'],
                                                                                      15,
                                                                                      Colors.green,
                                                                                    );
                                                                                    widget.refresh({
                                                                                      'refresh': true
                                                                                    });
                                                                                  } else {
                                                                                    ToastMsg(
                                                                                      resData['message'],
                                                                                      15,
                                                                                      Colors.red,
                                                                                    );
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
          );
        } else {
          return Scaffold(
            body: Container(
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
                                      "Asset transfer details",
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
                      // TextButton(
                      //   onPressed: () {
                      //     showDialog<void>(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: const Text(
                      //             'Add Item',
                      //             style: TextStyle(
                      //               fontFamily: "Century Gothic",
                      //             ),
                      //           ),
                      //           actions: <Widget>[
                      //             Column(
                      //               children: [
                      //                 TextFormField(
                      //                   controller: additemname,
                      //                   validator: (value) {
                      //                     if (value == null ||
                      //                         value.isEmpty) {
                      //                       return "Please enter Item";
                      //                     }
                      //                     return null;
                      //                   },
                      //                   decoration: InputDecoration(
                      //                     border: OutlineInputBorder(),
                      //                     hintText: 'Item',
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Container(
                      //                   width: MediaQuery.of(context)
                      //                       .size
                      //                       .width,
                      //                   child: ElevatedButton(
                      //                     style: ElevatedButton.styleFrom(
                      //                       primary: Colors.green[100],
                      //                       onPrimary: Colors.blue[900],
                      //                     ),
                      //                     onPressed: () async {
                      //                       if (additemname
                      //                           .text.isEmpty) {
                      //                         ToastMsg(
                      //                           "Please enter Item",
                      //                           15,
                      //                           Colors.red,
                      //                         );
                      //                       } else {
                      //                         var param =
                      //                             Map<String, dynamic>();
                      //                         param['name'] =
                      //                             additemname.text;
                      //                         param['user_id'] = userid;
                      //                         // param['id'] =
                      //                         //     data['id'];
                      //                         var resData =
                      //                             await apiService.postCall(
                      //                                 'assetTransfer/addItem',
                      //                                 param);

                      //                         if (resData['success'] ==
                      //                             0) {
                      //                           ToastMsg(
                      //                             resData['message'],
                      //                             15,
                      //                             Colors.red,
                      //                           );
                      //                         } else {
                      //                           Navigator.pop(context);
                      //                           ToastMsg(
                      //                             resData['message'],
                      //                             15,
                      //                             Colors.green,
                      //                           );
                      //                         }
                      //                       }
                      //                     },
                      //                     child: Text("Save"),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 10,
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //         color: Colors.green[100],
                      //         borderRadius: BorderRadius.circular(20)),
                      //     child: Row(
                      //       children: [
                      //         Icon(
                      //           Icons.add,
                      //           color: Colors.blue[900],
                      //         ),
                      //         Text(
                      //           "Add Item",
                      //           style: TextStyle(
                      //             color: Colors.blue[900],
                      //             fontFamily: "Century Gothic",
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
                                  fontFamily: "Century Gothic",
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
                                      query += 'id=${widget.id.toString()}';
                                      query += '&name=${widget.name}';
                                      query +=
                                          '&item=${itemdropchoose.toString()}';
                                      // from_date=${txtController.text}&to_date=${txtController2.text}
                                      if (txtController.text != '') {
                                        query +=
                                            '&from_date=${txtController.text}';
                                      }

                                      if (txtController2.text != '') {
                                        query +=
                                            '&to_date=${txtController2.text}';
                                      }
                                      // query +=
                                      //     '&type=${_selectedIndex + 1}';
                                      log('query $query');
                                      setState(() {
                                        isExportPdfLoader = true;
                                      });
                                      var resData = await apiService.getCall(
                                          'http://89.116.229.150:3003/api/assetTransfer/downloadAssetAllByNamePdf?' +
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
                                      query += 'id=${widget.id.toString()}';
                                      query +=
                                          '&name=${widget.name.toString()}';
                                      query +=
                                          '&item=${itemdropchoose.toString()}';
                                      // from_date=${txtController.text}&to_date=${txtController2.text}
                                      if (txtController.text != '') {
                                        query +=
                                            '&from_date=${txtController.text}';
                                      }
                                      // query +=
                                      //     '&type=${_selectedIndex + 1}';
                                      if (txtController2.text != '') {
                                        query +=
                                            '&to_date=${txtController2.text}';
                                      }
                                      log('query $query');
                                      setState(() {
                                        isExportExcelLoader = true;
                                      });
                                      var resData = await apiService.getCall(
                                          'http://89.116.229.150:3003/api/assetTransfer/downloadAssetAllByNameExcel?' +
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
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    margin:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        hint: Text("Select Item"),
                        value: itemdropchoose.isEmpty ? null : itemdropchoose,
                        onChanged: (String? newValue) async {
                          setState(() {
                            itemdropchoose = newValue!;
                            log("${itemdropchoose}");
                            getuserbyItem();
                          });
                        },
                        items: [
                          for (var data in itemdrop)
                            DropdownMenuItem<String>(
                              value: '${data['id']}',
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "${data['name']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                        ]),
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
                              padding: EdgeInsets.only(top: 10),
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
                                      300.0,
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
                                                "Receiver Name",
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
                                                "Item",
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
                                                "Action",
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
                                        ],
                                      ),
                                      for (var data in userData)
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
                                                  "${data['receivername']}",
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
                                                  "${data['item_name']}",
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
                                                          editreceivername
                                                                  .text =
                                                              data[
                                                                  'receivername'];
                                                          editqty.text =
                                                              data['qty']
                                                                  .toString();
                                                          txtController1.text =
                                                              data['date'];
                                                          // addcontactorname.text =
                                                          //     data['contractorname'];
                                                          // labourfullday.text =
                                                          //     data['labourfullday'].toString();
                                                          // labourothrs.text =
                                                          //     data['labourothrs'].toString();

                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Edit From Receiver'),
                                                                actions: <
                                                                    Widget>[
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
                                                                      TextFormField(
                                                                        controller:
                                                                            editreceivername,
                                                                        validator:
                                                                            (value) {
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
                                                                                data['item_name'];
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
                                                                            if (textEditingValue.text ==
                                                                                '') {
                                                                              return const Iterable<String>.empty();
                                                                            } else {
                                                                              List<String> serachdata = [];
                                                                              var param = Map<String, dynamic>();
                                                                              param['name'] = textEditingValue.text;
                                                                              param['user_id'] = data['user_id'];
                                                                              var resdata = await apiService.getUserSuggestion('assetTransfer/searchItemName', param);
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
                                                                            getid =
                                                                                searchUSer.where((x) => x['name'].toLowerCase().contains(suggestion.toLowerCase())).toList();
                                                                            log("getid ${getid}");
                                                                            for (var item
                                                                                in getid) {
                                                                              if (item['name'] == suggestion) {
                                                                                contractornameid = item['id'];
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
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
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
                                                                              'Qty',
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
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
                                                                            var param =
                                                                                Map<String, dynamic>();
                                                                            param['date'] =
                                                                                txtController1.text;
                                                                            param['receivername'] =
                                                                                editreceivername.text;
                                                                            param['item'] =
                                                                                contractornameid;
                                                                            param['qty'] =
                                                                                editqty.text;
                                                                            param["type"] =
                                                                                data['type'];
                                                                            param['id'] =
                                                                                data['id'];
                                                                            var resData =
                                                                                await apiService.postCall('assetTransfer/edit', param);
                                                                            if (resData['success'] ==
                                                                                0) {
                                                                              ToastMsg(
                                                                                resData['message'],
                                                                                15,
                                                                                Colors.red,
                                                                              );
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              ToastMsg(
                                                                                resData['message'],
                                                                                15,
                                                                                Colors.green,
                                                                              );
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
                                                          size: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
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
                                                                                    'assetTransfer/delete/${data['id']}',
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                  if (resData['success'] == 1) {
                                                                                    ToastMsg(
                                                                                      resData['message'],
                                                                                      15,
                                                                                      Colors.green,
                                                                                    );
                                                                                    widget.refresh({
                                                                                      'refresh': true
                                                                                    });
                                                                                  } else {
                                                                                    ToastMsg(
                                                                                      resData['message'],
                                                                                      15,
                                                                                      Colors.red,
                                                                                    );
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
          );
        }
      }),
    );
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
