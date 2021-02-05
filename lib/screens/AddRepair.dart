import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyButton.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class AddRepair extends StatefulWidget {
  @override
  _AddRepairState createState() => _AddRepairState();
}

class _AddRepairState extends State<AddRepair> {
  bool _loading = false;
  double width;
  double height;
  var vehicleType = 'Car';
  var gasType = 'Petrol';
  DateTime _selectedDate;
  var _formattedDate;

  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _repairDetailsController = TextEditingController();
  TextEditingController _repairCostController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _repairDetailsController.dispose();
    _repairCostController.dispose();
    super.dispose();
  }

  // adding a new repair
  Future<http.Response> _addRepair() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'vehicleNumber': _vehicleNumberController.text,
      'vehicleType': vehicleType,
      'gasType': gasType,
      'repairDetails': _repairDetailsController.text,
      'repairCost': _repairCostController.text,
    }, '/addNewVehicle.php');

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
        title: Text('Add New Vehicle'),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: DropdownButtonFormField(
                          iconEnabledColor: primaryColor,
                          dropdownColor: Colors.teal[100],
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                MaterialCommunityIcons.numeric,
                                color: primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.teal[100],
                              labelText: 'Vehicle Number',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintStyle: TextStyle(color: Colors.blueGrey[700]),
                              hintText: "Vehicle Number",
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
                              return 'Vehicle Number is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyTextField(
                        hint: 'Repair Details',
                        icon: MaterialIcons.build,
                        isMultiline: true,
                        maxLines: 6,
                        controller: _repairDetailsController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Repair Details are required';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        // padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),

                        height: 70.0,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.teal[100],
                                    border: Border.all(color: primaryColor, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _selectedDate != null
                                          ? DateFormat('dd/MM/yyyy')
                                              .format(_selectedDate)
                                          : "Date not selected",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.blueGrey[700]),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.date_range,
                                        color: primaryColor,
                                      ),
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: _selectedDate ??
                                                    DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2022))
                                            .then((onValue) {
                                          setState(() {
                                            if (onValue != null) {
                                              print(onValue);
                                              _selectedDate = onValue;
                                              print(
                                                  'when date onValue is not null: $_selectedDate');
                                              _formattedDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(_selectedDate);
                                            } else {
                                              _selectedDate = DateTime.now()
                                                  .add(Duration(days: 7));
                                              print(
                                                  'when  date onValue is null: $_selectedDate');
                                              _formattedDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(_selectedDate);
                                            }
                                          });
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 2.0,
                            //   left: 10.0,
                            //   child: Container(
                            //     color: Colors.white,
                            //     padding: EdgeInsets.all(5),
                            //     child: Text(
                            //       "Date",
                            //       style: TextStyle(color: Colors.grey.shade600),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      MyTextField(
                        hint: 'Repair Cost',
                        icon: MaterialCommunityIcons.car_shift_pattern,
                        isNumber: true,
                        controller: _repairCostController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Repair Cost is required';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _addRepair().then((value) {
                              var res = jsonDecode(value.body);

                              if (res['error'] == true) {
                                Fluttertoast.showToast(
                                    msg: res['message'],
                                    backgroundColor: Colors.red[600],
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_LONG);
                              } else {
                                Fluttertoast.showToast(
                                    msg: res['message'],
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_LONG);

                                setState(() {
                                  _vehicleNumberController.clear();
                                  _repairDetailsController.clear();
                                  _repairCostController.clear();
                                });
                              }
                            });
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
