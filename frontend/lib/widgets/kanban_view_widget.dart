import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/common_widgets.dart';

class KanbanViewWidget {
  
  
  Widget buildKanbanColumn(BuildContext context, WidgetRef ref, KanbanColumn column,Board board) {
    return Container(
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: column.tasks.map((task) => taskCard(context,ref,board,task)).toList(),
            ),
          ),
   
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton.icon(
              onPressed: () => addTaskDialog(context, ref, board, column),
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

  Widget taskCard(BuildContext context,WidgetRef ref, Board board, KanbanCard task) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Flexible(child: Text(task.title,overflow: TextOverflow.ellipsis, style: const TextStyle(color: deepForest, fontWeight: FontWeight.bold, fontSize: 17))),
            IconButton(
              onPressed: () => showTaskOptions(context, ref, task, board),
              icon: const Icon(Icons.info_outline_rounded),
            )
        ],
      )
    );
  }

  Widget countChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: sageGreen, borderRadius: BorderRadius.circular(8)),
      child: Text("$count", style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
  
  void addTaskDialog(BuildContext context,WidgetRef ref,Board board,KanbanColumn column) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (cntxt,setModalState)=>AlertDialog(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Add Task", style: TextStyle(color: secondary, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task to be assigned/added",
              style: TextStyle(color: secondary.withValues(alpha: .6), fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText:"Task Title",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondary.withValues(alpha: .2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: sageGreen, width: 2),
                ),
              ),
            ),
            SizedBox(height: 8,),
            TextField(
              controller: descController,
              autofocus: true,
              decoration: InputDecoration(
                labelText:"Description" ,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondary.withValues(alpha: .2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: sageGreen, width: 2),
                ),
              ),
            ),
            SizedBox(height: 8,),
                          Row(
                children: [
                  const Icon(Icons.calendar_month, color: deepForest),
                  const SizedBox(width: 8),
                  Text(selectedDate == null 
                    ? "No date set" 
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    child: const Text("Set Date"),
                  ),
                ],
              ),
          ],
        ),
        ),
        
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel", style: TextStyle(color: secondary.withValues(alpha: 0.5)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: sageGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
            onPressed: () {  
              ref.read(kanbanProvider(board).notifier).addTask(
                      column.id,
                      titleController.text,
                      descController.text,
                      selectedDate?.toIso8601String(),
                    );
              Navigator.pop(ctx); }, 
            child:  Text("Add"),
          ),
        ],
      )
        ),
    );
  }
  
  void showTaskOptions(BuildContext context, WidgetRef ref, KanbanCard task, Board board) {
    bool isEditing = false;
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    DateTime? selectedDate = task.dueDate != null ? DateTime.tryParse(task.dueDate!) : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(isEditing ? "Edit Task" : "Task Details"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
                  isEditing ? TextField(controller: titleController) : Text(task.title),
                  const SizedBox(height: 15),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  isEditing ? TextField(controller: descController, maxLines: 3) : Text(task.description),
                  const SizedBox(height: 15),

                  const Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(selectedDate == null 
                        ? "No date set" 
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                      if (isEditing) 
                        IconButton(
                          icon: const Icon(Icons.calendar_month, color: deepForest),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => setState(() => isEditing = !isEditing),
                child: Text(isEditing ? "Cancel" : "Edit"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? sageGreen : Colors.redAccent,
                ),
                onPressed: () async {
                  if (isEditing) {
                    await ref.read(kanbanProvider(board).notifier).updateTask(
                      taskId: task.id, 
                      title: titleController.text,
                      description: descController.text,
                      dueDate: selectedDate?.toIso8601String(),
                    );
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context); 
                    CommonWidgets().confirmDelete(
                      context: context, 
                      id: task.id, 
                      title: task.title, 
                      type: "task", 
                      onConfirm: (id) => ref.read(kanbanProvider(board).notifier).deleteTask(id),
                    );
                  }
                },
                child: Text(isEditing ? "Update" : "Delete"),
              )

            ],
          );
        },
      ),
    );
}

}