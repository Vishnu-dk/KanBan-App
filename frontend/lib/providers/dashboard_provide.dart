

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/services/board_service.dart';
import 'package:frontend/services/column_services.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<List<Board>>>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<AsyncValue<List<Board>>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    fetchBoards();
  }

  final _service = BoardService();

  Future<void> fetchBoards() async {
    state = const AsyncValue.loading();
    try {
      final boards = await _service.getBoards();
      List<Board> boardsWithDetails = [];
      final columnService = ColumnService();
        for (var board in boards) {
          final columnsData = await columnService.getColumns(board.id);
          final List<KanbanColumn> cols = columnsData.map((c) => KanbanColumn.fromJson(c)).toList();
          boardsWithDetails.add(board.copyWith(columnNames: cols));
        }
      state = AsyncValue.data(boardsWithDetails);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createBoard(String name) async {
    try {
      await _service.addBoard(name);
      fetchBoards();
    } catch (e) {}
  }
  Future<void> deleteBoard(String boardId) async {
    try {
      await _service.deleteBoard(boardId);
      fetchBoards();
    } catch (e){}
  }
}

