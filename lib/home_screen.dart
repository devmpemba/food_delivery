import 'package:flutter/material.dart';
import 'package:food_delivery/restaurant_screen.dart';
import 'package:food_delivery/widgets/category_card.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.white),
            SizedBox(width: 8),
            Text("Dar es salaam, Makumbusho",
                style: TextStyle(
                    fontSize: 17, color: Colors.white, fontFamily: "Mulish")),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            child: PageView(
              children: [
                Image.asset('assets/images/banner1.png'),
                Image.asset('assets/images/banner1.png'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Popular Categories",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Mulish"),
            ),
          ),
          Container(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryCard("Burger"),
                CategoryCard("Drinks"),
                CategoryCard("Snacks"),
                CategoryCard("Beer"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Nearby Restaurants",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Mulish"),
            ),
          ),

          SizedBox(
            height: 10,
          ),



          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                createShopCard(
                  imageUrl:
                      'https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/092014/ticker_restaurant.png',
                  name: 'TIGO SHOP',
                  address: 'Jukwani Street, Dar es Salaam, Tanzania',
                  deliveryFee: 'TZS 3,000 • 60min • 1 Km',
                ),
                createShopCard(
                  imageUrl:
                      'https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/092014/ticker_restaurant.png',
                  name: 'Chinese Lanzhou Restaurant',
                  address: 'Shoppers Plaza, Mikocheni, Dar es Salaam, Tanzania',
                  deliveryFee: 'TZS 3,000 • 0min • 1 Km',
                ),
                createShopCard(
                  imageUrl:
                      'https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/092014/ticker_restaurant.png',
                  name: "Pizza Hut Shopper's Plaza",
                  address:
                      'Pizza Hut, Mwai Kibaki Road, Dar es Salaam, Tanzania',
                  deliveryFee: 'TZS 3,000 • 45min • 2 Km',
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: "Nearby"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}



Widget createShopCard({
  required String imageUrl,
  required String name,
  required String address,
  required String deliveryFee,
}) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      children: [
        Stack(
          children: [
            Image.network(imageUrl,
                width: double.infinity, height: 150, fit: BoxFit.cover),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                color: Colors.yellowAccent,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text('Logo', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontFamily: "Mulish",
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(address,
                  style: TextStyle(fontFamily: "Mulish", color: Colors.grey)),
              SizedBox(height: 4),
              Text(deliveryFee,
                  style: TextStyle(fontFamily: "Mulish", color: Colors.grey)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.favorite_border),
          onPressed: () {
            Get.to(RestaurantScreen());
            // Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantScreen()));
          },
        ),
      ],
    ),
  );
}
