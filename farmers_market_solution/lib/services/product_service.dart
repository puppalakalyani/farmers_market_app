import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  static const String _fileName = 'assets/data/products.json';
  final _productsController = StreamController<List<Product>>.broadcast();

  Stream<List<Product>> get productsStream => _productsController.stream;
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/products.json';
  }

  Future<void> initializeProducts() async {
    try {
      final localFile = File(await _localPath);
      if (!await localFile.exists()) {
        // Copy initial data from assets
        final String jsonString = await rootBundle.loadString(_fileName);
        await localFile.writeAsString(jsonString);
      }
      final products = await getProducts();
      _productsController.add(products);
    } catch (e) {
      print('Error initializing products: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final file = File(await _localPath);
      final String jsonString = await file.readAsString();
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
      final file = File(await _localPath);
      await file.writeAsString(jsonString);
      
      // Notify listeners about the update
      _productsController.add(products);
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

  void dispose() {
    _productsController.close();
  }
}
