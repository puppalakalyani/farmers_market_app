import 'package:flutter/material.dart';
import '../../models/product.dart';

class ConsumerDashboard extends StatelessWidget {
  const ConsumerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from backend
    final List<Product> availableProducts = [
      Product(
        id: '1',
        farmerId: 'farmer1',
        name: 'Fresh Tomatoes',
        description: 'Organically grown tomatoes',
        price: 40.00,
        unit: 'kg',
        quantity: 100,
        imageUrl: '',
        listedDate: DateTime.now(),
      ),
      Product(
        id: '2',
        farmerId: 'farmer2',
        name: 'Potatoes',
        description: 'Fresh farm potatoes',
        price: 30.00,
        unit: 'kg',
        quantity: 150,
        imageUrl: '',
        listedDate: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Products'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableProducts.length,
              itemBuilder: (context, index) {
                final product = availableProducts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Price: ₹${product.price} per ${product.unit}'),
                        Text('Available Quantity: ${product.quantity} ${product.unit}'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement contact farmer functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Connecting with farmer...'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.message),
                              label: const Text('Contact Farmer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
