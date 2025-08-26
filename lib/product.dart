import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Product {
  String? id;
  String? name;
  String? supplierName;
  Double? price;
  Int? quantity;
  Bool? isAvailable;
  Bool? isDiscounted;
  DateTime? createdAt;

  Product({
    @required id,
    @required name,
    @required supplierName,
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

  // function to create new product
  String createNewProduct(
    String name,
    String supplierName,
    Double price,
    int quantity,
  ) {
    if (name.isNotEmpty &&
        supplierName.isNotEmpty &&
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
        name: name,
        supplierName: supplierName,
        price: price,
        quantity: quantity,
        isAvailable: true,
        isDiscounted: false,
        createdAt: dateCreated,
      );
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
    Double? price,
    int? quantity,
  ]) {
    // check if product exists
    if (products.contains(products[index])) {
      products[index].name = name ?? products[index].name;
      products[index].supplierName =
          supplierName ?? products[index].supplierName;
      products[index].price = price ?? products[index].price;
      products[index].quantity = (quantity ?? products[index].quantity) as Int?;
      // check if product updated
      if (products[index].name == name ||
          products[index].supplierName == supplierName ||
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
