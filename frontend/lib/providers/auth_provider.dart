

import 'dart:async';
import 'package:frontend/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_provider.g.dart';

@riverpod
class Obsure extends _$Obsure{
  @override
  bool build()=>true;
  void onToggle()=> state=!state;
}



@riverpod
class AuthError extends _$AuthError {
  Timer? _timer;

  @override
  String? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void setError(String? message) {
    state = message;
    _timer?.cancel();

    if (message != null && message.isNotEmpty) {
      _timer = Timer(const Duration(seconds: 2), () {
        state = null;
      });
    }
  }

  void clear() {
    _timer?.cancel();
    state = null;
  }
}


@riverpod
class Selection extends _$Selection{

  @override
  
  String build()=>"LogIn";
  void setSelection(String value)=>state=value;
}

@riverpod
class Auth extends _$Auth {
  @override
  Future<bool> build() async {
    final token = await AuthService().getToken();

    if (token != null && token.isNotEmpty) {

      if (JwtDecoder.isExpired(token)) {
        return false; 
      }
      final timer = Timer.periodic(const Duration(seconds: 2), (t) async {
        final currentToken = await AuthService().getToken();
        if (currentToken == null || JwtDecoder.isExpired(currentToken)) {
          t.cancel();
          logout(); 
        }
      });

      ref.onDispose(timer.cancel);
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    await AuthService().logout();
    state = const AsyncValue.data(false);
  }
}
