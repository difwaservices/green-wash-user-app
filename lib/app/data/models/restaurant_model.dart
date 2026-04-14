/// Data model for a water plant listing on the home screen.
class RestaurantModel {
  final String id;
  final String name;
  final String cuisineType; // Now used for Water Type
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double distanceKm;
  final String offerText;
  final int offerAbove;
  final int offerAmount;
  final String heroImage;
  final String topDishLabel; // Keeping name for compatibility, but using for Products
  final bool isFeatured;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.distanceKm,
    required this.offerText,
    required this.offerAbove,
    required this.offerAmount,
    required this.heroImage,
    required this.topDishLabel,
    this.isFeatured = false,
  });
}

/// Static list of dummy restaurants.
const List<RestaurantModel> kRestaurants = [
  RestaurantModel(
    id: 'r1',
    name: 'Aqua Pure Plant',
    cuisineType: 'Purified · Mineral',
    rating: 4.8,
    reviewCount: 1200,
    deliveryTime: '20–30 mins',
    distanceKm: 0.8,
    offerText: 'Flat ₹20 OFF above ₹199',
    offerAbove: 199,
    offerAmount: 20,
    heroImage: 'assets/waterimage/water1.jpg',
    topDishLabel: '20L RO Water · ₹80',
    isFeatured: true,
  ),
  RestaurantModel(
    id: 'r2',
    name: 'Crystal Clear Water',
    cuisineType: 'Alkaline · RO+UV',
    rating: 4.6,
    reviewCount: 950,
    deliveryTime: '25–40 mins',
    distanceKm: 1.5,
    offerText: 'Buy 5 Get 1 FREE',
    offerAbove: 400,
    offerAmount: 80,
    heroImage: 'assets/images/water.jpg',
    topDishLabel: '1L Mineral Bottle · ₹20',
    isFeatured: true,
  ),
  RestaurantModel(
    id: 'r3',
    name: 'Blue Springs Hub',
    cuisineType: 'Natural · Spring',
    rating: 4.9,
    reviewCount: 2100,
    deliveryTime: '15–25 mins',
    distanceKm: 0.5,
    offerText: 'New User: 50% OFF',
    offerAbove: 100,
    offerAmount: 50,
    heroImage: 'assets/waterimage/water1.jpg',
    topDishLabel: 'Premium Spring Water · ₹120',
  ),
  RestaurantModel(
    id: 'r4',
    name: 'Safe Sip Station',
    cuisineType: 'Filtered · Pure',
    rating: 4.2,
    reviewCount: 450,
    deliveryTime: '30–45 mins',
    distanceKm: 2.2,
    offerText: 'Flat ₹30 OFF above ₹299',
    offerAbove: 299,
    offerAmount: 30,
    heroImage: 'assets/images/bottal.jpg',
    topDishLabel: 'Standard 20L Jar · ₹60',
  ),
  RestaurantModel(
    id: 'r5',
    name: 'Eco Water Supply',
    cuisineType: 'Eco-Friendly · Safe',
    rating: 4.5,
    reviewCount: 320,
    deliveryTime: '35–50 mins',
    distanceKm: 3.1,
    offerText: 'Free Stand on 1st Order',
    offerAbove: 999,
    offerAmount: 300,
    heroImage: 'assets/waterimage/water1.jpg',
    topDishLabel: 'Family Combo Pack · ₹499',
  ),
];

/// Menu items shown when a restaurant is tapped.
class RestaurantMenuItem {
  final String name;
  final String weight;
  final double price;
  final String image;
  bool isFavorite;

  RestaurantMenuItem({
    required this.name,
    required this.weight,
    required this.price,
    required this.image,
    this.isFavorite = false,
  });
}

List<RestaurantMenuItem> getMenuForRestaurant(String restaurantId) {
  // All plants serve different water varieties.
  return [
    RestaurantMenuItem(
      name: '20L RO+UV Jar',
      weight: '20 Liters',
      price: 80,
      image: 'assets/images/water.jpg',
    ),
    RestaurantMenuItem(
      name: '1L Mineral Bottle',
      weight: '1 Liter',
      price: 20,
      image: 'assets/bottal/b05.png',
    ),
    RestaurantMenuItem(
      name: '500ml Spring Water',
      weight: '500ml',
      price: 15,
      image: 'assets/images/bottal.jpg',
    ),
    RestaurantMenuItem(
      name: 'Automatic Water Pump',
      weight: '1 Unit',
      price: 299,
      image: 'assets/images/water.jpg',
    ),
    RestaurantMenuItem(
      name: 'Manual Hand Pump',
      weight: '1 Unit',
      price: 150,
      image: 'assets/images/bottal.jpg',
    ),
    RestaurantMenuItem(
      name: 'Natural Alkalin Water',
      weight: '10 Liters',
      price: 150,
      image: 'assets/images/water.jpg',
    ),
    RestaurantMenuItem(
      name: 'Premium Glass Bottle',
      weight: '750ml',
      price: 199,
      image: 'assets/bottal/b05.png',
    ),
    RestaurantMenuItem(
      name: 'Dispenser Stand',
      weight: '1 Unit',
      price: 499,
      image: 'assets/images/water.jpg',
    ),
  ];
}
