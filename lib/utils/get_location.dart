// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/API/updateLocation.dart';
import 'package:social_media_services/API/viewProfile.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:social_media_services/providers/servicer_provider.dart';
import 'package:social_media_services/utils/animatedSnackBar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

requestLocationPermission(
  BuildContext context,
) async {
  LocationPermission permission = await Geolocator.checkPermission();
  final str = AppLocalizations.of(context)!;
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print("'Location permissions are permanently denied");
      showAnimatedSnackBar(context, str.snack_enable_loc);
    } else {
      print("GPS Location service is granted");
      final latLon = await getCurrentLocation();
      final location = await getPlaceAddress(latLon);
      await updateLocationFunction(
        context,
        latLon,
        location,
      );
      await viewProfile(context);
    }
  } else {
    print("GPS Location permission granted.");
    final latLon = await getCurrentLocation();
    final location = await getPlaceAddress(latLon);
    await updateLocationFunction(
      context,
      latLon,
      location,
    );
    await viewProfile(context);
  }
  // searchController.text.isEmpty ? getCurrentLocation() : null;
}

requestExplorerLocationPermission(
  BuildContext context,
) async {
  LocationPermission permission = await Geolocator.checkPermission();
  final str = AppLocalizations.of(context)!;
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print("'Location permissions are permanently denied");
      showAnimatedSnackBar(context, str.snack_enable_loc);
    } else {
      print("GPS Location service is granted");
      final latLon = await getCurrentLocation();
      final provider = Provider.of<DataProvider>(context, listen: false);
      provider.explorerLat = latLon[0].toString();
      provider.explorerLong = latLon[1].toString();
    }
  } else {
    print("GPS Location permission granted.");
    final latLon = await getCurrentLocation();
    final provider = Provider.of<DataProvider>(context, listen: false);
    provider.explorerLat = latLon[0].toString();
    provider.explorerLong = latLon[1].toString();
  }
  // searchController.text.isEmpty ? getCurrentLocation() : null;
}

sendCurrentLocation(
  BuildContext context,
) async {
  LocationPermission permission = await Geolocator.checkPermission();
  final str = AppLocalizations.of(context)!;
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      log('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      log("'Location permissions are permanently denied");
      showAnimatedSnackBar(context, str.snack_enable_loc);
    } else {
      log("GPS Location service is granted");
    }
  } else {
    log("GPS Location permission granted.");
    final latLon = await getCurrentLocation();
    // final location = await getPlaceAddress(latLon);
    final latlonString = "${latLon[0]},${latLon[1]}";
    print(latlonString);
    await sendLocation(
      context,
      latlonString,
    );
    log("Location send");
  }
  // searchController.text.isEmpty ? getCurrentLocation() : null;
}

sendLocation(context, String latLon) async {
  final provider = Provider.of<DataProvider>(context, listen: false);
  final receiverId = provider.serviceManDetails?.userData?.id.toString();
  final str = AppLocalizations.of(context)!;
  provider.subServicesModel = null;
  final apiToken = Hive.box("token").get('api_token');
  final url =
      '$api/chat-store?receiver_id=$receiverId&type=location&message=$latLon&page=1';

  print(url);

  provider.isLocationSending = true;
  print(provider.isLocationSending);
  // return;
  try {
    var response = await http.post(Uri.parse(url),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log("Location sended successfully");
      provider.isSendingSuccessFull = true;
      log(response.body);
      final servicerProvider =
          Provider.of<ServicerProvider>(context, listen: false);
    } else {
      showAnimatedSnackBar(context, str.snack_message_sent);
    }
  } on Exception catch (e) {
    showAnimatedSnackBar(context, str.snack_message_sent);
    print(e);
  }
}

Future<List<double>> getCurrentLocationPermission(
  BuildContext context,
) async {
  late List<double> latLon;
  LocationPermission permission = await Geolocator.checkPermission();
  final str = AppLocalizations.of(context)!;
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      log('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      log("'Location permissions are permanently denied");
      showAnimatedSnackBar(context, str.snack_enable_loc);
    } else {
      log("GPS Location service is granted");
      latLon = await getCurrentLocation();
      // final location = await getPlaceAddress(latLon);
      final latlonString = "${latLon[0]},${latLon[1]}";
      print(latlonString);
      return latLon;
    }
    return [0, 0];
  } else {
    log("GPS Location permission granted.");
    latLon = await getCurrentLocation();
    // final location = await getPlaceAddress(latLon);
    final latlonString = "${latLon[0]},${latLon[1]}";
    print(latlonString);

    return latLon;
  }

  // searchController.text.isEmpty ? getCurrentLocation() : null;
}

Future<List<double>> getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  double latitude = position.latitude;
  double longitude = position.longitude;
  List<double> latLon = [];
  latLon.addAll([latitude, longitude]);

  return latLon;
}

Future<String> getPlaceAddress(List<double> latLon) async {
  String locationAddress = '';
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLon[0], latLon[1]);

    locationAddress = getLocationName(placemarks);
  } catch (error) {
    print(error);
  }
  return locationAddress;
}

String getLocationName(List<Placemark> placemarks) {
  String locality = '';
  if (placemarks[0].subLocality!.isNotEmpty) {
    locality = '${placemarks[0].subLocality} | ${placemarks[0].country}';
  } else if (placemarks[0].locality!.isNotEmpty) {
    locality = '${placemarks[0].locality} | ${placemarks[0].country}';
  } else if (placemarks[0].street!.isNotEmpty) {
    locality = '${placemarks[0].street} | ${placemarks[0].country}';
  } else if (placemarks[0].subAdministrativeArea!.isNotEmpty) {
    locality =
        '${placemarks[0].subAdministrativeArea} | ${placemarks[0].country}';
  } else if (placemarks[0].administrativeArea!.isNotEmpty) {
    locality = '${placemarks[0].administrativeArea} | ${placemarks[0].country}';
  } else if (placemarks[0].name!.isNotEmpty) {
    locality = '${placemarks[0].name} | ${placemarks[0].country}';
  } else {}
  print(locality);
  return locality;
}
