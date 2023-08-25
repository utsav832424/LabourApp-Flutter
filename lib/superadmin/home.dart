import 'package:abc_2_1/admin/asset_transfer.dart';
// import 'package:abc_2_1/detail.dart';
// import 'package:abc_2_1/general_site_report.dart/vehical_report.dart';
import 'package:abc_2_1/login.dart';
import 'package:abc_2_1/superadmin/diesel_report.dart';
import 'package:abc_2_1/superadmin/labour_report.dart';
import 'package:abc_2_1/superadmin/machinery_report.dart';
import 'package:abc_2_1/superadmin/material_recieved.dart';
import 'package:abc_2_1/superadmin/operator.dart';
import 'package:abc_2_1/superadmin/staff.dart';
import 'package:abc_2_1/superadmin/vehical.dart';
import 'package:flutter/material.dart';

class SHome extends StatefulWidget {
  SHome({Key? key}) : super(key: key);

  @override
  State<SHome> createState() => _SHomeState();
}

class _SHomeState extends State<SHome> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return Scaffold(
          body: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, User!",
                          style: TextStyle(
                            fontFamily: "Century Gothic",
                            // fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) => false,
                            );
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "1",
                              padding: EdgeInsets.zero,
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                          fontFamily: "Century Gothic",
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Site Name, Site Address",
                        style: TextStyle(
                          fontFamily: "Century Gothic",
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
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
                              "Daily Site Report",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SLabour_Report()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/labour_report.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  "Labour Report",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SStaff()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/staff.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Staff",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SMaterial_recieved()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/material_recieved.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  "Material Recieved",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SMachinery_report()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/machinery_report.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  "Machinery Report",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SOperator()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/operator.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Operator",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sdiesel_Report()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                // margin: EdgeInsets.only(left: 22),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/vehical_report.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                // margin: EdgeInsets.only(left: 30),
                                child: Text(
                                  "Diesel Report",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
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
                              "General Site Report",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Asset_Transfer()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.pink[50],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/asset_transfer.png",
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  child: Text(
                                    "Asset Transfer",
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.purple[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SVehical()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.orange[100],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/vehical.png",
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  child: Text(
                                    "Vehical Report",
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          body: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, User!",
                          style: TextStyle(
                            fontFamily: "Century Gothic",
                            // fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) => false,
                            );
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "1",
                              padding: EdgeInsets.zero,
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                          fontFamily: "Century Gothic",
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Site Name, Site Address",
                        style: TextStyle(
                          fontFamily: "Century Gothic",
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
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
                              "Daily Site Report",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SLabour_Report()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/labour_report.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  "Labour Report",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SStaff()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/staff.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Staff",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SMaterial_recieved()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/material_recieved.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  "Material Recieved",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SMachinery_report()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/machinery_report.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  "Machinery Report",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SOperator()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/operator.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Operator",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sdiesel_Report()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                // margin: EdgeInsets.only(left: 22),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/vehical_report.png",
                                  height: 50,
                                ),
                              ),
                              Container(
                                width: 80,
                                // margin: EdgeInsets.only(left: 30),
                                child: Text(
                                  "Diesel Report",
                                  style: TextStyle(
                                    fontFamily: "Century Gothic",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
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
                              "General Site Report",
                              style: TextStyle(
                                fontFamily: "Century Gothic",
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Asset_Transfer()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.pink[50],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/asset_transfer.png",
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  child: Text(
                                    "Asset Transfer",
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.purple[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SVehical()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.orange[100],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/vehical.png",
                                  height: 70,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  child: Text(
                                    "Vehical Report",
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
