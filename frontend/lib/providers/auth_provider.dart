// import 'package:flutter_riverpod/legacy.dart';

// final obscureProvider = StateProvider<bool>((ref) => true);
// final authErrorProvider = StateProvider<String?>((ref) => null);
// final selectionProvider=StateProvider<String>((ref)=>"LogIn");



import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'auth_provider.g.dart';

@riverpod
class Obsure extends _$Obsure{
  @override
  bool build()=>true;
  void onToggle()=> state=!state;
}


@riverpod
class AuthError extends _$AuthError{

  @override
  String?build()=>null;

  void setError(String?message)=>state=message;
  void clear()=>state=null;

}


@riverpod
class Selection extends _$Selection{

  @override
  
  String build()=>"LogIn";
  void setSelection(String value)=>state=value;
}