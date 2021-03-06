import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class AllDrivers extends StatefulWidget {
  @override
  _AllDriversState createState() => _AllDriversState();
}

class _AllDriversState extends State<AllDrivers> {
  bool _loading = false;
  List _drivers;
  double width;
  double height;
  String dropdownValue = 'Update';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _licenseController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _updateNameController = TextEditingController();
  TextEditingController _updateLicenseController = TextEditingController();
  TextEditingController _updateContactController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _getDrivers();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _contactController.dispose();
    super.dispose();
  }

// get the drivers list
  Future<http.Response> _getDrivers() async {
    setState(() {
      _loading = true;
    });

    final http.Response response =
        await Network().postData({'list_type': 'drivers'}, '/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      var res = jsonDecode(response.body);
      setState(() {
        _drivers = res['driverList'];
      });
    });

    print(_drivers);

    return response;
  }

  // adding a new driver
  Future<http.Response> _addDriver() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'name': _nameController.text,
      'licenseNumber': _licenseController.text,
      'contact': _contactController.text
    }, '/addNewDriver.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
    });

    return response;
  }

  // updating driver details
  Future<http.Response> _updateDriver(driverId) async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'id': driverId.toString(),
      'name': _updateNameController.text,
      'licenseNumber': _updateLicenseController.text,
      'contact': _updateContactController.text
    }, '/updateDrivers.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
    });

    return response;
  }

  // deleting a driver
  Future<http.Response> _deleteDriver(driverId) async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'id': driverId.toString(),
    }, '/deleteDriver.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
    });

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
        title: Text('Drivers'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewDriverDialog(context);
        },
        child: Icon(Icons.person_add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: height,
              child: RefreshIndicator(
                onRefresh: () async {
                  _getDrivers();
                },
                child: _drivers != null && _drivers.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _drivers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                              elevation: 10,
                              child: Container(
                                color: cardColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _drivers[index]['Name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 5),
                                    Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      columnWidths: {
                                        0: FractionColumnWidth(0.5),
                                        1: FractionColumnWidth(0.5),
                                      },
                                      children: [
                                        TableRow(children: [
                                          Text('License Number'),
                                          Text(
                                            ': ${_drivers[index]['Licen_No']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Contact Number'),
                                          Text(
                                            ': ${_drivers[index]['Contact']}',
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
                                                      _updateDriverDetailsDialog(
                                                          context,
                                                          _drivers[index]);
                                                    });
                                                  } else {
                                                    _deleteDriver(
                                                            _drivers[index]
                                                                ['ID'])
                                                        .then((value) {
                                                      var res = jsonDecode(
                                                          value.body);

                                                      if (res['error'] ==
                                                          true) {
                                                        Fluttertoast.showToast(
                                                            msg: res['message'],
                                                            backgroundColor:
                                                                Colors.red[600],
                                                            textColor:
                                                                Colors.white,
                                                            toastLength: Toast
                                                                .LENGTH_LONG);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                                msg: res[
                                                                    'message'],
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                toastLength: Toast
                                                                    .LENGTH_LONG)
                                                            .then((value) {
                                                          _getDrivers();
                                                        });
                                                      }
                                                    });
                                                  }
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

// adding new driver dialog
  Future<Widget> _addNewDriverDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
              ),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Add Driver',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                            hint: 'Full Name',
                            icon: MaterialCommunityIcons.account,
                            controller: _nameController,
                            validation: (val) {
                              if (val.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          MyTextField(
                            hint: 'License Number',
                            icon: MaterialCommunityIcons.card_text,
                            controller: _licenseController,
                            validation: (val) {
                              if (val.isEmpty) {
                                return 'License number is required';
                              }
                              return null;
                            },
                          ),
                          MyTextField(
                            maxLength: 10,
                            hint: 'Contact Number',
                            icon: MaterialCommunityIcons.contact_phone,
                            isNumber: true,
                            controller: _contactController,
                            validation: (val) {
                              if (val.isEmpty) {
                                return 'Contact number is required';
                              }
                              return null;
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                _addDriver().then((value) {
                                  var res = jsonDecode(value.body);

                                  if (res['error'] == true) {
                                    Fluttertoast.showToast(
                                        msg: res['message'],
                                        backgroundColor: Colors.red[600],
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG);
                                  } else {
                                    setState(() {
                                      _nameController.clear();
                                      _licenseController.clear();
                                      _contactController.clear();
                                    });
                                    Fluttertoast.showToast(
                                            msg: res['message'],
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_LONG)
                                        .then((value) {
                                      Navigator.pop(context);
                                      _getDrivers();
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 30.0,
                              width: double.infinity,
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // updating driver details dialog
  Future<Widget> _updateDriverDetailsDialog(context, driver) {
    print(driver);

    _updateNameController.text = driver['Name'];
    _updateLicenseController.text = driver['Licen_No'];
    _updateContactController.text = driver['Contact'];
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
              ),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Update Driver Details',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                            hint: 'Full Name',
                            icon: MaterialCommunityIcons.account,
                            controller: _updateNameController,
                            validation: (val) {
                              if (val.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          MyTextField(
                            hint: 'License Number',
                            icon: MaterialCommunityIcons.card_text,
                            controller: _updateLicenseController,
                            validation: (val) {
                              if (val.isEmpty) {
                                return 'License number is required';
                              }
                              return null;
                            },
                          ),
                          MyTextField(
                            maxLength: 10,
                            hint: 'Contact Number',
                            icon: MaterialCommunityIcons.contact_phone,
                            isNumber: true,
                            controller: _updateContactController,
                            validation: (val) {
                              if (val.isEmpty) {
                                return 'Contact number is required';
                              }
                              return null;
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                _updateDriver(driver['ID']).then((value) {
                                  var res = jsonDecode(value.body);

                                  if (res['error'] == true) {
                                    Fluttertoast.showToast(
                                        msg: res['message'],
                                        backgroundColor: Colors.red[600],
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG);
                                  } else {
                                    setState(() {
                                      _updateNameController.clear();
                                      _updateLicenseController.clear();
                                      _updateContactController.clear();
                                    });
                                    Fluttertoast.showToast(
                                            msg: res['message'],
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_LONG)
                                        .then((value) {
                                      Navigator.pop(context);
                                      _getDrivers();
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 30.0,
                              width: double.infinity,
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
