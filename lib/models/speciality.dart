import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Speciality {
  String? id;
  String? speciality;
  double? price;
  DateTime? createdAt;

  Speciality({@required id, @required speciality, @required price, createdAt});

  // firestore instance
  final _firestore = FirebaseFirestore.instance;

  //firebase auth instance
  final _firebaseAuth = FirebaseAuth.instance;

  //list of specialities
  List<Speciality> specialities = [];

  //get all specialities
  List<Speciality> getAllSpecialities() {
    return specialities;
  }

  //create new speciality
  Future<String> createNewSpeciality(String speciality, double price) async {
    //check for empty values
    if (speciality.isNotEmpty && price != 0.0) {
      //create speciality id
      final specialityId = Uuid().v4();
      // create speciality time stamp
      final createdAt = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      //constructor for new speciality
      final newSpeciality = Speciality(
        id: id,
        speciality: speciality,
        price: price,
        createdAt: createdAt,
      );

      final specialityData = {
        'id': specialityId,
        'speciality': speciality,
        'price': price,
        'createdAt': createdAt,
      };

      _firestore
          .collection('specialities')
          .doc(_firebaseAuth.currentUser!.uid)
          .set(specialityData);

      final docs = await _firestore.collection('specialities').get();

      final docData = docs.docs.where((test)=>test.data().containsValue(specialityId));

      if(docData.isNotEmpty){
        print('speciality created successfully');
      }else{
        print('failed to create speciality');
      }
      // add speciality
      specialities.add(newSpeciality);
      //check if speciality was created
      if (specialities.contains(newSpeciality)) {
        return 'speciality created successfully';
      } else {
        return 'failed to create speciality';
      }
    } else {
      return 'no empty values';
    }
  }

  //update speciality
  String updateSpeciality(int index, [String? speciality, double? price]) {
    //check if speciality exists
    if (specialities.contains(specialities[index])) {
      // update speciality individual values
      specialities[index].speciality =
          speciality ?? specialities[index].speciality;
      specialities[index].price = price ?? specialities[index].price;
      //check if update was a success
      if (specialities[index].speciality == speciality ||
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
