import 'package:abc_2_1/admin/receiverdetail.dart';
import 'package:abc_2_1/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fromto extends StatefulWidget {
  Fromto({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  State<Fromto> createState() => _FromtoState();
}

class _FromtoState extends State<Fromto> {
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

  // void _loadMore() async {
  //   var param = new Map<String, dynamic>();
  //   param['user_id'] = userid.toString();
  //   var resData = await apiService.getcall(
  //       "labour?from_date=${widget.fromdate}&to_date=${widget.todate}&offset=0&length=20");
  // }

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
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(6),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "DATE",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, right: 20),
                            child: Text(
                              "Receiver Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var item in widget.data)
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['date']}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          Receiverdetail(
                                              name: item['receivername']),
                                    ),
                                  );
                                },

                                // onTap: widget.type == 1
                                //     ? () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => SContractorDetail(
                                //                     contractor_id:
                                //                         data['contractorname_id'],
                                //                     tabindex: 0,
                                //                   )),
                                //         );
                                //       }
                                //     : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${item['receivername']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
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
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['qty']}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
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
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(6),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            child: Text(
                              "DATE",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, right: 20),
                            child: Text(
                              "Receiver Name",
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var item in widget.data)
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['date']}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Receiverdetail(
                                        name: item['receivername']),
                                  ),
                                );
                              },
                              // onTap: widget.type == 1
                              //     ? () {
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => SContractorDetail(
                              //                     contractor_id:
                              //                         data['contractorname_id'],
                              //                     tabindex: 0,
                              //                   )),
                              //         );
                              //       }
                              //     : null,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${item['receivername']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "Century Gothic",
                                  ),
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
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${item['qty']}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
