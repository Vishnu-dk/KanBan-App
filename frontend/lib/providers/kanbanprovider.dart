import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';
import 'package:frontend/modals/column.dart';
import 'package:frontend/services/card_services.dart';
import 'package:frontend/services/column_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kanbanprovider.g.dart'; 

@riverpod
class Kanban extends _$Kanban {
  final _colService = ColumnService();
  final _cardService = CardService();


  @override
  Future<Board> build(Board initialBoard) async {
    return _fetchBoardData(initialBoard);
  }

  Future<Board> _fetchBoardData(Board currentBoard) async {
    final List<dynamic> columnData = await _colService.getColumns(currentBoard.id);
    List<KanbanColumn> fullColumns = [];

    for (var colJson in columnData) {
      final String colId = colJson['id'].toString();
      final List<dynamic> cardData = await _cardService.getCards(colId);
      List<KanbanCard> cards = cardData.map((c) => KanbanCard.fromJson(c)).toList();
      fullColumns.add(KanbanColumn.fromJson(colJson, cards));
    }

    fullColumns.sort((a, b) => a.position.compareTo(b.position));
    return currentBoard.copyWith(columnNames: fullColumns);
  }

  // 3. Manual refresh method
  Future<void> refreshBoard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchBoardData(initialBoard));
  }

  // 4. Action methods (Side effects)
  Future<void> addColumn(String name) async {
    await _colService.addColumn(initialBoard.id, name);
    await refreshBoard();
  }

  Future<void> deleteColumn(String columnId) async {
    await _colService.deleteColumn(columnId);
    await refreshBoard();
  }

  Future<void> editColumn(KanbanColumn column, String columnName) async {
    await _colService.updateColumn(column.id, name: columnName, position: column.position);
    await refreshBoard();
  }

  Future<void> addTask(String columnId, String title, String? description, String? dueDate) async {
    await _cardService.addCard(columnId, title, description, dueDate);
    await refreshBoard();
  }

  Future<void> updateTask({required String taskId, String? title, String? description, String? dueDate}) async {
    state = await AsyncValue.guard(() async {
      await _cardService.updateCard(taskId, title: title, description: description, dueDate: dueDate);
      return _fetchBoardData(initialBoard);
    });
  }

  Future<void> deleteTask(String taskId) async {
    state = await AsyncValue.guard(() async {
      await _cardService.deleteCard(taskId);
      return _fetchBoardData(initialBoard);
    });
  }
}
