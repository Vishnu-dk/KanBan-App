

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/common_widgets.dart';

class CardWidgets {
  
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

  void showTaskOptions(BuildContext context, WidgetRef ref, KanbanCard task, Board board) {
    bool isEditing = false;
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    final descScrollController = ScrollController();
    DateTime? selectedDate = task.dueDate != null ? DateTime.tryParse(task.dueDate!) : null;

    // Shared Input Style to match Add Task dialog
    InputDecoration customInput(String label) => InputDecoration(
      labelText: label,
      filled: true,
      fillColor: primary.withValues(alpha: .8),
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary.withValues(alpha: .2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: sageGreen, width: 2),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(isEditing ? "Edit Task" : "Task Details", 
              style: TextStyle(color: secondary, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- TITLE SECTION ---
                    if (!isEditing) const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    isEditing 
                      ? TextField(controller: titleController, maxLines: null, decoration: customInput("Task Title")) 
                      : Text(task.title, softWrap: true),

                    const SizedBox(height: 16),

                    // --- DESCRIPTION SECTION ---
                    if (!isEditing) const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: isEditing 
                        ? TextField(
                            controller: descController,
                            scrollController: descScrollController,
                            maxLines: null,
                            expands: true,
                            decoration: customInput("Description"),
                          )
                        : Container(
                            padding: const EdgeInsets.all(12),
                            
                            decoration: BoxDecoration(
    
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: secondary.withValues(alpha: .1)),
                            ),
                            child: Scrollbar(
                              controller: descScrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: descScrollController,
                                child: Text(task.description.isEmpty ? "No description" : task.description, softWrap: true),
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 16),

                    // --- DATE SECTION ---
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: deepForest),
                        const SizedBox(width: 8),
                        Expanded(child: Text(selectedDate == null 
                          ? "No date set" 
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}")),
                        if (isEditing)
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) setState(() => selectedDate = picked);
                            },
                            child: const Text("Set Date"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => setState(() => isEditing = !isEditing),
                child: Text(isEditing ? "Cancel" : "Edit", style: TextStyle(color: secondary.withValues(alpha: 0.5))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? sageGreen : const Color.fromARGB(255, 184, 0, 0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (isEditing) {
                    await ref.read(kanbanProvider(board).notifier).updateTask(
                      task,
                      taskId: task.id,
                      position: task.position, 
                      title: titleController.text,
                      description: descController.text,
                      dueDate: selectedDate?.toIso8601String(),
                      columnId: task.columnId
                    );
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context); 
                    CommonWidgets().confirmDelete(
                      context: context, id: task.id, title: task.title, type: "task", 
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

  void addTaskDialog(BuildContext context, WidgetRef ref, Board board, KanbanColumn column) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    // Controller to handle internal scrolling for the description field
    final descScrollController = ScrollController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (cntxt, setModalState) => AlertDialog(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
            child: Text("Add Task", style: TextStyle(color: secondary, fontWeight: FontWeight.bold)),
          ),
          content: SizedBox(
            // 1. Fixed width ensures the dialog doesn't grow horizontally
            width: 300, 
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Task to be assigned/added",
                    style: TextStyle(color: secondary.withValues(alpha: .6), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    maxLines: null, // Allows title to wrap downwards
                    decoration: InputDecoration(
                      labelText: "Task Title",
                      filled: true,
                      fillColor: primary.withValues(alpha: .8),
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
                  const SizedBox(height: 8),
                  
                  // 2. Fixed height for Description to make it internally scrollable
                  SizedBox(
                    height: 120,
                    child: TextField(
                      controller: descController,
                      scrollController: descScrollController,
                      maxLines: null,
                      expands: true, // Fills the 120px height
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true, // Keeps label at the top
                        filled: true,
                      fillColor: primary.withValues(alpha: .8),
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
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: deepForest),
                      const SizedBox(width: 8),
                      Expanded( // Prevents overflow in the row
                        child: Text(selectedDate == null 
                          ? "No date set" 
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                      ),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: Text("Cancel", style: TextStyle(color: secondary.withValues(alpha: 0.5)))
            ),
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
                Navigator.pop(ctx);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

}