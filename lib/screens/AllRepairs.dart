import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AddRepair.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';

class AllRepairs extends StatefulWidget {
  @override
  _AllRepairsState createState() => _AllRepairsState();
}

class _AllRepairsState extends State<AllRepairs> {
  bool _loading = false;
  List _repairs;
  double width;
  double height;

  @override
  void initState() {
    _getRepairs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // format to display the prices
  final currencyFormat = new NumberFormat("#,##0.00", "en_US");

// get the repairs list
  Future<http.Response> _getRepairs() async {
    setState(() {
      _loading = true;
    });

    final http.Response response =
        await Network().postData({'list_type': 'repairs'}, '/getLists.php');

    print('response ---- ${jsonDecode(response.body)}');

    setState(() {
      _loading = false;
      var res = jsonDecode(response.body);
      setState(() {
        _repairs = res['repairsList'];
      });
    });

    print(_repairs);

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
        title: Text('Repairs'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('New Repair'),
        icon: Icon(MaterialCommunityIcons.plus),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddRepair()));
        },
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: height,
              child: RefreshIndicator(
                onRefresh: () async {
                  _getRepairs();
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _repairs.length,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Vehicle No : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      _repairs[index]['Vehicle_No'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: Text(
                                    _repairs[index]['Repair'],
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text('Date : '),
                                    Text(
                                      _repairs[index]['Date'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Cost : '),
                                    Text(
                                      'Rs. ${currencyFormat.format(double.parse(_repairs[index]['Cost(Rs)']))}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
