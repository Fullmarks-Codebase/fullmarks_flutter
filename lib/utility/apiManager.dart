import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullmarks/utility/Utiity.dart';
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
    if (Utility.getCustomer() != null) {
      headers["Authorization"] = Utility.getCustomer().token;
    }
    print(headers);
    http.Response response =
        await http.post(url, body: request, headers: headers);
    print(response.body);
    print(response.statusCode);
    return await json.decode(response.body);
  }

  deleteCall({@required String url}) async {
    print(url);
    var headers = Map<String, String>();
    headers["Accept"] = "application/json";
    if (Utility.getCustomer() != null) {
      headers["Authorization"] = Utility.getCustomer().token;
    }
    print(headers);
    http.Response response = await http.delete(url, headers: headers);
    print(response.body);
    print(response.statusCode);
    return await json.decode(response.body);
  }

  getCall(
      {@required String url, @required Map<String, dynamic> request}) async {
    print(url);
    print(request);
    var uri = Uri.parse(url);
    var headers = Map<String, String>();
    headers["Accept"] = "application/json";
    uri = uri.replace(queryParameters: request);
    if (Utility.getCustomer() != null) {
      headers["Authorization"] = Utility.getCustomer().token;
    }
    print(headers);
    http.Response response = await http.get(uri, headers: headers);
    print(response.body);
    print(response.statusCode);
    return await json.decode(response.body);
  }
}
