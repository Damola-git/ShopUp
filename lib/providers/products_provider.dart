import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
   
final String authToken;

 
  Products(this.authToken, this.userId, this._items);
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Airfryer',
    //   description: 'Healthier way to fry your food.',
    //   price: 99.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/71ZJSl4lN2L.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Laptop',
    //   description: 'A high performance laptop for all your needs.',
    //   price: 999.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_UY218_.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Lead dial wristwatch',
    //   description: 'A classic lead dial wristwatch for a timeless look.',
    //   price: 799.99,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1524592094714-0f0654e20314?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=689&q=80',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Sunglasses',
    //   description: 'Stylish sunglasses to protect your eyes from the sun.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=880&q=80',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Denim Jacket',
    //   description: 'A stylish denim jacket for a casual look.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://media.istockphoto.com/id/475570206/photo/denim-jacket.jpg?s=612x612&w=0&k=20&c=-RlIxj6nOvJYyIMu_GS8MYUzRLw3IEVwDXen-x5JSKY=',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Blender',
    //   description: 'A high-performance blender for all your blending needs.',
    //   price: 129.99,
    //   imageUrl:
    //       'https://images.philips.com/is/image/philipsconsumer/vrs_bab80040b24ded0622afcfb39a0c60ea8ff597f6?&wid=309&hei=309&',
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'Trainers',
    //   description: 'Comfortable trainers for your daily workouts.',
    //   price: 89.99,
    //   imageUrl:
    //       'https://media.gq-magazine.co.uk/photos/67fe75dc1ef0b50f5b34e869/2:3/w_720,h_1080,c_limit/Trainers-of-the-week-nike-air-max-95-pink-foam.jpg',
    // ),
    // Product(
    //   id: 'p12',
    //   title: 'Smartphone',
    //   description: 'A latest model smartphone with all the features you need.',
    //   price: 699.99,
    //   imageUrl:
    //       'https://images.macrumors.com/t/wXcNk2fbdw9q5ZOIpys7Gm7NkTU=/1600x0/article-new/2025/09/iPhone-17-Colors.jpg',
    //  ),
  ];

   Future<void> fetchAndSetProducts() async {
    final url = 'https://project-1-4a49d-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


Future<void> addProduct(Product product) {
    final url = Uri.parse('https://project-1-4a49d-default-rtdb.firebaseio.com/products.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((response) {
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    }).catchError((error){
      print (error);
      throw(error);
    });
  }

  List<Product> get items {
    return [..._items];
  }
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
 

 Future<void> updateProduct(String id, Product newProduct) async {
  final prodIndex = _items.indexWhere((prod) => prod.id == id);
  if (prodIndex >= 0) {
    final url = Uri.parse('https://project-1-4a49d-default-rtdb.firebaseio.com/products/$id.json');
    await http.patch(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );
    _items[prodIndex] = newProduct;
    notifyListeners();
  } else {
    print('Product not found');
  }
}



 Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
