import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/order.dart';

class OrderService {
  static const String _fileName = 'assets/data/orders.json';

  Future<List<Order>> getOrders() async {
    try {
      final String jsonString = await rootBundle.loadString(_fileName);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> ordersJson = jsonData['orders'];
      
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }

  Future<bool> saveOrders(List<Order> orders) async {
    try {
      final Map<String, dynamic> jsonData = {
        'orders': orders.map((order) => order.toJson()).toList(),
      };
      
      final String jsonString = json.encode(jsonData);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/orders.json');
      await file.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      print('Error saving orders: $e');
      return false;
    }
  }

  Future<bool> addOrder(Order order) async {
    try {
      final orders = await getOrders();
      orders.add(order);
      return await saveOrders(orders);
    } catch (e) {
      print('Error adding order: $e');
      return false;
    }
  }

  Future<List<Order>> getOrdersByCustomer(String customerName) async {
    try {
      final orders = await getOrders();
      return orders.where((order) => order.customerName == customerName).toList();
    } catch (e) {
      print('Error getting orders by customer: $e');
      return [];
    }
  }
}
