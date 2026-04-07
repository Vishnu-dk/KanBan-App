import 'package:flutter_riverpod/legacy.dart';

final obscureProvider = StateProvider<bool>((ref) => true);
final authErrorProvider = StateProvider<String?>((ref) => null);
final selectionProvider=StateProvider<String>((ref)=>"LogIn");
