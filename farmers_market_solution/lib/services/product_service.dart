import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class ProductService {
  static const String _fileName = 'assets/data/products.json';

  Future<List<Product>> getProducts() async {
    try {
      final String jsonString = await rootBundle.loadString(_fileName);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> productsJson = jsonData['products'];
      
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }

  Future<bool> saveProducts(List<Product> products) async {
    try {
      final Map<String, dynamic> jsonData = {
        'products': products.map((product) => product.toJson()).toList(),
      };
      
      final String jsonString = json.encode(jsonData);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/products.json');
      await file.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      print('Error saving products: $e');
      return false;
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      final products = await getProducts();
      products.add(product);
      return await saveProducts(products);
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final products = await getProducts();
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        return await saveProducts(products);
      }
      return false;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }
}
