import 'package:flutter/material.dart';
import 'package:frontend/screens/auth_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final primary=Color(0xfFDDD0C8); //beige
final secondary=Color.fromRGBO(50, 50, 50, 1); //dark gray
const Color sageGreen = Color(0xFF6B705C);   
const Color softSage = Color(0xFFB7B7A4);    
const Color deepForest = Color(0xFF3F4238);

void main() {
  runApp(
    const ProviderScope( 
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KanBan App',

      home: AuthPage(),
      routes: {
        "/homepage":(context)=>AuthPage()
      },
    );
  }
}


