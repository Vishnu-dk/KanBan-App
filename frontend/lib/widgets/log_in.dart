import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/dashboard_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/text_field_auth.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
    final  emailController=TextEditingController();
    final  passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    final isObscured = ref.watch(obsureProvider);
    final errorMessage=ref.watch(authErrorProvider);



    void handleLogin()async{
      bool success=await AuthService().logIn(ref,emailController.text, passwordController.text);
      if(success){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logged IN !!"))
        );
        Navigator.pushAndRemoveUntil(
        context,
       MaterialPageRoute(builder: (context) => const DashboardPage()),
      (route) => false, // This removes all previous routes
    );
      }else{
        ref.read(authErrorProvider.notifier).setError("Invalid UserName/Password");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid UserName / Password"))
        );
      }
    }


    return Container(
      padding:  EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F2), // Soft White Container
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "LogIn", // or "Sign Up"
            style: TextStyle(
              color: secondary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30,),
          buildTextField("Email", Icons.email,controller:emailController,errorText: errorMessage),
          const SizedBox(height: 16),
          buildTextField("Password",Icons.lock,controller:passwordController,errorText: errorMessage, isObscure: isObscured,  onToggle: () {
    // Call the toggle method we defined in the Notifier
    ref.read(obsureProvider.notifier).onToggle();
  },),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondary,
              foregroundColor: primary,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: handleLogin,
            child: const Text("Continue Finishing"),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: const Text(
              "New User ? SignUp",
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
          ),
        ],
      ),
    );
  }
}