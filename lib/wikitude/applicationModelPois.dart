import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'poi.dart';

class ApplicationModelPois {
  static Future<List<Poi>> prepareApplicationDataModel(
      Position position) async {
    final Random random = Random();
    const int min = 1;
    const int max = 10;
    const int placesAmount = 10;

    List<Poi> pois = <Poi>[];
    try {
      for (int i = 0; i < placesAmount; i++) {
        pois.add(Poi(
            i + 1,
            position.longitude + 0.001 * (5 - min + random.nextInt(max - min)),
            position.latitude + 0.001 * (5 - min + random.nextInt(max - min)),
            'This is the description of POI#${i + 1}',
            position.altitude,
            'POI#${i + 1}'));
      }
    } catch (e) {
      debugPrint("Location Error: $e");
    }
    return pois;
  }

  // static Future<List<Poi>> prepareApplicationDataModel() async {
  //   final Random random = new Random();
  //   const int min = 1;
  //   const int max = 10;
  //   const int placesAmount = 10;
  //   final Location location = new Location();

  //   List<Poi> pois = <Poi>[];
  //   try {
  //     LocationData userLocation = await location.getLocation();
  //     for (int i = 0; i < placesAmount; i++) {
  //       pois.add(new Poi(
  //           i + 1,
  //           userLocation.longitude! +
  //               0.001 * (5 - min + random.nextInt(max - min)),
  //           userLocation.latitude! +
  //               0.001 * (5 - min + random.nextInt(max - min)),
  //           'This is the description of POI#' + (i + 1).toString(),
  //           userLocation.altitude!,
  //           'POI#' + (i + 1).toString()));
  //     }
  //   } catch (e) {
  //     print("Location Error: " + e.toString());
  //   }
  //   return pois;
  // }
}
