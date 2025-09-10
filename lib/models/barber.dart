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
    String? password
  ) async {
    print('called newBarber');
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
        'email':email,
        'isFree': false,
        'isOnHoliday': false,
        'isClockedIn': false,
        'isSuspended': false,
        'isFired': false,
        'createdAt': createdTime,
      };
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Example using set() with a specific document ID
        final collectionRef = _firestore.collection('users');
        final docRef = collectionRef.where('email',isEqualTo: email);
        final docSnapshot = await docRef.get();
        if (docSnapshot.docs.isEmpty) {
          var newUserUid;
          _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password!).whenComplete((){
            print(currentUser);
            newUserUid = _firebaseAuth.currentUser!.uid;
            print(newUserUid);
          });
          final userId = Uuid().v4();
          Map<String, dynamic> userData = {
            'id': userId,
            'imagePath':imagePath,
            'username': '',
            'email': email,
            'password': password,
            'phoneNumber': '',
            'country': '',
            'city': '',
            'createdAt': createdTime,
            'isOnline': false,
          };
          if(currentUser.uid != newUserUid){
            await _firestore
                .collection('users')
                .doc(newUserUid)
                .set(userData);
          }else{
            print('uids are equal');
          }
          var newEmail = await _firestore.collection('users').where('email',isEqualTo: email).get();
         if(newEmail.docs.isNotEmpty){
           await _firestore
               .collection('barbers')
               .doc(_firebaseAuth.currentUser!.uid)
               .set(barberData);
         }else{
           print('email is empty in users');
         }

        }else{
          print('got update users to make a barber for user with the $email');
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
