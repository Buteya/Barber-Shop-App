import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Location {
  String? id;
  Int? latitude;
  Int? longitude;
  String? name;
  DateTime? createdAt;

  Location({
    @required id,
    @required latitude,
    @required longitude,
    @required name,
    createdAt,
  });

  // list of all locations
  List<Location> locations = [];

  // view all locations
  List<Location> allLocations() {
    return locations;
  }

  // create new location
  String newLocation(int latitude, int longitude, String name) {
    //check if values are empty
    if (latitude != 0 && longitude != 0 && name.isNotEmpty) {
      //create new location id
      final locationId = Uuid().v4();
      // timestamp for creation of new location
      final dateCreated = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // create new location
      final newLocation = Location(
        id: locationId,
        latitude: latitude,
        longitude: longitude,
        name: name,
        createdAt: dateCreated,
      );
      locations.add(newLocation);
      if (locations.contains(newLocation)) {
        return 'location created successfully';
      } else {
        return 'failed to create location';
      }
    } else {
      return 'no empty values';
    }
  }

  // update location
  String updateLocation(
    int index, [
    Int? latitude,
    Int? longitude,
    String? name,
  ]) {
    //check if location exists
    if (locations.contains(locations[index])) {
      // update the location individual values
      locations[index].latitude = latitude ?? locations[index].latitude;
      locations[index].longitude = longitude ?? locations[index].longitude;
      locations[index].name = name ?? locations[index].name;
      // check if update was successful
      if (locations[index].latitude == latitude ||
          locations[index].latitude == latitude ||
          locations[index].latitude == latitude) {
        return 'location updated successfully';
      } else {
        return 'failed to update location';
      }
    } else {
      return 'location does not exist';
    }
  }

  //delete location
  String deleteLocation(int index) {
    //check if location exists
    if (locations.contains(locations[index])) {
      //remove location
      locations.remove(locations[index]);
      // check if location has been removed
      if (locations.contains(locations[index])) {
        return 'failed to remove location';
      } else {
        return 'location deleted successfully';
      }
    } else {
      return 'location does not exist';
    }
  }

  //delete all locations
  String deleteAllLocations() {
    //check if locations is empty
    if (locations.isNotEmpty) {
      //delete all locations
      locations.clear();
      // check if locations are deleted
      if (locations.isNotEmpty) {
        return 'failed to delete all locations';
      } else {
        return 'successfully deleted all locations';
      }
    } else {
      return 'no locations';
    }
  }
}
