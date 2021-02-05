import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vehicle_management_system/screens/AddRepair.dart';
import 'package:vehicle_management_system/screens/AddVehicle.dart';
import 'package:vehicle_management_system/screens/Drivers.dart';

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
          title: Text("Add vehicle"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddVehicle()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.people),
          title: Text("Drivers"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Drivers()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(MaterialIcons.build),
          title: Text("New repair"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddRepair()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.category),
          title: Text("Category list"),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add_circle_outline),
          title: Text("Add brand"),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text("brand list"),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }
}
