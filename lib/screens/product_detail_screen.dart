import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'cart_screen.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';


class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail'; 
  

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final productId = ModalRoute.of(context)?.settings.arguments;
    if (productId == null || productId is! String) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Not Found'),
        ),
        body: Center(
          child: Text('No product selected.'),
        ),
      );
    }
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        actions: [
          Consumer<Cart>(
        builder: (_, cart, ch) => Padding(
          padding: const EdgeInsets.only(right: 10), 
          child: Badge(
            child: ch,
            label: Text(cart.itemCount.toString()),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Product Title & Price
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                loadedProduct.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${loadedProduct.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 22, color: Colors.green),
              ),
            ),
            // Buy Now & Add to Cart Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Buy Now', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                       Provider.of<Orders>(
                        context,
                        listen: false,
                      ).addOrder(cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Add to Cart', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        final cart = Provider.of<Cart>(context, listen: false);
                        cart.addItem(loadedProduct.id, loadedProduct.price, loadedProduct.title);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            // Product Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                loadedProduct.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            // Ratings & Reviews Section (placeholder)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text('4.5', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text('(1200 reviews)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Example review
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text('Great product!'),
                  subtitle: Text('Really loved the quality and fast delivery.'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}