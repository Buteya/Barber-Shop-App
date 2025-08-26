import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Barber {
  String? id;
  String? firstname;
  String? lastname;
  String? mobileNumber;
  String? speciality;
  Double? salary;
  bool? isFree;
  bool? isOnHoliday;
  bool? isClockedIn;
  bool? isSuspended;
  bool? isFired;
  DateTime? createdAt;

  Barber({
    @required id,
    @required firstname,
    @required lastname,
    @required speciality,
    @required salary,
    isFree,
    isOnHoliday,
    isClockedIn,
    isSuspended,
    isFired,
    createdAt,
  });

  List<Barber> barbers = [];

  // retrieve all barbers
  List<Barber> allBarbers(){
    return barbers;
  }

  // create a new barber
  String newBarber(
    String firstname,
    String lastname,
    String speciality,
    Double salary,
  ) {
    // check if values are empty
    if (firstname.isNotEmpty &&
        lastname.isNotEmpty &&
        speciality.isNotEmpty &&
        salary != 0) {
      // create new barber id
      final barberId = Uuid().v4();
      // timestamp for barber creation
      final createdTime = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // construct new barber
      final newBarber = Barber(
        id: barberId,
        firstname: firstname,
        lastname: lastname,
        speciality: speciality,
        salary: salary,
        isFree:false,
        isOnHoliday:false,
        isClockedIn:false,
        isSuspended:false,
        isFired:false,
        createdAt: createdTime,
      );

      barbers.add(newBarber);
      if(barbers.contains(newBarber)){
        return 'barber created successfully';
      }else {
        return 'failed to create new barber';
      }
    } else {
      return 'no empty values';
    }
  }

  // update a barber
  String updateBarber(int index,[String? firstname, String? lastname, String? speciality, Double? salary] ){
    if(barbers.contains(barbers[index])){
      // update individual values in barber
      barbers[index].firstname = firstname ??  barbers[index].firstname;
      barbers[index].lastname = lastname ??  barbers[index].lastname;
      barbers[index].speciality = speciality ??  barbers[index].speciality;
      barbers[index].salary = (salary ??  barbers[index].salary);
      // check if updates were successful
      if(barbers[index].firstname == firstname ||
         barbers[index].lastname == lastname ||
         barbers[index].speciality == speciality ||
         barbers[index].salary == salary){
        return 'barber was updated successfully';
      }else {
        return 'failed to update barber';
      }
    }else{
      return 'barber does not exist';
    }
  }

  // delete a barber
  String deleteBarber(int index){
    // check if barber exists
    if(barbers.contains(barbers[index])){
      barbers.remove(barbers[index]);
      if(barbers.contains(barbers[index])){
        return 'barber was not deleted successfully';
      }else{
        return 'barber was deleted successfully';
      }
    }else {
      return 'barber does not exist';
    }
  }

  // delete all users
  String deleteAllBarbers(){
    if(barbers.isNotEmpty){
      barbers.clear();
      if(barbers.isEmpty){
        return 'all barbers deleted successfully';
      }else {
        return 'failed to delete all barbers';
      }
    }else{
      return 'no barbers';
    }
  }
}
