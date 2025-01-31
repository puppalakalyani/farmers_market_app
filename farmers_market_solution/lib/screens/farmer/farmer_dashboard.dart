import 'package:flutter/material.dart';
import '../../models/product.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({Key? key}) : super(key: key);

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final List<Product> _products = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedUnit = 'kg';

  void _addProduct() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter product name' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter price' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    items: ['kg', 'g', 'piece', 'dozen']
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedUnit = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity Available',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter quantity' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _submitProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _products.add(
          Product(
            id: DateTime.now().toString(),
            farmerId: 'current_farmer_id',
            name: _nameController.text,
            description: '',
            price: double.parse(_priceController.text),
            unit: _selectedUnit,
            quantity: int.parse(_quantityController.text),
            imageUrl: '',
            listedDate: DateTime.now(),
          ),
        );
      });
      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text(
                'No products listed yet.\nTap + to add your first product.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      'Price: ₹${product.price} per ${product.unit}\n'
                      'Quantity: ${product.quantity} ${product.unit}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
