

import 'dart:async';
import 'package:frontend/providers/dashboard_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_provider.g.dart';

@riverpod
class Obsure extends _$Obsure{  //here this is to make the eye in the passoword shown or not shown
  @override
  bool build()=>true;
  void onToggle()=> state=!state;
}



@riverpod
class AuthError extends _$AuthError {   //it is output  show the error in the textfield
  Timer? _timer;  //variable that hold the timer

  @override
  String? build() {    //ensure the time is disposed to prevent memory leak
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void setError(String? message) {    //sets an error messsage
    state = message;
    _timer?.cancel();         //cancel any timer before new is created

    if (message != null && message.isNotEmpty) {
      _timer = Timer(const Duration(seconds: 2), () {
        state = null;          //clear timer after 2 seconds
      });
    }
  }

  void clear() {           //clear error message and cancel timer
    _timer?.cancel();
    state = null;
  }
}


@riverpod
class Selection extends _$Selection{  //this is for the authpage that it has login and signup in a single page to switch that

  @override
  
  String build()=>"LogIn";
  void setSelection(String value)=>state=value;
}

@riverpod
class Auth extends _$Auth {    // to auto logout and check if th etocken is expired
  @override
  Future<bool> build() async {
    final token = await AuthService().getToken();  //get the tocken value

    if (token != null && token.isNotEmpty) {   //check if it is none

      if (JwtDecoder.isExpired(token)) {    //if tocken is expire checked using jwtdecoder return false
        return false; 
      }
      final timer = Timer.periodic(const Duration(minutes: 1), (t) async {   //timer to check or fetch the api from back end to know if the tocken is expired
        final currentToken = await AuthService().getToken();
        if (currentToken == null || JwtDecoder.isExpired(currentToken)) {
          t.cancel();                //timer cancell
          logout();                   //logout that is delete the tocken from the secure storage
        }
      });

      ref.onDispose(timer.cancel);
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {

    await AuthService().logout();         //call logout function
    state = const AsyncData(false);
      ref.invalidate(dashboardProvider);
  }
}
