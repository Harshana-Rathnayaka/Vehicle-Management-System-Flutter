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

class AddMonthlyCost extends StatefulWidget {
  @override
  _AddMonthlyCostState createState() => _AddMonthlyCostState();
}

class _AddMonthlyCostState extends State<AddMonthlyCost> {
  bool _loading = false;
  double width;
  double height;
  var _formattedDate = DateFormat.MMMM().format(DateTime.now());
  List _vehicles;
  var _selectedVehicle;
  var _selectedMonth;
  Map _fuelPrices;
  List _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  MoneyMaskedTextController _totalCostController = MoneyMaskedTextController(
    initialValue: 0,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  TextEditingController _fuelTypeController = TextEditingController();
  TextEditingController _fuelPriceController = TextEditingController();
  TextEditingController _startReadingController = TextEditingController();
  TextEditingController _endReadingController = TextEditingController();
  TextEditingController _totalKmsController = TextEditingController();
  TextEditingController _totalLitersController = TextEditingController();
  TextEditingController _averageController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    setState(() {
      _selectedMonth = _formattedDate;
    });
    _getVehicleNumbers();
    _getPrices();
    super.initState();
  }

  @override
  void dispose() {
    _fuelTypeController.dispose();
    _fuelPriceController.dispose();
    _startReadingController.dispose();
    _endReadingController.dispose();
    _totalKmsController.dispose();
    _totalCostController.dispose();
    _totalLitersController.dispose();
    _averageController.dispose();
    super.dispose();
  }

  // adding a new monthly fuel cost
  Future<http.Response> _addFuelCost() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'vehicleNumber': _selectedVehicle,
      'selectedMonth': _selectedMonth,
      'startReadingValue': _startReadingController.text.toString(),
      'endReadingValue': _endReadingController.text.toString(),
      'totalDistance': currencyFormat
          .format(double.parse(_totalKmsController.text.toString())),
      'totalCost': _totalCostController.numberValue.toStringAsFixed(2),
      'totalLiters': _totalLitersController.text.toString(),
      'average': _averageController.text.toString()
    }, '/addNewMonthlyFuelCost.php');

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
        title: Text('Add Monthly Fuel Cost'),
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
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
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
                          ),
                          Expanded(
                            child: GestureDetector(
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: DropdownButtonFormField(
                          iconEnabledColor: primaryColor,
                          dropdownColor: Colors.teal[100],
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                FlutterIcons.calendar_month_mco,
                                color: primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.teal[100],
                              labelText: 'Month',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintStyle: TextStyle(color: Colors.blueGrey[700]),
                              hintText: "Month",
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
                          value: _selectedMonth,
                          style: TextStyle(color: Colors.black),
                          items: _months.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedMonth = val;
                            });
                            print(_selectedMonth);
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Month is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyTextField(
                        hint: 'Meter reading at the start',
                        icon: FlutterIcons.speedometer_slow_mco,
                        isNumber: true,
                        controller: _startReadingController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Meter reading at the start of the Month is required';
                          } else if (double.parse(val.toString()) >
                              double.parse(
                                  _endReadingController.text.toString())) {
                            return 'Starting value should be less than the end value';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        hint: 'Meter reading at the end',
                        icon: FlutterIcons.speedometer_mco,
                        isNumber: true,
                        controller: _endReadingController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Meter reading at the end of the Month is required';
                          } else if (double.parse(val.toString()) <
                              double.parse(
                                  _startReadingController.text.toString())) {
                            return 'End value should be greater than the starting value';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          print(double.parse(_endReadingController.text));
                          if (_startReadingController.text != null) {
                            setState(() {
                              var km = (double.parse(
                                      _endReadingController.text) -
                                  double.parse(_startReadingController.text));
                              _totalKmsController.text = km.toStringAsFixed(0);
                              print(_totalCostController.text);
                            });
                          }
                        },
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
                          hint: 'Total Km',
                          icon: FlutterIcons.ios_speedometer_ion,
                          isNumber: true,
                          isEnabled: false,
                          controller: _totalKmsController,
                          validation: (val) {
                            if (val.isEmpty) {
                              return 'Total Distance is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      MyTextField(
                        hint: 'Total Cost',
                        icon: Icons.monetization_on,
                        isNumber: true,
                        controller: _totalCostController,
                        validation: (val) {
                          if (val.isEmpty) {
                            return 'Total Cost is required';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          var liters = _totalCostController.numberValue /
                              double.parse(
                                  _fuelPriceController.text.toString());
                          var average = double.parse(
                                  _totalKmsController.text.toString()) /
                              liters;
                          print('liters - $liters');
                          print('average - $average');
                          setState(() {
                            _totalLitersController.text =
                                liters.toStringAsFixed(2);
                            _averageController.text =
                                average.toStringAsFixed(2);
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: 'This field is disabled',
                                    backgroundColor: Colors.blueGrey,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT);
                              },
                              child: MyTextField(
                                hint: 'Liters',
                                icon: FlutterIcons.fuel_mco,
                                isNumber: true,
                                isEnabled: false,
                                controller: _totalLitersController,
                                validation: (val) {
                                  if (val.isEmpty) {
                                    return 'Total amount of Liters is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg: 'This field is disabled',
                                    backgroundColor: Colors.blueGrey,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT);
                              },
                              child: MyTextField(
                                hint: 'Average',
                                icon: FlutterIcons.water_percent_mco,
                                isNumber: true,
                                isEnabled: false,
                                controller: _averageController,
                                validation: (val) {
                                  if (val.isEmpty) {
                                    return 'Average is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
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
                                        toastLength: Toast.LENGTH_LONG)
                                    .then((value) {
                                  setState(() {
                                    _fuelTypeController.clear();
                                    _fuelPriceController.clear();
                                    _startReadingController.clear();
                                    _endReadingController.clear();
                                    _totalKmsController.clear();
                                    _totalCostController.updateValue(0.00);
                                    _totalLitersController.clear();
                                    _averageController.clear();
                                  });
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
