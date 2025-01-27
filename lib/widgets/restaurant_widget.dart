
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String offer;
  RestaurantCard(this.name, this.offer);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/mudi.jpg'),
        ),
        title: Text(
          name,
          style: TextStyle(fontFamily: "Mulish", fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          offer,
          style: TextStyle(fontFamily: "Mulish"),
        ),
      ),
    );
  }
}
