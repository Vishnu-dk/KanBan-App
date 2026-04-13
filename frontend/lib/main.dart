import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/auth_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/dashboard_page.dart';



final primary=Color(0xfFDDD0C8); //beige
final secondary=Color.fromRGBO(50, 50, 50, 1); //dark gray
const Color sageGreen = Color(0xFF6B705C);   
const Color softSage = Color(0xFFB7B7A4);    
const Color deepForest = Color(0xFF3F4238);
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 

void main() {
  runApp(
    const ProviderScope( 
      child: MyApp(),
    ),
  );
}

// main.dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override


  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    ref.listen<AsyncValue<bool>>(authProvider, (previous, next) {

        if (previous?.value == true && next.value == false) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text("Session Expired. Please log in again."),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthPage()),
            (route) => false,
          );
        }
    });
    return MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'KanBan App',

      home: authState.when(
        data: (isLoggedIn) => isLoggedIn ? const DashboardPage() : const AuthPage(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => const AuthPage(),
      ),
    );
  }
}


