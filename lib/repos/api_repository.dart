import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ApiRepository {
  final storage = new FlutterSecureStorage();
  final baseUrl = "https://turing-api.sothyrith.com/api/admin";

  Future<Map<String, String>> getTokenHeader() async {
    String token = await _getLocalToken();
    return {'Authorization': "$token", "Accept": "application/json"};
  }

  Future<String> _getLocalToken() async {
    return await storage.read(key: "token");
  }
}
