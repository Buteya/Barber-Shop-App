import 'dart:ffi';

import 'package:flutter/material.dart';

class Product {
  String? id;
  String? name;
  Double? price;
  Int? quantity;
  Bool? isAvailable;
  Bool? isDiscounted;
  DateTime? createdAt;

  Product({
    @required id,
    @required name,
    @required price,
    @required quantity,
    isAvailable,
    isDiscounted,
    createdAt,
  });
}
