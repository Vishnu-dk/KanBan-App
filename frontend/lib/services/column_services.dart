import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/services/auth_service.dart';

class ColumnService {

  Future<List<dynamic>> getColumns(String boardId) async {
    final response = await http.get(Uri.parse("$baseUrl/columns?board_id=$boardId"), headers: await AuthService().getHeaders());

    if(response.statusCode==200){
      return json.decode(response.body);
    }else{
      throw Exception("Failed to load columns");
    }
  }

  Future<void> addColumn(String boardId, String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/columns"),
      headers: await AuthService().getHeaders(),
      body: json.encode({"name": name, "board_id": boardId}),
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw errorData['detail'] ?? "Failed to add column";
    }
  }

  Future<void> updateColumn(String id, {String? name, int? position}) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/columns/$id"),
      headers: await AuthService().getHeaders(),
      body: json.encode({
        if (name != null) "name": name,
        if (position != null) "position": position,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw errorData['detail'] ?? "Failed to update column";
    }
  }

  Future<void> deleteColumn(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/columns/$id"),
      headers: await AuthService().getHeaders(),
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw errorData['detail'] ?? "Failed to delete column";
    }
  }

}
