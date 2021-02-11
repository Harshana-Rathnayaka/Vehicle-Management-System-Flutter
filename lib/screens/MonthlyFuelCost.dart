import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AddMonthlyCost.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';

class MonthlyFuelCost extends StatefulWidget {
  @override
  _MonthlyFuelCostState createState() => _MonthlyFuelCostState();
}

class _MonthlyFuelCostState extends State<MonthlyFuelCost> {
  bool _loading = false;
  List _fuelCosts;
  double width;
  double height;

  // format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    _getMonthlyFuelCost();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// get the fuel cost list
  Future<http.Response> _getMonthlyFuelCost() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network()
        .postData({'list_type': 'monthly_fuel_cost'}, '/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      var res = jsonDecode(response.body);
      setState(() {
        _fuelCosts = res['fuelCostsList'];
      });
    });

    print(_fuelCosts);

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
        title: Text('Monthly Fuel Costs'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddMonthlyCost()));
        },
        child: Icon(FlutterIcons.bank_plus_mco),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: height,
              child: RefreshIndicator(
                onRefresh: () async {
                  _getMonthlyFuelCost();
                },
                child: _fuelCosts != null && _fuelCosts.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _fuelCosts.length,
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
                                    Row(
                                      children: [
                                        Text(
                                          'Vehicle No - ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          _fuelCosts[index]['Vehicle_No'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
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
                                          Text('Month'),
                                          Text(
                                            ': ${_fuelCosts[index]['Date']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Start of the Month'),
                                          Text(
                                            ': ${currencyFormat.format(double.parse(_fuelCosts[index]['Start_of_Month']))} Km',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('End of the Month'),
                                          Text(
                                            ': ${currencyFormat.format(double.parse(_fuelCosts[index]['End_of_Month']))} Km',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Total Km'),
                                          Text(
                                            ': ${_fuelCosts[index]['Total Km']} Km',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Amount'),
                                          Text(
                                            ': Rs. ${currencyFormat.format(double.parse(_fuelCosts[index]['Amount']))}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Liters'),
                                          Text(
                                            ': ${currencyFormat.format(double.parse(_fuelCosts[index]['Liters']))} L',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Average'),
                                          Text(
                                            ': ${currencyFormat.format(double.parse(_fuelCosts[index]['Average']))} Km',
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
                        })
                    : Center(child: Text('No records found!')),
              ),
            ),
    );
  }
}
