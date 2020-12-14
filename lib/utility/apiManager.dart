import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  BuildContext context;

  ApiManager(BuildContext context) {
    this.context = context;
  }

  static Future<bool> checkInternet() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  postCall({@required String url, @required Map request}) async {
    print(url);
    print(request);
    var headers = Map<String, String>();
    headers["Accept"] = "application/json";
    http.Response response =
        await http.post(url, body: request, headers: headers);
    print(response.body);
    print(response.statusCode);
    return await json.decode(response.statusCode == 200
        ? response.body
        : handleErrors(response.body));
  }

  deleteCall({@required String url}) async {
    print(url);
    var headers = Map<String, String>();
    headers["Accept"] = "application/json";
    http.Response response = await http.delete(url, headers: headers);
    print(response.body);
    print(response.statusCode);
    return await json.decode(response.statusCode == 200
        ? response.body
        : handleErrors(response.body));
  }

  getCall(
      {@required String url, @required Map<String, dynamic> request}) async {
    print(url);
    print(request);
    var uri = Uri.parse(url);
    var headers = Map<String, String>();
    headers["Accept"] = "application/json";
    uri = uri.replace(queryParameters: request);
    http.Response response = await http.get(uri, headers: headers);
    print(response.body);
    print(response.statusCode);
    return await json.decode(response.statusCode == 200
        ? response.body
        : handleErrors(response.body));
  }

  String handleErrors(String body) {
    try {
      Map errors = json.decode(body)["errors"];
      String msg = errors.values.first
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      return "{\"error\": true, \"msg\": \"$msg\"}";
    } catch (e) {
      print(e.toString());
      return "{\"error\": true, \"msg\": \"Something went wrong\"";
    }
  }
}
