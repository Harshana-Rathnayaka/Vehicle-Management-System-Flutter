import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AddVehicle.dart';
import 'package:vehicle_management_system/screens/UpdateVehicle.dart';
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
  String dropdownValue = 'Update';

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

    final http.Response response =
        await Network().postData({'list_type': 'vehicles'}, '/getLists.php');

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
        title: Text('Vehicles'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddVehicle()));
        },
        child: Icon(Icons.add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: height,
              child: RefreshIndicator(
                onRefresh: () async {
                  _getVehicles();
                },
                child: _vehicleList != null && _vehicleList.length > 0
                    ? ListView.builder(
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
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          elevation: 8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey[800],
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 1, 8, 1),
                                            alignment: Alignment.center,
                                            child: Icon(
                                                _vehicleList[index]
                                                            ['Vehicle_Type'] ==
                                                        'Car'
                                                    ? MaterialCommunityIcons.car
                                                    : _vehicleList[index][
                                                                'Vehicle_Type'] ==
                                                            'Van'
                                                        ? MaterialCommunityIcons
                                                            .van_passenger
                                                        : MaterialCommunityIcons
                                                            .motorbike,
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
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            isExpanded: true,
                                            icon: Icon(
                                              Icons.more_horiz,
                                            ),
                                            underline: Container(
                                              height: 0,
                                              color: primaryColor,
                                            ),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dropdownValue = newValue;
                                              });
                                            },
                                            items: <String>['Update', 'Delete']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                                onTap: () {
                                                  print(value);

                                                  if (value == 'Update') {
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                UpdateVehicle(
                                                                    vehicle:
                                                                        _vehicleList[
                                                                            index]),
                                                          ));
                                                    });
                                                  }
                                                  // else {
                                                  //   _deleteDriver(
                                                  //           _drivers[index]
                                                  //               ['ID'])
                                                  //       .then((value) {
                                                  //     var res = jsonDecode(
                                                  //         value.body);

                                                  //     if (res['error'] ==
                                                  //         true) {
                                                  //       Fluttertoast.showToast(
                                                  //           msg: res['message'],
                                                  //           backgroundColor:
                                                  //               Colors.red[600],
                                                  //           textColor:
                                                  //               Colors.white,
                                                  //           toastLength: Toast
                                                  //               .LENGTH_LONG);
                                                  //     } else {
                                                  //       Fluttertoast.showToast(
                                                  //               msg: res[
                                                  //                   'message'],
                                                  //               backgroundColor:
                                                  //                   Colors
                                                  //                       .green,
                                                  //               textColor:
                                                  //                   Colors
                                                  //                       .white,
                                                  //               toastLength: Toast
                                                  //                   .LENGTH_LONG)
                                                  //           .then((value) {
                                                  //         _getVehicles();
                                                  //       });
                                                  //     }
                                                  //   });
                                                  // }
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Center(child: Text('No records found!')),
              ),
            ),
    );
  }
}
