import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class Drivers extends StatefulWidget {
  @override
  _DriversState createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  bool _loading = false;
  List _drivers;
  double width;
  double height;

  TextEditingController _priceController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _getDrivers();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

// get the price list
  Future<http.Response> _getDrivers() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().getData('/getLists.php');

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

  // update the fuel price
  Future<http.Response> _updatePrices(gasType) async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData(
        {'gasType': gasType, 'price': _priceController.text},
        '/updateFuelPrices.php');

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
        title: Text('All Drivers'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.person_add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListView.builder(
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
                                    fontSize: 16, fontWeight: FontWeight.w700),
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
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

// price updating dialog
  Future<Widget> _updatePriceDialog(context, String gas, String price) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              height: 220,
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
                          topRight: Radius.circular(16.0)),
                    ),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Update the $gas price',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Form(
                    key: _formKey,
                    child: MyTextField(
                      controller: _priceController,
                      hint: 'Enter the new price',
                      isNumber: true,
                      validation: (val) {
                        if (val.isEmpty) {
                          return 'The price is required to proceed.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        _updatePrices(gas).then((value) {
                          var res = jsonDecode(value.body);

                          if (res['error'] == true) {
                            Fluttertoast.showToast(
                                    msg: res['message'],
                                    backgroundColor: Colors.red[600],
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_LONG)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          } else {
                            setState(() {
                              _priceController.text = '';
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
                            fontSize: 16, fontWeight: FontWeight.w500),
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
