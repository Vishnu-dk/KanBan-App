import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/services/auth_service.dart';

class ColumnService {
  final _auth = AuthService();

  Future<Map<String, String>> _headers() async {
    final token = await _auth.getToken();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<dynamic>> getColumns(String boardId) async {
    final response = await http.get(Uri.parse("$baseUrl/columns?board_id=$boardId"), headers: await _headers());
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }


  Future<void> addColumn(String boardId, String name) async {
    await http.post(Uri.parse("$baseUrl/columns"), 
      headers: await _headers(), 
      body: json.encode({"name": name, "board_id": boardId}));
  }


  Future<void> updateColumn(String id, {String? name, int? position}) async {
      final response = await http.patch(
    Uri.parse("$baseUrl/columns/$id"), 
    headers: await _headers(), 
    body: json.encode({
      if (name != null) "name": name,
      if (position != null) "position": position,
    }),
  );
    if (response.statusCode == 422) {
}
  }


  Future<void> deleteColumn(String id) async {
    await http.delete(Uri.parse("$baseUrl/columns/$id"), headers: await _headers());
  }
}
