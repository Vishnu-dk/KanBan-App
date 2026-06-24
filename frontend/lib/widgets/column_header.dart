import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/providers/kanbanprovider.dart';
import 'package:frontend/widgets/column_widgets.dart';
import 'package:frontend/widgets/common_widgets.dart';

class KanbanColumnHeader extends StatefulWidget {
  const KanbanColumnHeader({
    super.key,
    required this.column,
    required this.board,
    required this.ref,
  });

  final KanbanColumn column;
  final Board board;
  final WidgetRef ref;

  @override
  State<KanbanColumnHeader> createState() => _KanbanColumnHeaderState();
}

class _KanbanColumnHeaderState extends State<KanbanColumnHeader> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Draggable<KanbanColumn>(
            data: widget.column,
            axis: Axis.horizontal,
            feedback: Material(
              color: Colors.transparent,
              child: ColumnWidgets().buildKanbanColumnPreview(widget.column),
            ),
            childWhenDragging: const Icon(
              Icons.drag_indicator,
              color: Colors.grey,
            ),
            child: const Icon(
              Icons.drag_indicator,
              size: 20,
              color: deepForest,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _showActions = true),
            onExit: (_) => setState(() => _showActions = false),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.column.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: deepForest,
                  ),
                ),

                const SizedBox(height: 4),

                SizedBox(
                  width: 96, 
                  height: 24,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                    
                      AnimatedOpacity(
                        opacity: _showActions ? 1.0 : 1.0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        child: ColumnWidgets()
                            .countChip(widget.column.tasks.length),
                      ),
                
                
                      AnimatedOpacity(
                        opacity: _showActions ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        child: IgnorePointer(
                          ignoring: !_showActions,
                          child: _ActionRow(
                            column: widget.column,
                            board: widget.board,
                            ref: widget.ref,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
  
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.column,
    required this.board,
    required this.ref,
  });

  final KanbanColumn column;
  final Board board;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 4),
    child: Row(
      children: [
        _headerIcon(
          Icons.edit_outlined,
          onTap: () => CommonWidgets().showDialogs(
            context,
            "Edit Column",
            "Enter New Column Name",
            "Update",
            (val) => ref
                .read(kanbanProvider(board).notifier)
                .editColumn(column, val),
          ),
        ),
        _headerIcon(
          Icons.delete_outline,
          color: Colors.redAccent,
          onTap: () => CommonWidgets().confirmDelete(
            context: context,
            id: column.id,
            title: column.name,
            type: "Column",
            onConfirm: (id) => ref
                .read(kanbanProvider(board).notifier)
                .deleteColumn(id),
          ),
        ),

      ],
    ));
  }

  Widget _headerIcon(
    IconData icon, {
    Color color = deepForest,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      radius: 18,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}