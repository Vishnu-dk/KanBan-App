import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/dashboard_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final baseUrl="http://localhost:8000";
final storage=FlutterSecureStorage();


class AuthService {

    Future<Map<String, String>> getHeaders() async {
    String? token = await AuthService().getToken(); 
  if (token?.isEmpty ?? true) {
    throw Exception('Unauthorized'); 
  }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> signUp (String email ,String password)async{
    final response= await http.post(Uri.parse('${baseUrl}/auth/register'),headers: {"Content-Type":"application/json"},
                                        body: jsonEncode({"email":email ,
                                                          "password":password,
                                                          }
                                                        ));
    if (response.statusCode==200){
      return "User Created";
    }else if(response.statusCode==402){
      return "User Already Exists";
    }else{
      return "Authentication Failed";
    }
  }



    Future<bool> logIn (WidgetRef ref, String email ,String password)async{
            await storage.delete(key: 'jwt_token');
      
    final response= await http.post(Uri.parse('${baseUrl}/auth/login'),headers: {"Content-Type":"application/json"},
                                        body: jsonEncode({"email":email ,
                                                          "password":password,
                                                          }
                                                        ));
    
    if (response.statusCode==200){
      ref.invalidate(dashboardProvider);
    final Map<String, dynamic> data = jsonDecode(response.body);
final String token = data['access_token']; 

      await storage.write(key: "jwt_token", value: token);
          ref.invalidate(authProvider); 
      return true;
    }else{
      return false;
    }
  }
    Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

}