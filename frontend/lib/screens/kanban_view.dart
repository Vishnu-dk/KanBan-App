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
            skipLoadingOnRefresh: true, 
            loading: () => const Center(child: CircularProgressIndicator(color: sageGreen)),
            error: (err, stack) {
            
              if (boardAsync.hasValue) {
                return _buildBoardContent(context, ref, boardAsync.value!, board);
              }

              return Center(child: Text("Authentication Error", style: TextStyle(color: secondary)));
            },
            data: (currentBoard) => _buildBoardContent(context, ref, currentBoard, board),
          ),
        ),
      ),
    );
  }
  Widget _buildBoardContent(BuildContext context, WidgetRef ref, Board currentBoard, Board board) {
    ref.listen<AsyncValue<Board>>(
      kanbanProvider(board),
      (previous, next) {
        if (next is AsyncError && !next.isLoading) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.error.toString(), 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(255, 250, 54, 40), 
              behavior: SnackBarBehavior.floating, 
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
    );
    final horizontalController = ScrollController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(board.name, style: TextStyle(color: secondary, fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => CommonWidgets().showDialogs(
                  context, 
                  "New Column",
                  "Add Column for assigning tasks",
                  "Create", 
                  (val) => ref.read(kanbanProvider(board).notifier).addColumn(val)
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Create Column"),
                style: ElevatedButton.styleFrom(backgroundColor: sageGreen, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
        Divider(color: secondary.withValues(alpha: 0.1), indent: 24, endIndent: 24),
        if (currentBoard.columnNames.isEmpty)
          const Expanded(
            child: Center(
              child: Text("No Columns found. Create one!"),
            ),
          )
        else
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
                  children: currentBoard.columnNames.map((col) {
                    return SizedBox(
                      width: 296,
                      child: KanbanViewWidget().buildKanbanColumn(context, ref, col, board),
                    );
                  }).toList(), 
                ),
              ),
            ),
          ),     
      ],
    );
  }

}
