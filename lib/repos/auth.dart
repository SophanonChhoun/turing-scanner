import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_example/models/auth_reponse.dart';

class AuthRepo {
  final baseUrl = "https://turing-api.sothyrith.com/api/admin";
  final header = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  Future<bool> signIn({String email, String password}) async {
    http.Response response = await http.post("$baseUrl/login",
        body: jsonEncode({'email': email, 'password': password}),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
    if (response.statusCode == 200) {
      AuthResponse authResponse =
          await compute(authResponseFromMap, response.body);
      await _saveCredentials(authResponse);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp({String name, String email, String password}) async {
    http.Response response = await http.post("$baseUrl/register",
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: header);

    if (response.statusCode == 200) {
      print("Sign up successful. Computing response...");
      AuthResponse authResponse =
          await compute(authResponseFromMap, response.body);
      print("Saving credentials...");
      await _saveCredentials(authResponse);
      print("Saving credentials done");
      return true;
    } else {
      print("Sign up failed");
      print(response.body);
      return false;
    }
  }

  Future<void> signOut() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'token');
    print("Sign out done");
  }

  Future<bool> verifyExistingCredentials() async {
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    if (token == null) {
      return false;
    }

    return true;
  }

  Future<void> _saveCredentials(AuthResponse response) async {
    final storage = new FlutterSecureStorage();
    print("Saving token...");
    storage.write(key: 'token', value: response.token).then((value) {
      print("Token saved");
    });
  }
}
