import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/dashboard_provide.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final baseUrl="http://localhost:8000";
final storage=FlutterSecureStorage();


class AuthService {

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
      final data=jsonDecode(response.body);

      await storage.write(key: "jwt_token", value: data);
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