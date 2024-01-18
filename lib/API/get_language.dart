import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/model/get_language.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:http/http.dart' as http;

getLanguageData(BuildContext context) async {
  try {
    final provider = Provider.of<DataProvider>(context, listen: false);
    var response = await http.get(Uri.parse(languagesApi),
        headers: {"device-id": provider.deviceId ?? ''});
    // print(response.body);
    if (response.statusCode != 200) {
      log("Something Went Wrong8");
      return;
    }

    var jsonResponse = jsonDecode(response.body);
    var languageModel = LanguageModel.fromJson(jsonResponse);
    provider.languageModelData(languageModel);
  } on Exception catch (e) {
    log("Something Went Wrong7");
    print(e);
  }
}

updateuserlanguages(BuildContext context) async {
  final String lanId = Hive.box("LocalLan").get('lang_id');
  final apiToken = Hive.box("token").get('api_token');
  final provider = Provider.of<DataProvider>(context, listen: false);
  try {
    var response = await http.post(Uri.parse('$updateuserlanguage$lanId'),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log("language=============${response.body}");
      log("language=============${jsonResponse}");

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
