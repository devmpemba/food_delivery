
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  CategoryCard(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 80,
      child: Column(
        children: [
          Container(
            width: 60, // Set the size for the avatar with the border
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.red, // Set your desired border color
                width: 2, // Set the border width
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/kfc.png'),
            ),
          ),
          SizedBox(height: 5),
          Text(name, style: TextStyle(fontFamily: "Mulish")),
        ],
      ),
    );
  }
}