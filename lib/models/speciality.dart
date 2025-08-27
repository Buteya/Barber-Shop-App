import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Speciality {
  String? id;
  List<String>? barberId;
  Double? price;
  DateTime? createdAt;

  Speciality({@required id, @required barberId, @required price, createdAt});

  //list of specialities
  List<Speciality> specialities = [];

  //get all specialities
  List<Speciality> getAllSpecialities() {
    return specialities;
  }

  //create new speciality
  String createNewSpeciality(List<String> barberId, Double price) {
    //check for empty values
    if (barberId.isNotEmpty && price != 0.0) {
      //create speciality id
      final specialityId = Uuid().v4();
      // create speciality time stamp
      final createdAt = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      //constructor for new speciality
      final newSpeciality = Speciality(
        id: id,
        barberId: barberId,
        price: price,
        createdAt: createdAt,
      );
      // add speciality
      specialities.add(newSpeciality);
      //check if speciality was created
      if(specialities.contains(newSpeciality)){
        return 'speciality created successfully';
      }else {
        return 'failed to create speciality';
      }
    } else {
      return 'no empty values';
    }
  }

  //update speciality
  String updateSpeciality(int index, [List<String>? barberId, Double? price]) {
    //check if speciality exists
    if (specialities.contains(specialities[index])) {
      // update speciality individual values
      specialities[index].barberId = barberId ?? specialities[index].barberId;
      specialities[index].price = price ?? specialities[index].price;
      //check if update was a success
      if (specialities[index].barberId == barberId ||
          specialities[index].price == price) {
        return 'speciality was updated successfully';
      } else {
        return 'failed to update speciality';
      }
    } else {
      return 'speciality does not exist';
    }
  }

  //delete speciality
  String deleteSpeciality(int index) {
    //check if speciality exists
    if (specialities.contains(specialities[index])) {
      //delete speciality
      specialities.remove(specialities[index]);
      //check if speciality is deleted
      if (specialities.contains(specialities[index])) {
        return 'failed to delete speciality';
      } else {
        return 'speciality was deleted successfully';
      }
    } else {
      return 'speciality does not exist';
    }
  }

  //delete all specialities
  String deleteAllSpecialities() {
    //check if specialities exists
    if (specialities.isNotEmpty) {
      specialities.clear();
      //check if specialities were deleted
      if (specialities.isNotEmpty) {
        return 'failed to delete specialities';
      } else {
        return 'specialities deleted successfully';
      }
    } else {
      return 'no specialities';
    }
  }
}
