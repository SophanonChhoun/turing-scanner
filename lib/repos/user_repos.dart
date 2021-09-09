import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_example/models/user.dart';
import 'package:qr_code_scanner_example/repos/api_repository.dart';

class UserRepo extends ApiRepository {
  Future<User> readDataUser() async {
    http.Response response =
        await http.get("$baseUrl/profile", headers: await getTokenHeader());

    if (response.statusCode == 200) {
      String body = response.body;
      return compute(userFromMap, body);
    } else {
      throw Exception("Error while reading data");
    }
  }

  Future checkIn(code) async {
    http.Response response = await http.patch("$baseUrl/tickets/$code",
        headers: await getTokenHeader());
    var parsedJson = json.decode(response.body);
    return parsedJson;
  }

  Future<bool> updateUser(email, name) async {
    http.Response response = await http.put("$baseUrl/profile",
        headers: await getTokenHeader(), body: {"name": name, "email": email});
    if (response.statusCode == 200) {
      print(response.statusCode);
      return true;
    } else {
      throw Exception("Error while reading data");
    }
  }

  Future<bool> updateUserPassword(password, oldPassword) async {
    http.Response response = await http
        .patch("$baseUrl/profile", headers: await getTokenHeader(), body: {
      "password": password,
      "oldPassword": oldPassword,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
