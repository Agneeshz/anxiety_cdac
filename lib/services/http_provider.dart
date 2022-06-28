import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anxiety_cdac/constant/api.dart';

class HttpProvider {
  dynamic post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse(url + endpoint);
    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    String jsonBody = json.encode(body);
    final response = await http.post(uri,
        headers: headers, body: jsonBody, encoding: encoding);

    return response.body;
  }
}
