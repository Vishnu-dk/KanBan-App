import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/modals/board.dart';
import 'package:frontend/services/auth_service.dart'; 

class BoardService {

  Future<List<Board>> getBoards() async {  
    final response = await http.get(Uri.parse("$baseUrl/boards"),headers: await AuthService().getHeaders(),);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          json.decode(response.body);

      final List boardsJson = body['board'];

      return boardsJson
          .map((json) => Board.fromJson(json))
          .toList();
    } else {
      throw Exception(
        json.decode(response.body)['detail'] ?? "Failed to load boards"
      );
    }
  }
  Future<String> getUser() async {
    final response = await http.get(Uri.parse("$baseUrl/boards"),headers: await AuthService().getHeaders(),);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          json.decode(response.body);

      final String user = body['user'];

      return user;
    } else {
      throw Exception(
        json.decode(response.body)['detail'] ?? "Failed to load username"
      );
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
