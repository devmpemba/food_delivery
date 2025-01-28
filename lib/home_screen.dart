import 'package:flutter/material.dart';
import 'package:food_delivery/model/category.dart';
import 'package:food_delivery/model/restaurant.dart';
import 'package:food_delivery/restaurant_screen.dart';
import 'package:food_delivery/widgets/category_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentAddress = "Loading...";
  List<Category> categories = [];
  List<Restaurants> restaurants = [];
  bool isLoading = true;

  Future<void> fetchRestaurants() async {
    try {
      final response = await http
          .get(Uri.parse('https://msosi.dawadirect.co.tz/api/restaurants'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        setState(() {
          restaurants = data.map((item) => Restaurants.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch categories from the API
  Future<void> fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('https://msosi.dawadirect.co.tz/api/foods/category'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        setState(() {
          categories = data.map((item) => Category.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchCategories();
    fetchRestaurants();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Location services are disabled";
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = "Location permission denied";
        });
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get the address from the coordinates
    await _getAddressFromLatLng(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      //GET LOCATION NAME from latitude and longitude
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.name}, ${place.locality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Failed to get address: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.white),
            SizedBox(width: 8),
            Text(_currentAddress,
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories
                          .map((category) => CategoryCard(category.name))
                          .toList(),
                    ),
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
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return createShopCard(
                        imageUrl: restaurant.businessLogo,
                        name: restaurant.name,
                        address: restaurant.streetAddress,
                        deliveryFee: restaurant.city,
                      );
                    },
                  ),
                ),
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
            // Positioned(
            //   top: 10,
            //   left: 10,
            //   child: Container(
            //     color: Colors.yellowAccent,
            //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            //     child: Text('Logo', style: TextStyle(fontSize: 20)),
            //   ),
            // ),
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
