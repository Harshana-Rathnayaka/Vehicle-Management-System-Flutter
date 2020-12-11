import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyButton.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

enum Ownership { Own, Rent }
enum Maintenance { Active, Inactive }

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  bool _loading = false;
  double width;
  double height;
  var vehicleType = 'Car';
  var gasType = 'Petrol';
  Ownership _ownership = Ownership.Own;
  Maintenance _maintenance = Maintenance.Active;

  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _capacityController = TextEditingController();
  TextEditingController _chasisNumberController = TextEditingController();
  TextEditingController _engineNumberController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _capacityController.dispose();
    _chasisNumberController.dispose();
    _engineNumberController.dispose();
    super.dispose();
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: DropdownButtonFormField(
                          iconEnabledColor: primaryColor,
                          dropdownColor: Colors.teal[100],
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.local_taxi,
                                color: primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.teal[100],
                              labelText: 'Vehicle Type',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintStyle: TextStyle(color: Colors.blueGrey[700]),
                              hintText: "Vehicle Type",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 1.1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              errorStyle: TextStyle()),
                          isDense: true,
                          iconSize: 30.0,
                          value: vehicleType,
                          style: TextStyle(color: Colors.black),
                          items: ['Car', 'Van', 'Bike'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                vehicleType = val;
                              },
                            );
                            print(vehicleType);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Vehicle type is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyTextField(
                        hint: 'Capacity',
                        icon: Icons.opacity,
                        controller: _capacityController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Capacity is required';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: DropdownButtonFormField(
                          iconEnabledColor: primaryColor,
                          dropdownColor: Colors.teal[100],
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.local_gas_station,
                                color: primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.teal[100],
                              labelText: 'Fuel Type',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintStyle: TextStyle(color: Colors.blueGrey[700]),
                              hintText: "Fuel Type",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              errorStyle: TextStyle()),
                          isDense: true,
                          iconSize: 30.0,
                          value: gasType,
                          style: TextStyle(color: Colors.black),
                          items: ['Petrol', 'Diesel'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                gasType = val;
                              },
                            );
                            print(gasType);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Fuel type is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyTextField(
                        hint: 'Chasis Number',
                        icon: Icons.build,
                        isNumber: true,
                        controller: _chasisNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Chasis Number is required';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Engine Number',
                        icon: Icons.business,
                        isNumber: true,
                        controller: _engineNumberController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Engine Number is required';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Ownership'),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    visualDensity: VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    title: Text('Own'),
                                    leading: Radio(
                                      value: Ownership.Own,
                                      groupValue: _ownership,
                                      onChanged: (Ownership value) {
                                        setState(() {
                                          _ownership = value;
                                        });
                                        print(describeEnum(_ownership));
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    visualDensity: VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    title: Text('Rent'),
                                    leading: Radio(
                                      value: Ownership.Rent,
                                      groupValue: _ownership,
                                      onChanged: (Ownership value) {
                                        setState(() {
                                          _ownership = value;
                                        });
                                        print(describeEnum(_ownership));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Maintenance'),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    visualDensity: VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    title: Text('Active'),
                                    leading: Radio(
                                      value: Maintenance.Active,
                                      groupValue: _maintenance,
                                      onChanged: (Maintenance value) {
                                        setState(() {
                                          _maintenance = value;
                                        });
                                        print(describeEnum(_maintenance));
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    visualDensity: VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    title: Text('Inactive'),
                                    leading: Radio(
                                      value: Maintenance.Inactive,
                                      groupValue: _maintenance,
                                      onChanged: (Maintenance value) {
                                        setState(() {
                                          _maintenance = value;
                                        });
                                        print(describeEnum(_maintenance));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            print('dfd');
                            print(_maintenance);
                          }
                        },
                        child: MyButton(
                          text: 'SAVE',
                          btnColor: primaryColor,
                          btnRadius: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
