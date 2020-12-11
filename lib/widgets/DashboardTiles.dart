import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vehicle_management_system/constants/colors.dart';
import 'package:vehicle_management_system/screens/AllVehicles.dart';
import 'package:vehicle_management_system/screens/FuelSettings.dart';

class DashboardTiles extends StatefulWidget {
  final String username;
  const DashboardTiles({Key key, this.username}) : super(key: key);

  @override
  _DashboardTilesState createState() => _DashboardTilesState();
}

class _DashboardTilesState extends State<DashboardTiles> {
  double width;
  double height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        Material(
          elevation: 50,
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.all(8),
            width: width,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome ${widget.username},',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[800]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have a nice day!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[800]),
                    ),
                    Icon(Icons.tag_faces, color: Colors.green[800])
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 25),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                Card(
                  margin: const EdgeInsets.all(10),
                  color: cardColor,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.people, size: 50, color: primaryColor),
                        Text(
                          'Drivers',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FuelSettings()));
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    color: cardColor,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.local_gas_station,
                              size: 50, color: primaryColor),
                          Text(
                            'Fuel Rates',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  color: cardColor,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(MaterialCommunityIcons.wrench, size: 50, color: primaryColor),
                        Text(
                          'Repairs',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  color: cardColor,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.monetization_on,
                            size: 50, color: primaryColor),
                        Text(
                          'Fuel Cost',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AllVehicles()));
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    color: cardColor,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(MaterialCommunityIcons.train_car,
                              size: 50, color: primaryColor),
                          Text(
                            'Vehicles',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Card(
                //   margin: const EdgeInsets.all(10),
                //   color: cardColor,
                //   elevation: 5.0,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Icon(Icons.local_gas_station,
                //             size: 50, color: primaryColor),
                //         Text(
                //           'Fuel Prices',
                //           style: TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.w500),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
