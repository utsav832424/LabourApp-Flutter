import 'dart:developer';

import 'package:abc_2_1/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAdmin extends StatefulWidget {
  AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final txtController = TextEditingController();
  final loginForm = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController editname = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController sitename = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController editpassword = TextEditingController();
  // TextEditingController  = TextEditingController();

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

  bool loader = true;
  List data = [];
  late ScrollController _scrollController;

  var token = "";
  var userid = 0;
  var userType = 0;
  late List businessname = [];
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
    setState(() {
      loader = true;
    });
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.getcall("users");
    log("${resData}");
    if (mounted) {
      setState(() {
        data = resData['data'];
        loader = false;
      });
    }
  }

  void _loadMore() async {
    var param = new Map<String, dynamic>();
    param['user_id'] = userid.toString();
    var resData = await apiService.postCall("staff", param);
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
        txtController2.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // width: 300,
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
                                  "Admin",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                            if (userType == 2)
                              Text(
                                "Action",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      for (var item in data)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item['sitename']}",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  if (userType == 2)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            editname.text = item['sitename'];

                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Edit Admin Detail'),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        TextFormField(
                                                          // readOnly: true,
                                                          controller: editname,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Admin";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a Admin',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          // readOnly: true,
                                                          controller:
                                                              editpassword,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Password";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a Password',
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
                                                              if (editname.text
                                                                  .isEmpty) {
                                                                ToastMsg(
                                                                  "Please enter Name",
                                                                  15,
                                                                  Colors.red,
                                                                );
                                                              } else {
                                                                var param = Map<
                                                                    String,
                                                                    dynamic>();
                                                                param['sitename'] =
                                                                    editname
                                                                        .text;
                                                                param['password'] =
                                                                    editpassword
                                                                        .text;
                                                                param['id'] =
                                                                    item['id'];
                                                                var resData =
                                                                    await apiService
                                                                        .postCall(
                                                                            'users/update',
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
                                                                  init();
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors
                                                                        .green,
                                                                  );
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
                                        SizedBox(
                                          width: 10,
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
                                                  actionsPadding:
                                                      EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  contentPadding:
                                                      EdgeInsets.zero,
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
                                                    child:
                                                        SingleChildScrollView(
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
                                                                  onPressed:
                                                                      () {
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
                                                                      'users/delete/${item['id']}',
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

                                                                      init();
                                                                    } else {
                                                                      ToastMsg(
                                                                        resData[
                                                                            'message'],
                                                                        15,
                                                                        Colors
                                                                            .red,
                                                                      );
                                                                      init();
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
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.delete,
                                              size: 17,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 80,
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
                                              "Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Century Gothic",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 5),
                                            child: TextFormField(
                                              controller: sitename,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 20, left: 10),
                                            child: Text(
                                              "Password",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Century Gothic",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 5),
                                            child: TextFormField(
                                              controller: password,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter Password";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a Password',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 160,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                  onPrimary: Colors.white,
                                                ),
                                                onPressed: isLoad
                                                    ? null
                                                    : () async {
                                                        if (loginForm
                                                            .currentState!
                                                            .validate()) {
                                                          setState(
                                                            () {
                                                              isLoad = true;
                                                            },
                                                          );
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['sitename'] =
                                                              sitename.text;
                                                          data['password'] =
                                                              password.text;

                                                          print(data);
                                                          var login =
                                                              await apiService
                                                                  .postCall(
                                                                      'users',
                                                                      data);
                                                          setState(
                                                            () {
                                                              isLoad = false;
                                                            },
                                                          );
                                                          if (login[
                                                                  'success'] ==
                                                              0) {
                                                            setState(() {
                                                              ErrorMessage =
                                                                  login[
                                                                      'message'];
                                                            });
                                                          } else {
                                                            ToastMsg(
                                                              login['message'],
                                                              15,
                                                              Colors.green,
                                                            );
                                                            init();
                                                            sitename.text = '';
                                                            password.text = '';

                                                            Navigator.pop(
                                                                context);
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
                                            Container(
                                              width: 160,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  onPrimary: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
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
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // width: 300,
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
                                  "Admin",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Century Gothic",
                              ),
                            ),
                            if (userType == 2)
                              Text(
                                "Action",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      for (var item in data)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item['sitename']}",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  if (userType == 2)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            editname.text = item['sitename'];

                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Edit Admin Detail'),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        TextFormField(
                                                          // readOnly: true,
                                                          controller: editname,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Admin";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a Admin',
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextFormField(
                                                          // readOnly: true,
                                                          controller:
                                                              editpassword,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Please enter Password";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            hintText:
                                                                'Enter a Password',
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
                                                              if (editname.text
                                                                  .isEmpty) {
                                                                ToastMsg(
                                                                  "Please enter Name",
                                                                  15,
                                                                  Colors.red,
                                                                );
                                                              } else {
                                                                var param = Map<
                                                                    String,
                                                                    dynamic>();
                                                                param['sitename'] =
                                                                    editname
                                                                        .text;
                                                                param['password'] =
                                                                    editpassword
                                                                        .text;
                                                                param['id'] =
                                                                    item['id'];
                                                                var resData =
                                                                    await apiService
                                                                        .postCall(
                                                                            'users/update',
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
                                                                  init();
                                                                  ToastMsg(
                                                                    resData[
                                                                        'message'],
                                                                    15,
                                                                    Colors
                                                                        .green,
                                                                  );
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
                                        SizedBox(
                                          width: 10,
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
                                                  actionsPadding:
                                                      EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  contentPadding:
                                                      EdgeInsets.zero,
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
                                                    child:
                                                        SingleChildScrollView(
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
                                                                  onPressed:
                                                                      () {
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
                                                                      'users/delete/${item['id']}',
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

                                                                      init();
                                                                    } else {
                                                                      ToastMsg(
                                                                        resData[
                                                                            'message'],
                                                                        15,
                                                                        Colors
                                                                            .red,
                                                                      );
                                                                      init();
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
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.delete,
                                              size: 17,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 80,
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
                                              "Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Century Gothic",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 5),
                                            child: TextFormField(
                                              controller: sitename,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 20, left: 10),
                                            child: Text(
                                              "Password",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Century Gothic",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 5),
                                            child: TextFormField(
                                              controller: password,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter Password";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter a Password',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 160,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                  onPrimary: Colors.white,
                                                ),
                                                onPressed: isLoad
                                                    ? null
                                                    : () async {
                                                        if (loginForm
                                                            .currentState!
                                                            .validate()) {
                                                          setState(
                                                            () {
                                                              isLoad = true;
                                                            },
                                                          );
                                                          var data = Map<String,
                                                              dynamic>();
                                                          data['sitename'] =
                                                              sitename.text;
                                                          data['password'] =
                                                              password.text;

                                                          print(data);
                                                          var login =
                                                              await apiService
                                                                  .postCall(
                                                                      'users',
                                                                      data);
                                                          setState(
                                                            () {
                                                              isLoad = false;
                                                            },
                                                          );
                                                          if (login[
                                                                  'success'] ==
                                                              0) {
                                                            setState(() {
                                                              ErrorMessage =
                                                                  login[
                                                                      'message'];
                                                            });
                                                          } else {
                                                            ToastMsg(
                                                              login['message'],
                                                              15,
                                                              Colors.green,
                                                            );
                                                            init();
                                                            sitename.text = '';
                                                            password.text = '';

                                                            Navigator.pop(
                                                                context);
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
                                            Container(
                                              width: 160,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  onPrimary: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
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
            ],
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
