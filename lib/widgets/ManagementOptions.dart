import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vehicle_management_system/screens/AddDailyCost.dart';
import 'package:vehicle_management_system/screens/AddRepair.dart';
import 'package:vehicle_management_system/screens/AddVehicle.dart';
import 'package:vehicle_management_system/screens/AllDrivers.dart';

class ManagementOptions extends StatefulWidget {
  const ManagementOptions({
    Key key,
  }) : super(key: key);

  @override
  _ManagementOptionsState createState() => _ManagementOptionsState();
}

class _ManagementOptionsState extends State<ManagementOptions> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(MaterialCommunityIcons.car_multiple),
          title: Text("New Vehicle"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddVehicle()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.people),
          title: Text("New Driver"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AllDrivers()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(MaterialIcons.build),
          title: Text("New Repair"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddRepair()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text("New Fuel Cost"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddDailyCost()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }
}
