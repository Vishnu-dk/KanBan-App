import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/providers/dashboard_provider.dart';
import 'package:frontend/providers/total_count_provider.dart';
import 'package:frontend/services/board_service.dart';
import 'package:frontend/widgets/chart_widget.dart';
import 'package:frontend/widgets/profile_widget.dart';



class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(kanbanTotalsProvider);
    final board=ref.watch(dashboardProvider);


    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: secondary,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        title: const Text(
          "Kanban App",
          style: TextStyle(
            color:Color(0xfFDDD0C8) ,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),

      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: sageGreen,
                          child: const Icon(Icons.person, size: 36, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

board.
when(
  loading: () => const Text("Loading..."),
  error: (_, __) => const Text("Error"),
  data: (data) => Text(
    data.user,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: secondary,
    ),
  ),
),


                            Text(
                              "Your Kanban activity overview",
                              style: TextStyle(
                                fontSize: 14,
                                color: secondary.withValues(alpha:0.65),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),      
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_rounded, color: sageGreen),
                    )
                  ],
                ),

                const SizedBox(height: 56),

                Center(
                  child: SizedBox(
                    width: 720,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final cards = [
                          ProfileStatCard(
                            title: "Boards Created",
                            value: totals.boards,
                            icon: Icons.dashboard_rounded,
                            accentColor: sageGreen,
                          ),
                          ProfileStatCard(
                            title: "Columns Created",
                            value: totals.columns,
                            icon: Icons.view_column_rounded,
                            accentColor: deepForest,
                          ),
                          ProfileStatCard(
                            title: "Tasks Created",
                            value: totals.tasks,
                            icon: Icons.task_alt_rounded,
                            accentColor: softSage,
                          ),
                        ];
                        return cards[index];
                      },
                    ),
                  ),
                ),      

                const SizedBox(height: 32),

                Divider(
                  color: secondary.withValues(alpha:0.25),
                  thickness: 1,
                ),

                const SizedBox(height: 24),

                Center(
                  child: Column(
                    children: [
                      Text(
                        "Your Task Distribution",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        height: 400,
                        child: SunburstChart(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    
          ),
        ),
      ), 
    );
  }
}


