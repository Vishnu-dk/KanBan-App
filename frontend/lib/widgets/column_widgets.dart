
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/card_widgets.dart';
import 'package:frontend/widgets/column_header.dart';
import 'package:frontend/widgets/common_widgets.dart';

class ColumnWidgets {

  Widget buildBoardContent(BuildContext context, WidgetRef ref, Board currentBoard, Board board) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: horizontalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: currentBoard.columnNames.asMap().entries.map((entry) {
                          final index = entry.key;
                          final col = entry.value;

                          return DragTarget<KanbanColumn>(
                            onWillAcceptWithDetails: (details) => details.data.id != col.id,
                            onAcceptWithDetails: (details) {
                              ref.read(kanbanProvider(board).notifier).moveColumn(details.data, index);
                            },
                            builder: (context, candidateData, _) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: candidateData.isNotEmpty 
                                      ? sageGreen.withValues(alpha: 0.2) 
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                  
                                child: SizedBox(
                                  width: 296,
                                  child: buildKanbanColumn(context, ref, col, board,isFeedback: true),
                                ),
                                  
                                
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
  
  Widget buildKanbanColumnPreview(KanbanColumn column) {
  return Container(
    width: 280,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      color: softSage.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: deepForest.withOpacity(0.1),
        width: 1.5,
      ),
      boxShadow: const [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black26,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header preview
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            column.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: deepForest,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget buildKanbanColumn(BuildContext context, WidgetRef ref, KanbanColumn column,Board board,{bool isFeedback = false}) {
    return Container(
    key: ValueKey(column.id), 
    width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: softSage.withValues(alpha: 0.15),  
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: deepForest.withValues(alpha: 0.05), width: 1.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),

            child: KanbanColumnHeader(
              column: column,
              board: board,
              ref: ref,
            ),

          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: column.tasks.length + 1, 
                itemBuilder: (context, index) {
                
                 if (index == column.tasks.length) {
                   return _buildDropZone(ref,index,column,board, isLast: true);
                 }

                 return Column(
                   children: [
                     _buildDropZone(ref,index,column,board), 
                     _buildDraggableTaskCard(context, ref, column, board, column.tasks[index], index),
                   ],
                 );
                },
              )
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton.icon(
              onPressed: () => CardWidgets().addTaskDialog(context, ref, board, column),
              icon: const Icon(Icons.add_circle_outline, size: 20, color: sageGreen),
              label: const Text("Add Task", 
                style: TextStyle(color: deepForest, fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: primary, 
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone(WidgetRef ref, int index,KanbanColumn column,Board board, {bool isLast = false}) {
    return DragTarget<KanbanCard>(
      onWillAcceptWithDetails: (details) {
        if (index < column.tasks.length) {
          return details.data.id != column.tasks[index].id;
        }
        return true;
      },
      onAcceptWithDetails: (details) {
        int adjustedIndex = index;
        if (details.data.columnId == column.id && index > column.tasks.indexOf(details.data)) {
          adjustedIndex = index - 1; 
        }
        ref.read(kanbanProvider(board).notifier).moveTask(
          details.data,
          newPosition: adjustedIndex,
          toColumnId: column.id,
        );
      },
      builder: (context, candidateData, _) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isHovered ? 60: (isLast ? 60 : 10), 
          margin: EdgeInsets.symmetric(vertical: isHovered ? 12 : 0),
          decoration: BoxDecoration(
            color: isHovered ? sageGreen.withValues(alpha:0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isHovered 
              ? Border.all(color: sageGreen.withValues(alpha:0.5), width: 1.5) 
              : null,
          ),
          child: isHovered 
            ? const Center(child: Icon(Icons.arrow_downward_rounded, color: sageGreen))
            : const SizedBox.expand(),
        );
      },
    );
  }

  Widget _buildDraggableTaskCard(BuildContext context, WidgetRef ref, KanbanColumn column, Board board, KanbanCard task, int index) {
    return DragTarget<KanbanCard>(
      onAcceptWithDetails: (details) {
        if (details.data.id == task.id) return;
        ref.read(kanbanProvider(board).notifier).moveTask(details.data,newPosition: index,toColumnId: column.id, );
      },
      builder: (context, candidateData, _) {
        return Draggable<KanbanCard>(
          data: task, 
          feedback: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            color: sageGreen,
            child: SizedBox(
              width: 250,
              height: 60,
              child: CardWidgets().taskCard(context, ref, board, task),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.2,
            child: CardWidgets().taskCard(context, ref, board, task),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: CardWidgets().taskCard(context, ref, board, task),
          ),
        );
      },
    );
  }

  Widget countChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: sageGreen, borderRadius: BorderRadius.circular(8)),
      child: Text("$count", style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
  

}

