import 'dart:convert';

import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
class CardService {

  final _auth = AuthService();

  Future<Map<String, String>> _headers() async => {
    'Content-Type': 'application/json', 
    'Authorization': 'Bearer ${await _auth.getToken()}'
  };

  Future<void> addCard(String columnId, String title,String? description, String? dueDate) async {
    await http.post(Uri.parse("$baseUrl/cards"), 
      headers: await _headers(), 
      body: json.encode({"title": title, "column_id": columnId, if (description != null) "description": description,
                                  if (dueDate != null) "due_date": dueDate, }));
  }


  Future<void> updateCard(String id, {String? title, String? description, String? dueDate}) async {
    final headers = await _headers();
    headers['Content-Type'] = 'application/json';

    await http.patch(Uri.parse("$baseUrl/cards/$id"),headers: headers,
                                body: json.encode({
                                  if (title != null) "title": title,
                                  if (description != null) "description": description,
                                  if (dueDate != null) "due_date": dueDate, 
                                }),
    );
  }

  Future<void> deleteCard(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/cards/$id"),headers: await _headers(),);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete card: ${response.body}");
    }
  }


  Future<List<dynamic>> getCards(String columnId) async {
    final response = await http.get(Uri.parse("$baseUrl/cards?column_id=$columnId"),headers: await _headers());

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception("Failed to load cards");
    }
  }
}
