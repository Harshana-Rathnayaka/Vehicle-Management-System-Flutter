import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyButton.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class AddDailyCost extends StatefulWidget {
  @override
  _AddDailyCostState createState() => _AddDailyCostState();
}

class _AddDailyCostState extends State<AddDailyCost> {
  bool _loading = false;
  double width;
  double height;
  DateTime _selectedDate;
  var _formattedDate;
  List _vehicles;
  var _selectedVehicle;
  var addBy = 'Lakshitha';
  Map _fuelPrices;

  // format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  MoneyMaskedTextController _fuelCostController = MoneyMaskedTextController(
    initialValue: 0.00,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  TextEditingController _fuelTypeController = TextEditingController();
  TextEditingController _fuelPriceController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _getVehicleNumbers();
    _getPrices();
    super.initState();
  }

  @override
  void dispose() {
    _fuelTypeController.dispose();
    _fuelPriceController.dispose();
    _fuelCostController.dispose();
    super.dispose();
  }

  // adding a new daily fuel cost
  Future<http.Response> _addFuelCost() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'addedBy': addBy,
      'vehicleNumber': _selectedVehicle,
      'date': _formattedDate,
      'gasType': _fuelTypeController.text,
      'fuelPrice': _fuelPriceController.text,
      'fuelCost': _fuelCostController.numberValue.toStringAsFixed(2),
    }, '/addNewDailyFuelCost.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
    });

    return response;
  }

  // get the vehicle number list list
  Future<http.Response> _getVehicleNumbers() async {
    setState(() {
      _loading = true;
    });

    final http.Response response =
        await Network().postData({'list_type': 'vehicles'}, '/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      var res = jsonDecode(response.body);
      setState(() {
        _vehicles = res['vehicleList'];
      });
    });

    print(_vehicles);

    return response;
  }

  // get the price list
  Future<http.Response> _getPrices() async {
    setState(() {
      _loading = true;
    });

    final http.Response response =
        await Network().postData({'list_type': 'gas'}, '/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      _fuelPrices = jsonDecode(response.body);
    });

    print(_fuelPrices);

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
        title: Text('Add Daily Fuel Cost'),
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
                                MaterialCommunityIcons.account_multiple,
                                color: primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.teal[100],
                              labelText: 'Added By',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintStyle: TextStyle(color: Colors.blueGrey[700]),
                              hintText: "Added By",
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
                          value: addBy,
                          style: TextStyle(color: Colors.black),
                          items: ['Lakshitha', 'Romesh', 'Prabath'].map(
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
                                addBy = val;
                              },
                            );
                            print(addBy);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                      ),
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
                          style: TextStyle(color: Colors.black),
                          value: _selectedVehicle,
                          items: _vehicles.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                onTap: () {
                                  setState(() {
                                    _fuelTypeController.text = val['Fuel_Type'];
                                    print(_fuelTypeController.text.toString());
                                    if (_fuelTypeController.text == 'Petrol') {
                                      _fuelPriceController.text =
                                          currencyFormat.format(double.parse(
                                              _fuelPrices['petrolPrice']));
                                    } else {
                                      _fuelPriceController.text =
                                          currencyFormat.format(double.parse(
                                              _fuelPrices['dieselPrice']));
                                    }
                                  });
                                },
                                value: val['Vehicle_No'],
                                child: Text(val['Vehicle_No']),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                _selectedVehicle = val;
                              },
                            );
                            print(_selectedVehicle);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Select a Vehicle';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: Container(
                          height: 70.0,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.teal[100],
                                    border: Border.all(
                                        color: primaryColor, width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _selectedDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(_selectedDate)
                                          : "Date not selected",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.blueGrey[700]),
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
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(_selectedDate);
                                            } else {
                                              _selectedDate = DateTime.now()
                                                  .add(Duration(days: 7));
                                              print(
                                                  'when  date onValue is null: $_selectedDate');
                                              _formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(_selectedDate);
                                            }
                                          });
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: 'This field is disabled',
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_SHORT);
                        },
                        child: MyTextField(
                          hint: 'Fuel Type',
                          icon: Icons.local_gas_station,
                          isNumber: true,
                          isEnabled: false,
                          controller: _fuelTypeController,
                          validation: (val) {
                            if (val.isEmpty) {
                              return 'Fuel Type is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: 'This field is disabled',
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_SHORT);
                        },
                        child: MyTextField(
                          hint: 'Fuel Price',
                          icon: FlutterIcons.cash_mco,
                          isNumber: true,
                          isEnabled: false,
                          controller: _fuelPriceController,
                          validation: (val) {
                            if (val.isEmpty) {
                              return 'Fuel Price is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyTextField(
                        hint: 'Cost',
                        icon: Icons.monetization_on,
                        isNumber: true,
                        maxLength: 9,
                        controller: _fuelCostController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Fuel Cost is required';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _addFuelCost().then((value) {
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
                                  _fuelTypeController.clear();
                                  _fuelPriceController.clear();
                                  _fuelCostController.updateValue(0.00);
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
