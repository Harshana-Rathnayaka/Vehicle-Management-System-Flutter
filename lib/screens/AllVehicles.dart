import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AddVehicle.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';

class AllVehicles extends StatefulWidget {
  @override
  _AllVehiclesState createState() => _AllVehiclesState();
}

class _AllVehiclesState extends State<AllVehicles> {
  bool _loading = false;
  List _vehicleList;
  double width;
  double height;

  @override
  void initState() {
    _getVehicles();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// get the vehicle list
  Future<http.Response> _getVehicles() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().getData('/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      var data = jsonDecode(response.body);

      _vehicleList = data['vehicleList'];
    });

    print(_vehicleList);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('All Vehicles'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddVehicle()));
        },
        child: Icon(Icons.add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                _getVehicles();
              },
                          child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _vehicleList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Material(
                        elevation: 10.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          color: cardColor,
                          width: width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        text: 'Vehicle No - ',
                                        children: [
                                          TextSpan(
                                              text: _vehicleList[index]
                                                  ['Vehicle_No'],
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.w800))
                                        ]),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey[800],
                                        borderRadius:
                                            BorderRadius.circular(4)),
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _vehicleList[index]['Vehicle_Type'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: {
                                  0: FractionColumnWidth(0.5),
                                  1: FractionColumnWidth(0.5),
                                },
                                children: [
                                  TableRow(children: [
                                    Text('Capacity'),
                                    Text(
                                      ': ${_vehicleList[index]['Capacity']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Text('Fuel Type'),
                                    Text(
                                      ': ${_vehicleList[index]['Fuel_Type']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Text(
                                      'Chassis Number',
                                    ),
                                    Text(
                                      ': ${_vehicleList[index]['Chassis_Number']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Text(
                                      'Engine Number',
                                    ),
                                    Text(
                                      ': ${_vehicleList[index]['Engine_Number']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Text(
                                      'Ownership',
                                    ),
                                    Text(
                                      ': ${_vehicleList[index]['Ownership']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Text(
                                      'Maintenance',
                                    ),
                                    Text(
                                      ': ${_vehicleList[index]['Maintenance']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ]),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
    );
  }

// price updating dialog
  // Future<Widget> _updatePriceDialog(context, String gas, String price) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           backgroundColor: Colors.transparent,
  //           child: Container(
  //             height: 220,
  //             decoration: BoxDecoration(
  //               color: backgroundColor,
  //               shape: BoxShape.rectangle,
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             width: double.infinity,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color: primaryColor,
  //                     shape: BoxShape.rectangle,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(16.0),
  //                         topRight: Radius.circular(16.0)),
  //                   ),
  //                   height: 50,
  //                   width: double.infinity,
  //                   alignment: Alignment.center,
  //                   child: Text('Update the $gas price',
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w400,
  //                           fontSize: 16,
  //                           color: Colors.white),
  //                       textAlign: TextAlign.center),
  //                 ),
  //                 SizedBox(
  //                   height: 15.0,
  //                 ),
  //                 Form(
  //                   key: _formKey,
  //                   child: MyTextField(
  //                     controller: _priceController,
  //                     hint: 'Enter the new price',
  //                     isNumber: true,
  //                     validation: (val) {
  //                       if (val.isEmpty) {
  //                         return 'The price is required to proceed.';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 GestureDetector(
  //                   onTap: () {
  //                     if (_formKey.currentState.validate()) {
  //                       _updatePrices(gas).then((value) {
  //                         var res = jsonDecode(value.body);

  //                         if (res['error'] == true) {
  //                           Fluttertoast.showToast(
  //                                   msg: res['message'],
  //                                   backgroundColor: Colors.red[600],
  //                                   textColor: Colors.white,
  //                                   toastLength: Toast.LENGTH_LONG)
  //                               .then((value) {
  //                             Navigator.pop(context);
  //                           });
  //                         } else {
  //                           setState(() {
  //                             _priceController.text = '';
  //                           });
  //                           Fluttertoast.showToast(
  //                                   msg: res['message'],
  //                                   backgroundColor: Colors.green,
  //                                   textColor: Colors.white,
  //                                   toastLength: Toast.LENGTH_LONG)
  //                               .then((value) {
  //                             Navigator.pop(context);
  //                             _getVehicles();
  //                           });
  //                         }
  //                       });
  //                     }
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     height: 30.0,
  //                     width: double.infinity,
  //                     child: Text(
  //                       'SAVE',
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.w500),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}
