

import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/services/board_service.dart';
import 'package:frontend/services/column_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart'; 

@riverpod
class Dashboard extends _$Dashboard {
  final _service = BoardService();
  final _columnService = ColumnService();

  @override
  Future<List<Board>> build() async {
    return fetchBoards();
  }

  Future<List<Board>> fetchBoards() async {
    final boards = await _service.getBoards();
    List<Board> boardsWithDetails = [];

    for (var board in boards) {
      final columnsData = await _columnService.getColumns(board.id);
      final List<KanbanColumn> cols = columnsData.map((c) => KanbanColumn.fromJson(c)).toList();
      boardsWithDetails.add(board.copyWith(columnNames: cols));
    }
    return boardsWithDetails;
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

