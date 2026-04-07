
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/services/card_services.dart';
import 'package:frontend/services/column_services.dart';

final kanbanProvider = StateNotifierProvider.family<KanbanNotifier, AsyncValue<Board>, Board>((ref, initialBoard) {
  return KanbanNotifier(initialBoard);
});
 
class KanbanNotifier extends StateNotifier<AsyncValue<Board>> {
  final Board initialBoard;
  final _colService = ColumnService();
  final _cardService = CardService();
 
  KanbanNotifier(this.initialBoard) : super(const AsyncValue.loading()) {
    refreshBoard();
  }
 
  Future<void> refreshBoard() async {
    try {
      final List<dynamic> columnData = await _colService.getColumns(initialBoard.id);
      List<KanbanColumn> fullColumns = [];

      for (var colJson in columnData) {
        final String colId = colJson['id'].toString();
        final List<dynamic> cardData = await _cardService.getCards(colId);
        List<KanbanCard> cards = cardData.map((c) => KanbanCard.fromJson(c)).toList();
        fullColumns.add(KanbanColumn.fromJson(colJson, cards));
      }

      fullColumns.sort((a, b) => a.position.compareTo(b.position));
      state = AsyncValue.data(initialBoard.copyWith(columnNames: fullColumns));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addColumn(String name) async {
    await _colService.addColumn(initialBoard.id, name);
    await refreshBoard();
  }
  Future<void> deleteColumn(String column_id) async {
    await _colService.deleteColumn(column_id);
    await refreshBoard();
  }
  Future<void> editColumn(KanbanColumn column,String columnName) async {
    await _colService.updateColumn(column.id,name:columnName,position:column.position );
    await refreshBoard();
  }
 
  Future<void> addTask(String columnId, String title,String? description, String? dueDate) async {
    await _cardService.addCard(columnId, title, description,  dueDate);
    await refreshBoard();
  }


  Future<void> updateTask({required String taskId, String? title, String? description, String? dueDate}) async {
    try {
      await _cardService.updateCard(taskId, title: title, description: description, dueDate: dueDate);
      await refreshBoard();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  Future<void> deleteTask(String taskId) async {
    try {
      await _cardService.deleteCard(taskId);
      await refreshBoard();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}