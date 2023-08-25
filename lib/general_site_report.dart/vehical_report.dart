import 'package:abc_2_1/admin/contractordetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Vehical_Report extends StatefulWidget {
  Vehical_Report({Key? key, required this.data, required this.type})
      : super(key: key);
  final data;
  final type;

  @override
  State<Vehical_Report> createState() => _Vehical_ReportState();
}

class _Vehical_ReportState extends State<Vehical_Report> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
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
                            "Vehical Report",
                            style: TextStyle(
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
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextFormField(
                            // decoration:
                            //     InputDecoration(labelText: 'Selected Date'),
                            onTap: _selDatePicker,
                            controller: txtController,
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: _selDatePicker,
                        //   child: Text(
                        //     "23/12/2022",
                        //     style: TextStyle(
                        //         color: Colors.blue[900],
                        //         // fontWeight: FontWeight.bold,
                        //         fontSize: 16),
                        //   ),
                        // ),
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
                        Image.asset(
                          "assets/pdf.png",
                          height: 40,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          "assets/exel.png",
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder(
                      horizontalInside: BorderSide(
                    color: Colors.grey,
                  )),
                  columnWidths: {
                    0: FlexColumnWidth(10),
                    1: FlexColumnWidth(5),
                    2: FlexColumnWidth(5),
                    3: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                              "Machinery Name",
                              style: TextStyle(
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
                              "Insurance Detail",
                              style: TextStyle(
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
                              "Registration Date",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            child: Text(
                              "R.c Book",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            child: Text(
                              "PUC",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            child: Text(
                              "Fitness",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            child: Text(
                              "Form 10",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            child: Text(
                              "CNG Kit",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var data in widget.data)
                      TableRow(
                        children: [
                          GestureDetector(
                            onTap: widget.type == 1
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ContractorDetail(
                                                contractor_id:
                                                    data['contractorname_id'],
                                                tabindex: 0,
                                              )),
                                    );
                                  }
                                : null,
                            child: TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${data['contractorname']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${data['labourfullday']}",
                                style: TextStyle(color: Colors.black),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Sahil",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "1512151",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
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

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 20),
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          right: 30,
                                          left: 30),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Name",
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
                                      height: 40,
                                      width: 220,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          border: OutlineInputBorder(),
                                          // hintText: 'Enter a Name',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 20),
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          right: 34,
                                          left: 34),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Type",
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
                                      height: 40,
                                      width: 220,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          border: OutlineInputBorder(),
                                          // hintText: 'Enter a Name',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 20),
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          right: 25,
                                          left: 25),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Full Hrs",
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 20),
                                      height: 40,
                                      width: 220,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          border: OutlineInputBorder(),
                                          // hintText: 'Enter a Name',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 160,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            onPrimary: Colors.white,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            "Save",
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
                                          onPressed: () {},
                                          child: Text(
                                            "Clear",
                                          ),
                                        ),
                                      ),
                                    ],
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
        ],
      ),
    );
  }
}
