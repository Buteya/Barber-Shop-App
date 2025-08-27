import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Supplier {
  String? id;
  String? locationId;
  List<String>? productId;
  String? name;
  String? mobileNumber;
  DateTime? createdAt;

  Supplier({
    @required id,
    @required locationId,
    @required productId,
    @required name,
    @required mobileNumber,
    createdAt,
  });

  //list of suppliers
  List<Supplier> suppliers = [];

  //get all suppliers
  List<Supplier> getAllSuppliers() {
    return suppliers;
  }

  // create a new supplier
  String creatSupplier(
    String locationId,
    List<String> productId,
    String name,
    String mobileNumber,
  ) {
    //check for empty values
    if (locationId.isNotEmpty &&
        productId.isNotEmpty &&
        name.isNotEmpty &&
        mobileNumber.isNotEmpty) {
      //create supplier id
      final supplierId = Uuid().v4();
      //timestamp for creation
      final dateCreated = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // construct new supplier
      final newSupplier = Supplier(
        id: supplierId,
        locationId: locationId,
        productId: productId,
        name: name,
        mobileNumber: mobileNumber,
        createdAt: dateCreated,
      );
      //add new supplier
      suppliers.add(newSupplier);
      //check if supplier was added
      if (suppliers.contains(newSupplier)) {
        return 'supplier added successfully';
      } else {
        return 'failed to add supplier';
      }
    } else {
      return 'no empty values';
    }
  }

  //update supplier
  String updateSupplier(
    int index, [
    String? locationId,
    List<String>? productId,
    String? name,
    String? mobileNumber,
  ]) {
    //check if supplier exists
    if (suppliers.contains(suppliers[index])) {
      //change the individual values
      suppliers[index].locationId = locationId ?? suppliers[index].locationId;
      suppliers[index].productId = productId ?? suppliers[index].productId;
      suppliers[index].name = name ?? suppliers[index].name;
      suppliers[index].mobileNumber =
          mobileNumber ?? suppliers[index].mobileNumber;
      //check if the updates came through
      if (suppliers[index].locationId == locationId ||
          suppliers[index].productId == productId ||
          suppliers[index].name == name ||
          suppliers[index].mobileNumber == mobileNumber) {
        return 'supplier updated successfully';
      } else {
        return 'failed to update supplier';
      }
    } else {
      return 'supplier does not exist';
    }
  }

  //delete the supplier
 String deleteSupplier(int index){
    //check if the supplier is there
    if(suppliers.contains(suppliers[index])){
      //remove supplier
      suppliers.remove(suppliers[index]);
      //check if supplier has been removed
      if(suppliers.contains(suppliers[index])){
        return 'failed to delete supplier';
      }else{
        return 'supplier deleted successfully';
      }
    }else{
      return 'supplier does not exist';
    }
 }

 //delete all suppliers
 String deleteAllSuppliers(){
    //check if suppliers are there
   if(suppliers.isNotEmpty){
     //remove all suppliers
     suppliers.clear();
     //check if suppliers have been removed
     if(suppliers.isNotEmpty){
       return 'failed to remove all suppliers';
     }else{
       return 'all suppliers removed successfully';
     }
   }else{
     return 'no suppliers';
   }
 }
}
