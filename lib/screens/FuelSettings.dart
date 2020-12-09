import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class FuelSettings extends StatefulWidget {
  @override
  _FuelSettingsState createState() => _FuelSettingsState();
}

class _FuelSettingsState extends State<FuelSettings> {
  bool _loading = false;
  Map _prices;
  double width;
  double height;

  TextEditingController _priceController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _getPrices();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.text;
    super.dispose();
  }

// format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

// get the price list
  Future<http.Response> _getPrices() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().getData('/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      _prices = jsonDecode(response.body);
    });

    print(_prices);

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
        title: Text('Update Fuel Rates'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: width,
                  child: Card(
                    color: cardColor,
                    elevation: 15,
                    child: ListTile(
                      leading: Icon(Icons.credit_card, color: primaryColor),
                      title: Text('Petrol', style: TextStyle(fontSize: 18)),
                      subtitle: Text(
                          "Rs. ${currencyFormat.format(double.parse(_prices['petrolPrice']))}"),
                      trailing: GestureDetector(
                          onTap: () {
                            _updatePriceDialog(
                                context, 'Petrol', _prices['petrolPrice']);
                          },
                          child: Icon(Icons.edit, color: primaryColor)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: width,
                  child: Card(
                    color: cardColor,
                    elevation: 15,
                    child: ListTile(
                      leading: Icon(Icons.credit_card, color: primaryColor),
                      title: Text('Diesel', style: TextStyle(fontSize: 18)),
                      subtitle: Text(
                          "Rs. ${currencyFormat.format(double.parse(_prices['dieselPrice']))}"),
                      trailing: GestureDetector(
                          onTap: () {
                            _updatePriceDialog(
                                context, 'Diesel', _prices['dieselPrice']);
                          },
                          child: Icon(Icons.edit, color: primaryColor)),
                    ),
                  ),
                )
              ],
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
                      width: width,
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
                              _getPrices();
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
