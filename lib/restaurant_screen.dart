import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raj Palace Restaurant", style: TextStyle(fontFamily: "Mulish", fontSize: 20, color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/banner1.png'),
            ListTile(
              title: Text("Raj Palace Restaurant", style: TextStyle(fontFamily: "Mulish", fontWeight: FontWeight.bold),),
              subtitle: Text("Chinese, North Indian", style: TextStyle(fontFamily: "Mulish"),),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("4.5", style: TextStyle(fontFamily: "Mulish", fontWeight: FontWeight.bold),),
                  Icon(Icons.star, color: Colors.yellow),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Delivery in 10 mins", style: TextStyle(fontFamily: "Mulish")),
              subtitle: Text("TZS 3,500 delivery fee",  style: TextStyle(fontFamily: "Mulish")),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Popular Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Mulish"),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return FoodCard("Fried Rice", "TZS 15,000", "60% OFF");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;
  final String price;
  final String offer;

  FoodCard(this.name, this.price, this.offer);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/kfc.png', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(price),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(offer, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
