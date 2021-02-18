import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AddRepair.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class AllRepairs extends StatefulWidget {
  @override
  _AllRepairsState createState() => _AllRepairsState();
}

class _AllRepairsState extends State<AllRepairs> {
  bool _loading = false;
  List _repairs;
  double width;
  double height;
  var _selectedDate;
  var _formattedDate;
  String dropdownValue = 'Update';

  TextEditingController _vehicleNumberController = TextEditingController();
  TextEditingController _updateRepairDetailsController =
      TextEditingController();
  MoneyMaskedTextController _updateCostControlller = MoneyMaskedTextController(
    initialValue: 0.00,
    decimalSeparator: '.',
    thousandSeparator: ',',
  );
  GlobalKey<FormState> _formKey = GlobalKey();

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

  // updating repair details
  Future<http.Response> _updateRepair(repairId) async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'id': repairId.toString(),
      'details': _updateRepairDetailsController.text,
      'date': _formattedDate,
      'cost': _updateCostControlller.numberValue.toStringAsFixed(2),
    }, '/updateRepairs.php');

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
        title: Text('Repairs'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                                  height: 170,
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
                                          maxLines: 3,
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
                                          ),
                                          Expanded(
                                            child: DropdownButton<String>(
                                              isDense: true,
                                              isExpanded: true,
                                              icon: Icon(
                                                Icons.more_horiz,
                                              ),
                                              underline: Container(
                                                height: 0,
                                                color: primaryColor,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  dropdownValue = newValue;
                                                });
                                              },
                                              items: <String>[
                                                'Update',
                                                'Delete'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                  onTap: () {
                                                    print(value);

                                                    if (value == 'Update') {
                                                      Future.delayed(
                                                          Duration.zero, () {
                                                        _updateRepairDetailsDialog(
                                                            context,
                                                            _repairs[index]);
                                                      });
                                                    }
                                                    // } else {
                                                    //   _deleteDriver(
                                                    //           _repairs[index]
                                                    //               ['ID'])
                                                    //       .then((value) {
                                                    //     var res = jsonDecode(
                                                    //         value.body);

                                                    //     if (res['error'] ==
                                                    //         true) {
                                                    //       Fluttertoast.showToast(
                                                    //           msg: res['message'],
                                                    //           backgroundColor:
                                                    //               Colors.red[600],
                                                    //           textColor:
                                                    //               Colors.white,
                                                    //           toastLength: Toast
                                                    //               .LENGTH_LONG);
                                                    //     } else {
                                                    //       Fluttertoast.showToast(
                                                    //               msg: res[
                                                    //                   'message'],
                                                    //               backgroundColor:
                                                    //                   Colors
                                                    //                       .green,
                                                    //               textColor:
                                                    //                   Colors
                                                    //                       .white,
                                                    //               toastLength: Toast
                                                    //                   .LENGTH_LONG)
                                                    //           .then((value) {
                                                    //         _getRepairs();
                                                    //       });
                                                    //     }
                                                    //   });
                                                    // }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
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
                    alignment: Alignment.topLeft,
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

  // updating repair details dialog
  Future<Widget> _updateRepairDetailsDialog(context, repair) {
    print(repair);

    _vehicleNumberController.text = repair['Vehicle_No'];
    _updateRepairDetailsController.text = repair['Repair'];
    _updateCostControlller.text = repair['Cost(Rs)'];
    DateTime date = DateFormat('dd/MM/yyyy').parse(repair['Date']);
    _selectedDate = date;
    print(_selectedDate);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
              ),
              width: double.infinity,
              child: SingleChildScrollView(
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
                      child: Text('Update Repair Details',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text('Vehicle Number - ${repair['Vehicle_No']}'),
                            MyTextField(
                              hint: 'Repair Details',
                              icon: MaterialIcons.build,
                              isMultiline: true,
                              maxLines: 6,
                              maxLength: 500,
                              controller: _updateRepairDetailsController,
                              validation: (val) {
                                if (val.isEmpty) {
                                  return 'Repair Details are required';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 10.0),
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
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            _selectedDate != null
                                                ? DateFormat('dd/MM/yyyy')
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
                                                      initialDate:
                                                          _selectedDate ??
                                                              DateTime.now(),
                                                      firstDate: DateTime(2021),
                                                      lastDate: DateTime(2022))
                                                  .then((onValue) {
                                                setState(() {
                                                  if (onValue != null) {
                                                    print(onValue);
                                                    _selectedDate = onValue;
                                                    print(
                                                        'when date onValue is not null: $_selectedDate');
                                                    _formattedDate = DateFormat(
                                                            'dd/MM/yyyy')
                                                        .format(_selectedDate);
                                                  } else {
                                                    _selectedDate =
                                                        DateTime.now().add(
                                                            Duration(days: 7));
                                                    print(
                                                        'when  date onValue is null: $_selectedDate');
                                                    _formattedDate = DateFormat(
                                                            'dd/MM/yyyy')
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
                            MyTextField(
                              hint: 'Repair Cost',
                              icon: Icons.monetization_on,
                              isNumber: true,
                              maxLength: 10,
                              controller: _updateCostControlller,
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
                                  _updateRepair(repair['ID']).then((value) {
                                    var res = jsonDecode(value.body);

                                    if (res['error'] == true) {
                                      Fluttertoast.showToast(
                                          msg: res['message'],
                                          backgroundColor: Colors.red[600],
                                          textColor: Colors.white,
                                          toastLength: Toast.LENGTH_LONG);
                                    } else {
                                      setState(() {
                                        _updateRepairDetailsController.clear();
                                        _updateCostControlller
                                            .updateValue(0.00);
                                      });
                                      Fluttertoast.showToast(
                                              msg: res['message'],
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              toastLength: Toast.LENGTH_LONG)
                                          .then((value) {
                                        Navigator.pop(context);
                                        _getRepairs();
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
