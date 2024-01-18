import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/components/routes_manager.dart';
import 'package:social_media_services/model/serviceManLIst.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:social_media_services/providers/servicer_provider.dart';
import 'package:social_media_services/screens/serviceman/servicer.dart';

getServiceMan(BuildContext context, id, homeservice) async {
  //  final otpProvider = Provider.of<OTPProvider>(context, listen: false);
  final provider = Provider.of<DataProvider>(context, listen: false);
  final userDetails = provider.viewProfileModel?.userdetails;
  final String lanId = Hive.box("LocalLan").get('lang_id');
  // provider.subServicesModel = null;
  String? apiToken = Hive.box("token").get('api_token');
  // if (apiToken == null) return;
  if (apiToken == null) {
    apiToken = '';
  }
  try {
    var response = await http.post(
        Uri.parse(
            '$servicemanList?service_id=$id&page=1&latitude=${userDetails?.latitude ?? provider.explorerLat}&longitude=${userDetails?.longitude ?? provider.explorerLong}&language_id=${lanId}'),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log(response.body);
      print("Navigation active");
      navToServiceMan(context, id, homeservice);
      if (jsonResponse['result'] == false) {
        await Hive.box("token").clear();

        return;
      }

      final serviceManListData = ServiceManListModel.fromJson(jsonResponse);
      provider.getServiceManData(serviceManListData);
      // if (provider.serviceManListModel?.serviceman?.isEmpty ?? false) {
      //   showAnimatedSnackBar(context, "No ServiceMan Available");
      // }
    } else {
      // print(response.statusCode);
      // print(response.body);
      // print('Something went wrong');
    }
  } on Exception catch (_) {}
}

searchServiceMan(
    BuildContext context, id, countryId, state, region, name, transport) async {
  final String lanId = Hive.box("LocalLan").get('lang_id');
  final servicerProvider =
      Provider.of<ServicerProvider>(context, listen: false);
  final provider = Provider.of<DataProvider>(context, listen: false);
  final userDetails = provider.viewProfileModel?.userdetails;
  // provider.subServicesModel = null;
  String? apiToken = Hive.box("token").get('api_token');
  // for explore apiToken want to be null so cant return it
  // if (apiToken == null) return;
  if (apiToken == null) {
    apiToken = '';
  }
  try {
    final url =
        '$servicemanList?service_id=$id&page=1&latitude=${servicerProvider.servicerLatitude ?? userDetails?.latitude ?? provider.explorerLat}&longitude=${servicerProvider.servicerLatitude ?? userDetails?.longitude ?? provider.explorerLong}&sel_country_id=${countryId ?? ''}&sel_state=${state ?? ''}&sel_region=${region ?? ''}&sel_name=${name ?? ''}&sel_transport=${transport ?? ''}&language_id=${lanId}';
    log(url);
    var response = await http.post(Uri.parse(url),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log(response.body);

      final serviceManListData = ServiceManListModel.fromJson(jsonResponse);

      provider.getServiceManData(serviceManListData);
      // if (provider.serviceManListModel?.serviceman?.isEmpty ?? false) {
      //   showAnimatedSnackBar(context, "No ServiceMan Available");
      // }
    } else {
      // print(response.statusCode);
      // print(response.body);
      // print('Something went wrong');
    }
  } on Exception catch (_) {}
}

navToServiceMan(context, id, homeservice) {
  Navigator.pushReplacement(
      context,
      FadePageRoute(
          page: ServicerPage(
        id: id,
        homeservice: homeservice,
      )));
}
