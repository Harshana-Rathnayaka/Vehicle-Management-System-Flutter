import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyButton.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  bool _loading = false;
  double width;
  double height;

  TextEditingController _vehicleNumberController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _vehicleNumberController.text;
    super.dispose();
  }

// format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  // update the fuel price
  Future<http.Response> _updatePrices(gasType) async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData(
        {'gasType': gasType, 'price': _vehicleNumberController.text},
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
        title: Text('Add new vehicle'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyTextField(
                        hint: 'Vehicle Number',
                        icon: Icons.directions_car,
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Vehicle number is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Vehicle Type',
                        icon: Icons.commute,
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Vehicle type is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Capacity',
                        icon: Icons.opacity,
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Capacity is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Fuel Type',
                        icon: Icons.local_gas_station,
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Fuel type is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Chasis Number',
                        icon: Icons.car_repair,
                        isNumber: true,
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Chasis Number is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Engine Number',
                        icon: Icons.engineering,
                        isNumber: true,
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Engine Number is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Ownership',
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Vehicle type is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Maintenance',
                        controller: _vehicleNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Vehicle type is required';
                          }
                          return null;
                        },
                      ),
                      MyButton(
                        text: 'SAVE',
                        btnColor: primaryColor,
                        btnRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
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
                      controller: _vehicleNumberController,
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
                              _vehicleNumberController.text = '';
                            });
                            Fluttertoast.showToast(
                                    msg: res['message'],
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_LONG)
                                .then((value) {
                              Navigator.pop(context);
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
