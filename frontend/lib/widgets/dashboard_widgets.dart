
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/providers/dashboard_provide.dart';
import 'package:frontend/screens/kanban_view.dart';
import 'package:frontend/widgets/common_widgets.dart';


Widget boardCard(BuildContext context, Board board,WidgetRef ref) {
  final display = board.columnNames.take(3).toList();
  final extra = board.columnNames.length - 3;

  return InkWell(
    onTap: () async {
    await Navigator.push(context,MaterialPageRoute(builder: (context) => KanbanView(board: board,)),);
    ref.read(dashboardProvider.notifier).fetchBoards();
    },
    borderRadius: BorderRadius.circular(15),
    child: Card(
      color: softSage.withValues(alpha: 0.15), 
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
        side: BorderSide(color: deepForest.withValues(alpha: 0.1), width: 1.5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    board.name,
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: deepForest,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => CommonWidgets().confirmDelete(context: context,
                                                                    id: board.id,
                                                                    title: board.name,
                                                                    type: "board",
                                                                    onConfirm: (id) => ref.read(dashboardProvider.notifier).deleteBoard(id),
                                                                    ),
                  icon: const Icon(Icons.delete_forever_rounded, color: Color.fromARGB(255, 151, 0, 0))
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${board.columnNames.length} Columns",
              style: TextStyle(color: deepForest.withValues(alpha: 0.5), fontSize: 14),
            ),
            const Spacer(),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...display.map((c) => _buildModernTag(c.name)),
                if (extra > 0) _buildModernTag("+ $extra", isExtra: true),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 2,horizontal: 10),
              child: Text("created at : ${board.createdAt}",style: const TextStyle( fontSize: 12,color: deepForest,letterSpacing: 0.5,),
              )
            
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildModernTag(String label, {bool isExtra = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: isExtra ? sageGreen : primary.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      overflow: TextOverflow.ellipsis,
      label,
      style: TextStyle(
        fontSize: 10, 
        fontWeight: FontWeight.w600,
        color: isExtra ? primary : deepForest,
      ),
    ),
  );
}
