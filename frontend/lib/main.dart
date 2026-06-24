import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/auth_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/dashboard_page.dart';


//color pallete
const Color primary=Color(0xfFDDD0C8); 
const Color secondary=Color.fromRGBO(50, 50, 50, 1);
const Color sageGreen = Color(0xFF6B705C);   
const Color softSage = Color(0xFFB7B7A4);    
const Color deepForest = Color(0xFF3F4238);

//global key for scaffold messenger & navigator  here no need of build context
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 

void main() {
  runApp(
    const ProviderScope(   //store state of all provider
      child: MyApp(),
    ),
  );
}

// main.dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override


  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider); //to see whether user is logged in or out
      ref.listen<AsyncValue<bool>>(authProvider, (previous, next) {  //here ref.listen watches the authstate to trigger for changes

        if (previous?.value == true && next.value == false) {   // that is a user logged in and automatically it logged out then this message should be shown.
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text("Session Expired. Please log in again."),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );

        }
      });
    return MaterialApp(

      theme: ThemeData(
        canvasColor: Colors.transparent,
      ),
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'KanBan App',
    
      home: authState.when(
        data: (isLoggedIn) => isLoggedIn ? const DashboardPage() : const AuthPage(), //check the output of the provider  and respond according o the bool value
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => const AuthPage(),
      ),
    );
  }


}


