import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../services/order_service.dart';
import '../../services/product_service.dart';
import '../login_screen.dart';

class FarmerDashboard extends StatefulWidget {
  final User user;
  
  const FarmerDashboard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final List<Product> _products = [];
  final List<Order> _orders = [];
  final _productService = ProductService();
  final _orderService = OrderService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final products = await _productService.getProducts();
    final orders = await _orderService.getOrders();

    setState(() {
      _products.clear();
      _products.addAll(products);
      _orders.clear();
      _orders.addAll(orders);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${widget.user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Available Products'),
                      Tab(text: 'My Orders'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildProductsList(),
                        _buildOrdersList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProductsList() {
    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'No products available.\nWait for consumers to add products.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(product.name),
            subtitle: Text(
              'Price: \$${product.price.toStringAsFixed(2)}\n'
              '${product.description}',
            ),
            trailing: ElevatedButton(
              onPressed: () => _placeOrder(product),
              child: const Text('Place Order'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersList() {
    if (_orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders yet.\nPlace your first order from the Products tab.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Order #${order.id}'),
            subtitle: Text(
              'Products: ${order.products.join(", ")}\n'
              'Total: \$${order.totalAmount.toStringAsFixed(2)}',
            ),
            trailing: Text(
              order.status,
              style: TextStyle(
                color: order.status == 'Completed' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _placeOrder(Product product) async {
    final order = Order(
      id: DateTime.now().toString(),
      customerName: widget.user.name,
      products: [product.name],
      totalAmount: product.price,
      status: 'Pending',
    );

    final success = await _orderService.addOrder(order);

    if (success) {
      _loadData(); // Reload data to show new order
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
