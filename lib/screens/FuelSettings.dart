import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';

class FuelSettings extends StatefulWidget {
  @override
  _FuelSettingsState createState() => _FuelSettingsState();
}

class _FuelSettingsState extends State<FuelSettings> {
  bool _loading = false;
  Map _prices;
  double width;
  double height;

  @override
  void initState() {
    _getPrices();
    super.initState();
  }

  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

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
                      elevation: 15,
                      child: ListTile(
                        leading: Icon(Icons.credit_card, color: primaryColor),
                        title: Text('Petrol', style: TextStyle(fontSize: 18)),
                        subtitle: Text(
                            "Rs. ${currencyFormat.format(double.parse(_prices['petrolPrice']))}"),
                        trailing: Icon(Icons.edit, color: primaryColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: width,
                    child: Card(
                      elevation: 15,
                      child: ListTile(
                        leading: Icon(Icons.credit_card, color: primaryColor),
                        title: Text('Diesel', style: TextStyle(fontSize: 18)),
                        subtitle: Text(
                            "Rs. ${currencyFormat.format(double.parse(_prices['dieselPrice']))}"),
                        trailing: Icon(Icons.edit, color: primaryColor),
                      ),
                    ),
                  )
                ],
              ));
  }
}
