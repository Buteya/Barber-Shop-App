import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CustomerOrder {
  String? id;
  String? appointmentId;
  String? userId;
  List<String>? productId;
  DateTime? createdAt;
  bool? isPaid;

  CustomerOrder({
    @required id,
    @required appointmentId,
    @required userId,
    @required productId,
    createdAt,
    isPaid,
  });

  //list of customer orders
  List<CustomerOrder> customerOrders = [];

  //get all of customer orders
  List<CustomerOrder> getAllCustomerOrders() {
    return customerOrders;
  }

  // create new customer order
  String newCustomerOrder(
    String appointmentId,
    String userId,
    List<String> productId,
  ) {
    if (userId.isNotEmpty) {
      //create new customer order id
      final newCustomerOrderId = Uuid().v4();
      //create timestamp for customer order
      final createdAt = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // constructor for new customer order
      final newCustomerOrder = CustomerOrder(
        id: id,
        appointmentId: appointmentId,
        userId: userId,
        productId: productId,
      );
      //add new customer order
      customerOrders.add(newCustomerOrder);
      //check if the new customer order has been added
      if (customerOrders.contains(newCustomerOrder)) {
        return 'customer order has been created successfully';
      } else {
        return 'failed to create customer order';
      }
    } else {
      return 'no empty values';
    }
  }

  //update customer order
  String updateCustomerOrder(
    int index, [
    String? appointmentId,
    List<String>? productId,
  ]) {
    //check if customer order is there
    if (customerOrders.contains(customerOrders[index])) {
      //change individual values of customer order
      customerOrders[index].appointmentId =
          appointmentId ?? customerOrders[index].appointmentId;
      customerOrders[index].productId =
          productId ?? customerOrders[index].productId;
      //check if update was successful
      if (customerOrders[index].appointmentId == appointmentId ||
          customerOrders[index].productId == productId) {
        return 'customer order update was successful';
      } else {
        return 'failed to update customer order';
      }
    } else {
      return 'customer order does not exist';
    }
  }

  //delete customer order
 String deleteCustomerOrder(int index){
    //check if customer order exists
   if(customerOrders.contains(customerOrders[index])){
     //delete customer order
     customerOrders.remove(customerOrders[index]);
     //check if customer order was deleted
     if(customerOrders.contains(customerOrders[index])){
       return 'failed to delete customer order';
     }else{
       return 'successfully deleted customer order';
     }
   }else{
     return 'customer order does not exist';
   }
 }

  //delete all customer orders
  String deleteAllCustomerOrders(){
    //check if there are customer orders to be deleted
    if(customerOrders.isNotEmpty){
      //delete all customer orders
      customerOrders.clear();
      //check if customer orders have been deleted
      if(customerOrders.isNotEmpty){
        return 'failed to delete all customer orders';
      }else{
        return 'customer orders have been successfully deleted';
      }
    }else{
      return 'no customer orders';
    }
  }
}
