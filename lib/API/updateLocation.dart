import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:social_media_services/screens/serviceman/servicer.dart';

updateLocationFunction(
  BuildContext context,
  List latLon,
  String locality,
) async {
  final provider = Provider.of<DataProvider>(context, listen: false);
  provider.subServicesModel = null;
  final apiToken = Hive.box("token").get('api_token');
  if (apiToken == null) return;
  try {
    var response = await http.post(
        Uri.parse(
            '$updateLocationApi$locality&latitude=${latLon[0]}&longitude=${latLon[1]}'),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log(response.body);
      // navToServiceMan(context, id);
      // if (jsonResponse['result'] == false) {
      //   await Hive.box("token").clear();

      //   return;
      // }
      print("End");
      return;
    } else {
      // print(response.statusCode);
      // print(response.body);
      // print('Something went wrong');
    }
  } on Exception catch (e) {
    log("Something Went Wrong17");
    print(e);
  }
}

navToServiceMan(context, id) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
    return ServicerPage(
      id: id,
    );
  }));
}
