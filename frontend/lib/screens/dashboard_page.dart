import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/dashboard_provide.dart';
import 'package:frontend/screens/auth_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/common_widgets.dart';
import 'package:frontend/widgets/dashboard_widgets.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardsAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: secondary,
        elevation: 0,
        title: Text("KanBan App", style: TextStyle(color: primary, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                actions: [
          PopupMenuButton<String>(

            color: primary, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            offset: const Offset(0, 50), 

            icon: CircleAvatar(
              radius: 18,
              backgroundColor: sageGreen, 
              child: Icon(Icons.person, color: primary, size: 20),
            ),

            onSelected: (value) async { 
             if (value == 'logout') {

                 await AuthService().logout(); 
                 if (!context.mounted) return;
                 Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) => const AuthPage()),
                   (route) => false, 
                 );

             }
            },

            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.account_circle_outlined, color: secondary, size: 20),
                    const SizedBox(width: 10),
                    Text("Profile", style: TextStyle(color: secondary)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16), 
        ],

      ),
      body: Container(
        color: secondary,
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Boards", style: TextStyle(color: secondary, fontSize: 28, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(

                      onPressed: () => CommonWidgets().showDialogs(context, "Create Board","Give your project a name to get started.","Create", (val) =>ref.read(dashboardProvider.notifier).createBoard(val)),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Create Board"),
                      style: ElevatedButton.styleFrom(backgroundColor: sageGreen, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
              Divider(color: secondary.withValues(alpha:0.2), thickness: 1, indent: 24, endIndent: 24),
              
              Expanded(
                child: boardsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) {
                    if (err.toString().contains("404")) {
                      return const Center(child: Text("No boards found. Create one!"));
                    }
                    return const Center(child: Text("Authentication Error"));
                  },
                  data: (myBoards) {
                    if (myBoards.isEmpty) {
                      return const Center(child: Text("No boards found. Create one!"));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: myBoards.length,
                      itemBuilder: (context, index) => boardCard(context, myBoards[index],ref),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}