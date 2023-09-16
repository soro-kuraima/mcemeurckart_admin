import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class UserManager {
  static const String baseUrl =
      'https://sea-turtle-app-dw7mj.ondigitalocean.app';

  static Future<List<dynamic>> getAuthRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/get-auth-requests'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load auth requests');
    }
  }

  static Future<void> approveUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/approve-auth-request')
        .replace(queryParameters: {'id': '$id'}));

    if (response.statusCode != 200) {
      log(response.body.toString());
      throw Exception('Failed to approve user');
    }
  }

  static Future<void> rejectUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reject-auth-request')
        .replace(queryParameters: {'id': '$id'}));

    if (response.statusCode != 200) {
      log(response.body.toString());
      throw Exception('Failed to reject user');
    }
  }
}
