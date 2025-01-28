class Restaurants {
  final int id;
  final String name;
  final String streetAddress;
  final String businessLogo;
  final String city;

  Restaurants(
      {required this.id,
      required this.name,
      required this.streetAddress,
      required this.businessLogo,
      required this.city,
    
});


  // Factory method to create a Category from JSON
  factory Restaurants.fromJson(Map<String, dynamic> json) {

    const String baseUrl = "https://msosi.dawadirect.co.tz/";

    return Restaurants(
      id: json['id'],
      name: json['name'],
      streetAddress: json['street_address'],
      businessLogo: "$baseUrl${json['business_logo']}", // Combine base URL with the image path
      city: json['city'],
    );
  }
}
