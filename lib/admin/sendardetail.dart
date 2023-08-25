import 'dart:developer';

import 'dart:io';

import 'package:abc_2_1/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sendardetail extends StatefulWidget {
  Sendardetail({Key? key, required this.name}) : super(key: key);
  final name;
  @override
  State<Sendardetail> createState() => _SendardetailState();
}

class _SendardetailState extends State<Sendardetail> {
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
  bool isExportExcelLoader = false;
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

  ApiService apiService = ApiService();
  List itemdrop = [];
  List userData = [];
  String itemdropchoose = '';
  late SharedPreferences pref;
  var userid;
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
        "http://89.116.229.150:3003/api/assetTransfer/getUserWiseItem/${userid}");
    // log("${resdata}");
    setState(() {
      itemdrop = resdata["data"];
    });
  }

  getuser() async {
    var resdata = await apiService.getCall(
        "http://89.116.229.150:3003/api/assetTransfer/getAssestByName?from_date=${txtController.text}&to_date=${txtController2.text}&user_id=${userid}&receivername=${widget.name}");
    // "http://89.116.229.150:3003/api/assetTransfer/getAssestByName/${userid}/${widget.name}");
    log("${resdata}");
    setState(() {
      userData = resdata["data"];
    });
  }

  getuserbyItem() async {
    var item = new Map<String, dynamic>();
    item['receivername'] = widget.name;
    item['user_id'] = userid;
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

  final ScrollController _horizontal = ScrollController();
  final _vertical = ScrollController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return SafeArea(
          child: Scaffold(
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
                      Container(
                        margin: EdgeInsets.only(top: 20, right: 20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: isExportPdfLoader
                                  ? null
                                  : () async {
                                      var query = '';
                                      query += 'id=${userid.toString()}';
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
                                      query += 'id=${userid.toString()}';
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
                              padding: EdgeInsets.only(top: 30),
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
                                      130.0,
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
                                                "Sendar Name",
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
                                          ],
                                        ),

                                      // for (var data in materials)
                                      //   TableRow(
                                      //     children: [
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['date']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['suppliername']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['material']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['qty']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['unit']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['vehicle_no']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['challan_no']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),

                                      //     ],
                                      //   ),
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
        return SafeArea(
          child: Scaffold(
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
                                      query += 'id=${userid.toString()}';
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
                                      query += 'id=${userid.toString()}';
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
                              padding: EdgeInsets.only(top: 30),
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
                                      450.0,
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
                                                "Sendar Name",
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
                                          ],
                                        ),

                                      // for (var data in materials)
                                      //   TableRow(
                                      //     children: [
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['date']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['suppliername']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['material']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['qty']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['unit']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['vehicle_no']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       TableCell(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.all(5.0),
                                      //           child: Text(
                                      //             "${data['challan_no']}",
                                      //             style: TextStyle(
                                      //               color: Colors.black,
                                      //               fontFamily:
                                      //                   "Century Gothic",
                                      //               fontSize: 15,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),

                                      //     ],
                                      //   ),
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
