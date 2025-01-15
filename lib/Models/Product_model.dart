class Addon {
  final String featuredImage;

  Addon({required this.featuredImage});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      featuredImage: json['featured_image'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final double salePrice;
  final String featuredImage;
  final List<Addon> addons;
  bool inWishlist;

  Product({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.featuredImage,
    required this.addons,
    this.inWishlist = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      salePrice: json['sale_price'].toDouble(),
      featuredImage: json['featured_image'],
      addons: json['addons'] != null
          ? (json['addons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList()
          : [],
      inWishlist: json['in_wishlist'] ?? false,
    );
  }
}
