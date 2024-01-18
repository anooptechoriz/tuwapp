import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/model/region_info_model.dart';
import 'package:social_media_services/model/state_info_model.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:http/http.dart' as http;

getRegionData(BuildContext context, id) async {
  try {
    final String lanId = Hive.box("LocalLan").get('lang_id');

    log(lanId);
    final provider = Provider.of<DataProvider>(context, listen: false);
    var response = await http.get(
        Uri.parse("$getRegionApi?country_id=$id&language_id=$lanId"),
        headers: {"device-id": provider.deviceId ?? ''});
    print(response.body);
    if (response.statusCode != 200) {
      log("Something Went Wrong8");
      return;
    }

    var jsonResponse = jsonDecode(response.body);
    log(response.body);
    log("$getRegionApi?country_id=$id&language_id=$lanId");
    if (jsonResponse['result'] == true) {
      log("jsonresult=======${jsonResponse['result'].toString()}");
      var regionInfoModel = RegionInfo.fromJson(jsonResponse);
      provider.regionInfodata(regionInfoModel);
    } else {
      provider.clearRegions();
    }
  } on Exception catch (e) {
    log("Something Went Wrong7");
    print(e);
  }
}

getStateData(BuildContext context, id) async {
  try {
    final String lanId = Hive.box("LocalLan").get('lang_id');
    final provider = Provider.of<DataProvider>(context, listen: false);
    var response = await http.get(
        Uri.parse("$getStateApi?city_id=$id&language_id=$lanId"),
        headers: {"device-id": provider.deviceId ?? ''});
    // print(response.body);
    if (response.statusCode != 200) {
      log(response.statusCode.toString());
      log("Something Went Wrong8");
      return;
    }

    var jsonResponse = jsonDecode(response.body);
    log("$getStateApi?city_id=$id&language_id=$lanId");
    log(response.body);
    if (jsonResponse['result'] == true) {
      var stateInfoModel = Stateinfo.fromJson(jsonResponse);
      provider.stateinfodata(stateInfoModel);
    } else {
      provider.clearStates();
    }
  } on Exception catch (e) {
    log("Something Went Wrong7");
    print(e);
  }
}
