import 'dart:convert';

import 'package:http/http.dart' as http;

class CategoryService {
  static List<Category> categories = [];

  static Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://workwave-backend.vercel.app/api/v1/category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      categories = data.map((categoryData) => Category.fromJson(categoryData)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static List<String> getCategoryNames() {
    return categories.map((category) => category.name).toList();
  }
  static List<String> getCategoryId() {
    return categories.map((category) => category.id).toList();
  }

  static List<double> getCategoryPrices() {
    return categories.map((category) => double.parse(category.price)).toList();
  }
  static List<double> getCategoryImages() {
    return categories.map((category) => double.parse(category.image)).toList();
  }
}

class Category {
  final String id;
  final String name;
  final String price;
  final String status;
   final String image;

  Category({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
    required this.image
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      status: json['status'],
      image: json['image'],
    );
  }
}
