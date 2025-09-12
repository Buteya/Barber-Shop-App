import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Barber {
  String? id;
  String? imagePath;
  String? firstname;
  String? lastname;
  String? mobileNumber;
  String? specialityId;
  String? email;
  double? salary;
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
    @required email,
    imagePath,
    isFree,
    isOnHoliday,
    isClockedIn,
    isSuspended,
    isFired,
    createdAt,
  });

  List<Barber> barbers = [];

  // cloud firestore instance
  final _firestore = FirebaseFirestore.instance;

  // current user
  final _firebaseAuth = FirebaseAuth.instance;

  // retrieve all barbers
  List<Barber> allBarbers() {
    return barbers;
  }

  // create a new barber
  Future<String> newBarber(
    String imagePath,
    String firstname,
    String lastname,
    String speciality,
    String email,
    double? salary,
  ) async {
    print('called newBarber');
    // check if values are empty
    if (imagePath.isNotEmpty &&
        firstname.isNotEmpty &&
        lastname.isNotEmpty &&
        email.isNotEmpty &&
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
        imagePath: imagePath,
        firstname: firstname,
        lastname: lastname,
        speciality: speciality,
        salary: salary,
        email: email,
        isFree: false,
        isOnHoliday: false,
        isClockedIn: false,
        isSuspended: false,
        isFired: false,
        createdAt: createdTime,
      );
      Map<String, dynamic> barberData = {
        'id': barberId,
        'imagePath': imagePath,
        'firstname': firstname,
        'lastname': lastname,
        'speciality': speciality,
        'salary': salary,
        'email': email,
        'isFree': false,
        'isOnHoliday': false,
        'isClockedIn': false,
        'isSuspended': false,
        'isFired': false,
        'createdBy': _firebaseAuth.currentUser!.uid,
        'createdAt': createdTime,
      };

      if (_firebaseAuth.currentUser!.uid.isNotEmpty) {
        // Example using set() with a specific document ID
        final collectionRef = _firestore.collection('users');
        final docRef = collectionRef.where('email', isEqualTo: email);
        final docSnapshot = await docRef.get();
        final documentId = docSnapshot.docs.first.id;
        print(documentId.length);
        print(documentId);
        if (docSnapshot.docs.isNotEmpty) {
          await collectionRef.doc(documentId).update({
            'barberId': barberId,
            'isBarber':true,
          });

          await _firestore
              .collection('barbers')
              .doc(documentId)
              .set(barberData);

          final newBarber = await _firestore.collection('barbers').doc(documentId).get();
          if(newBarber.exists){
            print('barber created successfully');
          }
        } else {
          print('cant find user with $email');
        }
      }

      barbers.add(newBarber);
      if (barbers.contains(newBarber)) {
        return 'barber created successfully';
      } else {
        return 'failed to create new barber';
      }
    } else {
      return 'no empty values';
    }
  }

  // update a barber
  String updateBarber(
    int index, [
    String? firstname,
    String? lastname,
    String? speciality,
    double? salary,
  ]) {
    if (barbers.contains(barbers[index])) {
      // update individual values in barber
      barbers[index].firstname = firstname ?? barbers[index].firstname;
      barbers[index].lastname = lastname ?? barbers[index].lastname;
      barbers[index].specialityId = speciality ?? barbers[index].specialityId;
      barbers[index].salary = (salary ?? barbers[index].salary);
      // check if updates were successful
      if (barbers[index].firstname == firstname ||
          barbers[index].lastname == lastname ||
          barbers[index].specialityId == speciality ||
          barbers[index].salary == salary) {
        return 'barber was updated successfully';
      } else {
        return 'failed to update barber';
      }
    } else {
      return 'barber does not exist';
    }
  }

  // delete a barber
  String deleteBarber(int index) {
    // check if barber exists
    if (barbers.contains(barbers[index])) {
      barbers.remove(barbers[index]);
      if (barbers.contains(barbers[index])) {
        return 'barber was not deleted successfully';
      } else {
        return 'barber was deleted successfully';
      }
    } else {
      return 'barber does not exist';
    }
  }

  // delete all users
  String deleteAllBarbers() {
    if (barbers.isNotEmpty) {
      barbers.clear();
      if (barbers.isEmpty) {
        return 'all barbers deleted successfully';
      } else {
        return 'failed to delete all barbers';
      }
    } else {
      return 'no barbers';
    }
  }
}
