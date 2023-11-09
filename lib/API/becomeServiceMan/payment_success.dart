// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:social_media_services/API/endpoint.dart';
import 'package:social_media_services/model/payment_success.dart';
import 'package:social_media_services/providers/data_provider.dart';
import 'package:http/http.dart' as http;
import 'package:thawani_payment/class/status.dart';
import 'package:async/async.dart';

getPayFortPaymentSuccess(BuildContext context, id, status) async {
  log("Payment Success API calling");
  print(id);
  final provider = Provider.of<DataProvider>(context, listen: false);
  final apiToken = Hive.box("token").get('api_token');

  try {
    var response = await http.post(
        Uri.parse('$payFortpaymentSuccess?status=$status&order_id=$id'),
        //   Uri.parse(
        // '$paymentSuccess?status=$status&order_id=$id&response_code=$resCode&response_message=$resMessage&authorization_code=$authCode&fort_id=$fortId'),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log(response.body);
      print(jsonResponse);

      final paymentData = PaymentSuccessModel.fromJson(jsonResponse);
      provider.getPaymentSuccessData(paymentData);
    } else {
      log(
        "// Went Wrong2",
      );
    }
  } on Exception catch (_) {
    log(
      "// Went Wrong1",
    );
  }
}

getThawaniPaymentSuccess(
    BuildContext context, id, status, StatusClass v) async {
  final provider = Provider.of<DataProvider>(context, listen: false);
  final apiToken = Hive.box("token").get('api_token');
  String? clientId;
  String? invoiceId;
  v.data?.forEach((key, value) {
    if (key == 'client_reference_id') {
      clientId = value;
      print(clientId);
    }
    if (key == 'invoice') {
      invoiceId = value;
      print(invoiceId);
    }
  });
  if (provider.customerChildSer!.documents!.isEmpty) {
    try {
      var response = await http.post(
          Uri.parse(
              '$thawaniPaymentSuccess?order_id=$clientId&language_id=3&client_reference_id=$clientId&invoice_id=$invoiceId&payment_gateway=thawani'),
          //   Uri.parse(
          // '$paymentSuccess?status=$status&order_id=$id&response_code=$resCode&response_message=$resMessage&authorization_code=$authCode&fort_id=$fortId'),
          headers: {
            "device-id": provider.deviceId ?? '',
            "api-token": apiToken
          });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log(response.body);
        print(jsonResponse);

        final paymentData = PaymentSuccessModel.fromJson(jsonResponse);
        provider.getPaymentSuccessData(paymentData);
      } else {
        log(
          "// Went Wrong2",
        );
      }
    } on Exception catch (_) {
      log(
        "// Went Wrong1",
      );
    }
  } else {
    var uri = Uri.parse(
        '$thawaniPaymentSuccess?order_id=$clientId&language_id=3&client_reference_id=$clientId&invoice_id=$invoiceId&payment_gateway=thawani');
    try {
      var request = http.MultipartRequest(
        "POST",
        uri,
      );

      print(uri);

      // List<MultipartFile> multiPart = [];

      var stream =
          http.ByteStream(DelegatingStream(provider.pickedFile!.openRead()));
      var length = await provider.pickedFile!.length();
      final apiToken = Hive.box("token").get('api_token');

      request.headers.addAll(
          {"device-id": provider.deviceId ?? '', "api-token": apiToken});
      var multipartFile = http.MultipartFile(
        'files',
        stream,
        length,
        filename: (provider.pickedFile!.path),
      );

      request.files.add(multipartFile);

      // "content-type": "multipart/form-data"

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log(response.body);
        print(jsonResponse);
        final paymentData = PaymentSuccessModel.fromJson(jsonResponse);
        provider.getPaymentSuccessData(paymentData);
      } else {
        log(
          "// Went Wrong2",
        );
      }
    } on Exception catch (_) {}
  }
}

getThawaniFailed(BuildContext context, StatusClass v) async {
  final provider = Provider.of<DataProvider>(context, listen: false);
  final apiToken = Hive.box("token").get('api_token');
  try {
    String? clientId;

    v.data?.forEach((key, value) {
      if (key == 'client_reference_id') {
        clientId = value;
        print(clientId);
      }
    });
    var response = await http.post(
        Uri.parse(
            '$thawaniPaymentfailed?order_id=$clientId&payment_gateway=thawani'),
        headers: {"device-id": provider.deviceId ?? '', "api-token": apiToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      log(response.body);
      print(jsonResponse);
    } else {
      log(
        "// Went Wrong2",
      );
    }
  } on Exception catch (_) {
    log(
      "// Went Wrong1",
    );
  }
}
