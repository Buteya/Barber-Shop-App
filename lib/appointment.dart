import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Appointment {
  String? id;
  String? barberId;
  String? userId;
  String? locationId;
  String? notificationId;
  DateTime? createdAt;
  Bool? isBooked;
  Bool? isDone;

  Appointment({
    @required id,
    @required barberId,
    @required userId,
    @required locationId,
    @required notificationId,
    createdAt,
    isBooked,
    isDone,
  });

  //appointment list
  List<Appointment> appointments = [];

  //view all appointments
  List<Appointment> allAppointments() {
    return appointments;
  }

  //create new appointment
  String createAppointment(
    String barberId,
    String userId,
    String locationId,
    String notificationId,
  ) {
    if (barberId.isNotEmpty &&
        userId.isNotEmpty &&
        locationId.isNotEmpty &&
        notificationId.isNotEmpty) {
      // new appointment id
      final appointmentId = Uuid().v4();
      // timestamp of new appointment
      final dateCreated = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // constructor for new appointment
      final newAppointment = Appointment(
        id: appointmentId,
        barberId: barberId,
        userId: userId,
        locationId: locationId,
        notificationId: notificationId,
        createdAt: dateCreated,
        isBooked: false,
        isDone: false,
      );
      // check if appointment exists
      if (appointments.contains(newAppointment)) {
        return 'appointment already exists';
      } else {
        // add appointment
        appointments.add(newAppointment);
        //check if appointment has been added
        if (appointments.contains(newAppointment)) {
          return 'appointment added successfully';
        } else {
          return 'failed to add appointment';
        }
      }
    } else {
      return 'no empty fields';
    }
  }

  // update appointment
  String updateAppointment(
    int index, [
    String? barberId,
    String? userId,
    String? locationId,
    String? notificationId,
  ]) {
    // check if appointment exists
    if (appointments.contains(appointments[index])) {
      // update individual appointment values
      appointments[index].barberId = barberId ?? appointments[index].barberId;
      appointments[index].userId = userId ?? appointments[index].userId;
      appointments[index].locationId =
          locationId ?? appointments[index].locationId;
      appointments[index].notificationId =
          notificationId ?? appointments[index].notificationId;
      // check if update was successful
      if (appointments[index].barberId == barberId ||
          appointments[index].userId == userId ||
          appointments[index].locationId == locationId ||
          appointments[index].notificationId == notificationId) {
        return 'updated appointment successfully';
      } else {
        return 'failed to update appointment';
      }
    } else {
      return 'appointment does not exist';
    }
  }

  // delete appointment
  String deleteAppointment(int index) {
    // check if appointment exists
    if (appointments.contains(appointments[index])) {
      // delete appointment
      appointments.remove(appointments[index]);
      // check if appointment was deleted
      if (appointments.contains(appointments[index])) {
        return 'failed to remove appointment';
      } else {
        return 'appointment deleted successfully';
      }
    } else {
      return 'appointment does not exist';
    }
  }

  // delete all appointments
  String deleteAllAppointments() {
    //check if appointments exist
    if (appointments.isNotEmpty) {
      //remove all appointments
      appointments.clear();
      //check if all appointments have been removed
      if (appointments.isNotEmpty) {
        return 'failed to remove all appointments';
      } else {
        return 'removed all appointments successfully';
      }
    } else {
      return 'no appointments';
    }
  }
}
