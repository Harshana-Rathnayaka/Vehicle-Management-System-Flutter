import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/services/NetworkHelper.dart';

class DailyFuelCost extends StatefulWidget {
  @override
  _DailyFuelCostState createState() => _DailyFuelCostState();
}

class _DailyFuelCostState extends State<DailyFuelCost> {
  bool _loading = false;
  List _fuelCosts;
  double width;
  double height;

  // format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    _getDailyFuelCost();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// get the fuel cost list
  Future<http.Response> _getDailyFuelCost() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network()
        .postData({'list_type': 'daily_fuel_cost'}, '/getLists.php');

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
        title: Text('Daily Fuel Costs'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(FlutterIcons.bank_plus_mco),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: height,
              child: RefreshIndicator(
                onRefresh: () async {
                  _getDailyFuelCost();
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
                                          'Added By ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          _fuelCosts[index]['Add_By'],
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
                                          Text('Vehicle Number'),
                                          Text(
                                            ': ${_fuelCosts[index]['Vehicle_No']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Date'),
                                          Text(
                                            ': ${_fuelCosts[index]['Date']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Fuel Type'),
                                          Text(
                                            ': ${_fuelCosts[index]['Fuel_Type']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Fuel Price'),
                                          Text(
                                            ': Rs. ${currencyFormat.format(double.parse(_fuelCosts[index]['Fuel_Price']))}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Cost'),
                                          Text(
                                            ': Rs. ${currencyFormat.format(double.parse(_fuelCosts[index]['Cost']))}',
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
