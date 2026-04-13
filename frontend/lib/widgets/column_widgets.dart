
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/card_widgets.dart';
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
            // This forces the Row to be at least as tall as the viewport
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: currentBoard.columnNames.asMap().entries.map((entry) {
                  final index = entry.key;
                  final col = entry.value;

                  return DragTarget<KanbanColumn>(
  // Only accept if it's not the same column
  onWillAcceptWithDetails: (details) => details.data.id != col.id,
  onAcceptWithDetails: (details) {
    ref.read(kanbanProvider(board).notifier).moveColumn(details.data, index);
  },
  builder: (context, candidateData, _) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // Only show Sage Green when a column is being dragged over THIS target
      decoration: BoxDecoration(
        color: candidateData.isNotEmpty 
            ? sageGreen.withValues(alpha: 0.2) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LongPressDraggable<KanbanColumn>(
        data: col,
        axis: Axis.horizontal,
        // This is the box you see WHILE dragging
        feedback: Material(
          elevation: 10,
          
          color: primary, // Your Primary color for the dragging box
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 296,
            height: constraints.maxHeight - 40,
            child: buildKanbanColumn(context, ref, col, board),
          ),
        ),
        // What stays behind in the list while you drag
        childWhenDragging: Opacity(
          opacity: 0.3,
          
          child: SizedBox(
            
            width: 296, 
            child: buildKanbanColumn(context, ref, col, board)
          ),
        ),
        child: SizedBox(
          width: 296,
          child: buildKanbanColumn(context, ref, col, board),
        ),
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
  // Expanded(
  //           child: Scrollbar(
  //             controller: horizontalController,
  //             thumbVisibility: true,
  //             child: SingleChildScrollView(
  //               controller: horizontalController,
  //               scrollDirection: Axis.horizontal, 
  //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch, 
  //                 children: currentBoard.columnNames.map((col) {
  //                   return SizedBox(
  //                     width: 296,
  //                     child: buildKanbanColumn(context, ref, col, board),
  //                   );
  //                 }).toList(), 
  //               ),
  //             ),
  //           ),
  //         ),     

  Widget buildKanbanColumn(BuildContext context, WidgetRef ref, KanbanColumn column,Board board) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(column.name,overflow: TextOverflow.ellipsis, style: const TextStyle(color: deepForest, fontWeight: FontWeight.bold, fontSize: 17))),
                Row(
                  children: [
                    countChip(column.tasks.length),
                    IconButton(onPressed: () => CommonWidgets().showDialogs(context, "Edit Column", "Enter New Column Name","Update",(val) =>ref.read(kanbanProvider(board).notifier).editColumn(column, val)),
                       icon: Icon(Icons.edit)),
                    IconButton(
                      onPressed: () => CommonWidgets().confirmDelete(
                        context: context,
                        id: column.id,
                        title: column.name,
                        type: "Column",
                        onConfirm: (id) => ref.read(kanbanProvider(board).notifier).deleteColumn(id),), icon: Icon(Icons.clear_rounded),)
                  ],
                )

              ],
            ),
          ),
          Expanded(
            child: DragTarget<KanbanCard>(
              onAcceptWithDetails: (details) {
                ref.read(kanbanProvider(board).notifier).moveTask(details.data,newPosition: column.tasks.length,toColumnId: column.id,);
              },

            builder: (context, candidateData, _) {
              return Container(
                decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? Colors.black.withValues(alpha:0.05) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    ),
                child: ListView.builder(
                   padding: const EdgeInsets.symmetric(horizontal: 12),
                   itemCount: column.tasks.length + 1,
                   itemBuilder: (context, index) {
                     if (index == column.tasks.length) {
                       return _buildDropZone(index, column, board, ref);
                     }

                     final task = column.tasks[index];

                     return DragTarget<KanbanCard>(
                       onAcceptWithDetails: (details) {
                         if (details.data.id == task.id) return;

                         ref.read(kanbanProvider(board).notifier).moveTask(
                               details.data,
                               newPosition: index,
                               toColumnId: column.id,
                             );
                       },
                       builder: (context, candidateData, _) {
                         return Column(
                           children: [
                             AnimatedContainer(
                               duration: const Duration(milliseconds: 200),
                               height: candidateData.isNotEmpty ? 50 : 0,
                               margin: EdgeInsets.symmetric(vertical: candidateData.isNotEmpty ? 8 : 0),
                               decoration: BoxDecoration(
                                 color: sageGreen.withValues(alpha:0.1),
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(color: sageGreen, width: 1, style: BorderStyle.solid),
                               ),
                               child: const Center(child: Icon(Icons.download_rounded, color: sageGreen)),
                             ),
                             _buildDraggableTaskCard(context, ref, column, board, task, index),
                           ],
                         );
                       },
                     );
                   },
                 ),

                );
              },
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

  Widget _buildDropZone(int index, KanbanColumn column, Board board, WidgetRef ref) {
    return DragTarget<KanbanCard>(
      onAcceptWithDetails: (details) {
        ref.read(kanbanProvider(board).notifier).moveTask(
              details.data,
              newPosition: index,
              toColumnId: column.id,
            );
      },
      builder: (context, candidateData, _) {
        return Container(
          height: 50, 
          color: candidateData.isNotEmpty ? Colors.black12 : Colors.transparent,
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
              child: CardWidgets().taskCard(context, ref, board, task),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.2,
            child: CardWidgets().taskCard(context, ref, board, task),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
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