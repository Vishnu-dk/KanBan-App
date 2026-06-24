import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/dashboard_provider.dart';
import 'package:frontend/providers/kanbanprovider.dart';


class KanbanTotals {
  final String user;
  final int boards;
  final int columns;
  final int tasks;

  const KanbanTotals({
    required this.user,
    required this.boards,
    required this.columns,
    required this.tasks,
  });
}


final kanbanTotalsProvider = Provider<KanbanTotals>((ref) {
  final dashboardAsync = ref.watch(dashboardProvider);
  final dashboard = dashboardAsync.value ;

  if(dashboard==null){
      return KanbanTotals(
    user:"",
    boards: 0,
    columns: 0,
    tasks: 0,
  );
  }
  final user=dashboard.user;
  final boards=dashboard.boards;
  int boardCount = dashboard.boards.length;
  int columnCount = 0;
  int taskCount = 0;



  for (final board in boards) {
    final kanbanAsync = ref.watch(kanbanProvider(board));
    final kanbanBoard = kanbanAsync.value;
    if (kanbanBoard == null) continue;

    final columns = kanbanBoard.columnNames;
    columnCount += columns.length;

    for (final column in columns) {
      taskCount += column.tasks.length;
    }
  }

  return KanbanTotals(
    user:user,
    boards: boardCount,
    columns: columnCount,
    tasks: taskCount,
  );
});