import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/common_widgets.dart';
import 'package:frontend/widgets/kanban_view_widget.dart';

class KanbanView extends ConsumerWidget {
  final Board board;
  const KanbanView({super.key, required this.board});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardAsync = ref.watch(kanbanProvider(board));
    final horizontalController = ScrollController();

    return Scaffold(
      backgroundColor: secondary,  
      appBar: AppBar(
        backgroundColor: secondary,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        title: Text("KanBan App", 
          style: TextStyle(color: primary, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),  
        child: Container(
          decoration: BoxDecoration(
            color: primary,  
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: boardAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text("Error: $err", style: TextStyle(color: secondary))),
            data: (currentBoard) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child:Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(board.name, style: TextStyle(color: secondary, fontSize: 28, fontWeight: FontWeight.bold)),
                          ElevatedButton.icon(
                            onPressed: () => CommonWidgets().showDialogs(context, "New Column","Add Column for assigning tasks","Create", (val) => ref.read(kanbanProvider(board).notifier).addColumn(val)),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Create Column"),
                            style: ElevatedButton.styleFrom(backgroundColor: sageGreen, foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: secondary.withValues(alpha: 0.1), indent: 24, endIndent: 24),
                  
                  Expanded(
                    child: Scrollbar(
                      controller: horizontalController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: horizontalController,
                        scrollDirection: Axis.horizontal, 
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Row(
                        
                          crossAxisAlignment: CrossAxisAlignment.stretch, 
                          children: [
                            ...currentBoard.columnNames.map((col) => KanbanViewWidget().buildKanbanColumn(context, ref, col,board)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
