import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class SupplierOrders {
  String? id;
  String? supplierId;
  List<String>? productId;
  Int? quantity;
  Double? amountDue;
  Double? amountPaid;
  Double? totalAmountDue;
  Double? discountReceived;
  DateTime? paymentPeriod;
  DateTime? dateForDelivery;
  bool? isSupplied;
  DateTime? createdAt;

  SupplierOrders({
    @required id,
    @required supplierId,
    @required productId,
    @required quantity,
    @required amountDue,
    @required amountPaid,
    @required totalAmountDue,
    discountReceived,
    paymentPeriod,
    dateForDelivery,
    isSupplied,
    createdAt,
  });

  //supplierOrders list
  List<SupplierOrders> supplierOrders = [];

  //get all supplier orders
  List<SupplierOrders> getAllSupplierOrders() {
    return supplierOrders;
  }

  //create a new supplier order
  String newSupplierOrder(
    String supplierId,
    List<String> productId,
    Int quantity,
    Double amountDue,
    Double totalAmountDue, [
    Double? amountPaid,
    Double? discountReceived,
    DateTime? paymentPeriod,
    DateTime? dateForDelivery,
  ]) {
    //check there are no empty values
    if (supplierId.isNotEmpty &&
        productId.isNotEmpty &&
        quantity != 0 &&
        amountDue != 0 &&
        totalAmountDue != 0) {
      //create supplier order id
      final supplierOrderId = Uuid().v4();
      //timestamp for creation
      final dateCreated = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      //create new supplier order
      final newSupplierOrder = SupplierOrders(
        id: supplierOrderId,
        supplierId: supplierId,
        productId: productId,
        quantity: quantity,
        amountDue: amountDue,
        amountPaid: amountPaid,
        totalAmountDue: totalAmountDue,
        discountReceived: discountReceived,
        paymentPeriod: paymentPeriod,
        dateForDelivery: dateForDelivery,
        isSupplied: false,
        createdAt: dateCreated,
      );
      //add new supplier order
      supplierOrders.add(newSupplierOrder);
      //check if new order was added
      if (supplierOrders.contains(newSupplierOrder)) {
        return 'supplier order created successfully';
      } else {
        return 'failed to create new supplier order';
      }
    } else {
      return 'no empty values allowed';
    }
  }

  //update supplier order
  String updateSupplierOrder(
    int index, [
    String? supplierId,
    List<String>? productId,
    Int? quantity,
    Double? amountDue,
    Double? totalAmountDue,
    Double? amountPaid,
    Double? discountReceived,
    DateTime? paymentPeriod,
    DateTime? dateForDelivery,
  ]) {
    //check if the supplier order exists
    if (supplierOrders.contains(supplierOrders[index])) {
      //update the individual values
      supplierOrders[index].supplierId =
          supplierId ?? supplierOrders[index].supplierId;
      supplierOrders[index].productId =
          productId ?? supplierOrders[index].productId;
      supplierOrders[index].quantity =
          quantity ?? supplierOrders[index].quantity;
      supplierOrders[index].amountDue =
          amountDue ?? supplierOrders[index].amountDue;
      supplierOrders[index].totalAmountDue =
          totalAmountDue ?? supplierOrders[index].totalAmountDue;
      supplierOrders[index].amountPaid =
          amountPaid ?? supplierOrders[index].amountPaid;
      supplierOrders[index].discountReceived =
          discountReceived ?? supplierOrders[index].discountReceived;
      supplierOrders[index].paymentPeriod =
          paymentPeriod ?? supplierOrders[index].paymentPeriod;
      supplierOrders[index].dateForDelivery =
          dateForDelivery ?? supplierOrders[index].dateForDelivery;
      //check if the updates were successful
      if (supplierOrders[index].supplierId == supplierId ||
          supplierOrders[index].productId == productId ||
          supplierOrders[index].quantity == quantity ||
          supplierOrders[index].amountDue == amountDue ||
          supplierOrders[index].totalAmountDue == totalAmountDue ||
          supplierOrders[index].amountPaid == amountPaid ||
          supplierOrders[index].discountReceived == discountReceived ||
          supplierOrders[index].paymentPeriod == paymentPeriod ||
          supplierOrders[index].dateForDelivery == dateForDelivery) {
        return 'supplier order updated successfully';
      } else {
        return 'failed to update supplier order';
      }
    } else {
      return 'supplier order does not exist';
    }
  }

  //delete supplier order
 String deleteSupplierOrder(int index){
    //check if the supplier order exists
   if(supplierOrders.contains(supplierOrders[index])){
     //delete supplier order
     supplierOrders.remove(supplierOrders[index]);
     //check if supplier order was removed
     if(supplierOrders.contains(supplierOrders[index])){
       return 'failed to delete supplier order';
     }else{
       return 'supplier order deleted successfully';
     }
   }else{
     return 'supplier order does not exist';
   }
 }

 //delete all supplier orders
 String deleteAllSupplierOrders(){
    //check if there are orders to be deleted
   if(supplierOrders.isNotEmpty){
     //delete all orders
     supplierOrders.clear();
     //check if supplier orders have been deleted
     if(supplierOrders.isNotEmpty){
       return 'failed to delete all supplier orders';
     }else{
       return 'supplier orders have been successfully deleted';
     }
   }else{
     return 'no supplier orders';
   }
 }
}
