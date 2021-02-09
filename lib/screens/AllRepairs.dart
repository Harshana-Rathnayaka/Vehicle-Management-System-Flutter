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
      floatingActionButton: FloatingActionButton(
        child: Icon(MaterialCommunityIcons.plus),
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
                child: _repairs != null && _repairs.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _repairs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                _viewDetails(context, _repairs[index]);
                              },
                              child: Material(
                                elevation: 10,
                                child: Container(
                                  height: 160,
                                  color: cardColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Vehicle No : ',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            _repairs[index]['Vehicle_No'],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        child: Text(
                                          _repairs[index]['Repair'],
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                        ),
                                      ),
                                      Spacer(),
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
                            ),
                          );
                        })
                    : Center(child: Text('No records found!')),
              ),
            ),
    );
  }

// view repair details dialog
  Future<Widget> _viewDetails(context, repair) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              height: 300,
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
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Repair Details',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 160,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(repair['Repair'], textAlign: TextAlign.justify),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.0,
                      width: double.infinity,
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
