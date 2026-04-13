import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/column_widgets.dart';

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
                return ColumnWidgets().buildBoardContent(context, ref, boardAsync.value!, board);
              }

              return Center(child: Text("Authentication Error", style: TextStyle(color: secondary)));
            },
            data: (currentBoard) => ColumnWidgets().buildBoardContent(context, ref, currentBoard, board),
          ),
        ),
      ),
    );
  }
 
}
