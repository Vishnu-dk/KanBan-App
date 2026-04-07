import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/text_field_auth.dart';
class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {


    final isObscured = ref.watch(obscureProvider);

    void handleSignUp()async{
      String success=await AuthService().signUp(emailController.text,passwordController.text);
      if(success=="User Created"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User Created"))
        );
        Navigator.pushNamed(context, "/hoempage");
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success))
        );
      }
    }
    return Container(
      padding:  EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F2), 
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
            "SignUp", 
            style: TextStyle(
              color: secondary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30,),
          buildTextField("Email", Icons.email,controller:emailController),
          const SizedBox(height: 16),
          buildTextField("Password",Icons.lock,controller: passwordController, isObscure: isObscured,onToggle: () {
                ref.read(obscureProvider.notifier).state=!isObscured;
              },),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondary,
              foregroundColor: primary,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: handleSignUp,
            child: const Text("Start Finishing"),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
          ),
        ],
      ),
    );
  }
}

