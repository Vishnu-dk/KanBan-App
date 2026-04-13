import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/modals/board.dart';
import 'package:frontend/services/auth_service.dart'; 

class BoardService {

  Future<List<Board>> getBoards( ) async {
    final response = await http.get(Uri.parse("$baseUrl/boards"),headers: await AuthService().getHeaders(),);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Board.fromJson(json)).toList();
    }
     else {
      throw Exception(json.decode(response.body)['detail'] ?? "Failed to load boards");
    }
  }

  Future<String> addBoard( String boardName) async {
    final response = await http.post(Uri.parse("$baseUrl/boards"),headers: await AuthService().getHeaders(),body: json.encode({"name": boardName}),);

    if (response.statusCode == 200) {
      return "Board Added";
    } else {
      final errorData = json.decode(response.body);
      throw errorData['detail'] ?? "Failed to add board";
    }
  }

  Future<bool> deleteBoard( String boardId) async {
    final response = await http.delete(Uri.parse("$baseUrl/boards/$boardId"),headers: await AuthService().getHeaders(),);

    return response.statusCode == 200;
  }

}
