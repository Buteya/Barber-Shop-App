import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Product {
  String? id;
  String? supplierId;
  String? imagePath;
  String? name;
  double? price;
  int? quantity;
  bool? isAvailable;
  bool? isDiscounted;
  DateTime? createdAt;

  Product({
    @required id,
    @required supplierId,
    @required imagePath,
    @required name,
    @required price,
    @required quantity,
    isAvailable,
    isDiscounted,
    createdAt,
  });

  List<Product> products = [];

  // gets all products
  List<Product> allProducts() {
    return products;
  }
  // firestore instance
  final _firestore = FirebaseFirestore.instance;

  // firebase auth instance
  final _firebaseAuth = FirebaseAuth.instance;

  // function to create new product
  Future<String> createNewProduct(
    String supplierId,
    String imagePath,
    String name,
    double price,
    int quantity,
  ) async {
    if (supplierId.isNotEmpty &&
        imagePath.isNotEmpty &&
        name.isNotEmpty &&
        price != 0.0 &&
        quantity != 0) {
      // new productId
      String productId = Uuid().v4();
      // date stamp for product creation
      final dateCreated = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());

      //new product constructor
      Product newProduct = Product(
        id: productId,
        supplierId: supplierId,
        name: name,
        price: price,
        quantity: quantity,
        isAvailable: true,
        isDiscounted: false,
        createdAt: dateCreated,
        imagePath: imagePath,
      );

      final productData = {
        'id': productId,
        'supplierId': supplierId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'isAvailable': true,
        'isDiscounted': false,
        'createdAt': dateCreated,
        'imagePath': imagePath,
      };

      await _firestore
          .collection('products')
          .doc(_firebaseAuth.currentUser!.uid)
          .set(productData);

      final product = await _firestore
          .collection('products')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      if(product.data()!.containsValue(productId)){
        print(product.data());
      }else{
        print('failed to add product');
      }

      // returning the product if found that is equivalent to the new product
      final productCheck = products.firstWhere((product) {
        return product.id == productId;
      });

      if (products.contains(newProduct) && productCheck.quantity! != 0) {
        return 'product already exists';
      } else {
        products.add(newProduct);
        return 'product added successfully';
      }
    } else {
      return 'product not created successfully';
    }
  }

  // function update product
  String updateProduct(
    int index, [
    String? name,
    String? supplierName,
    double? price,
    int? quantity,
  ]) {
    // check if product exists
    if (products.contains(products[index])) {
      products[index].name = name ?? products[index].name;
      products[index].price = (price ?? products[index].price);
      products[index].quantity = (quantity ?? products[index].quantity);
      // check if product updated
      if (products[index].name == name ||
          products[index].price == price ||
          products[index].quantity == quantity) {
        return 'product updated successfully';
      } else {
        return 'product did not update successfully';
      }
    } else {
      return 'Product does not exist';
    }
  }

  // delete product
  String deleteProduct(int index) {
    if (products.contains(products[index])) {
      products.remove(products[index]);
      if (products.contains(products[index])) {
        return 'product was not deleted';
      } else {
        return 'product was deleted successfully';
      }
    } else {
      return 'product does not exist';
    }
  }

  //delete all products
  String deleteAllProducts() {
    // check if products are there
    if (products.isNotEmpty) {
      products.clear();
      //check if products have been deleted
      if (products.isEmpty) {
        return 'all products deleted';
      } else {
        return 'failed to delete all products';
      }
    } else {
      return 'no products';
    }
  }
}
