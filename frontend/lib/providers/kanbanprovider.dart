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

  Future<Board> refreshBoard() async {
    return await _fetchBoardData(initialBoard);
  }
  
  Future<void> addColumn(String name) async {
    state = await AsyncValue.guard(() async {
      await _colService.addColumn(initialBoard.id, name);
      return await refreshBoard(); 
    });
  }
  
  Future<void> deleteColumn(String columnId) async {
    state = await AsyncValue.guard(() async {
      await _colService.deleteColumn(columnId);
      return await refreshBoard();
    });
  }
  
  Future<void> editColumn(KanbanColumn column, String columnName) async {
    state = await AsyncValue.guard(() async {
      await _colService.updateColumn(column.id, name: columnName, position: column.position);
      return await refreshBoard();
    });
  }


  Future<void> addTask(String columnId, String title, String? description, String? dueDate) async {
    state = await AsyncValue.guard(() async {
      await _cardService.addCard(columnId, title, description, dueDate);
      return await _fetchBoardData(initialBoard);
    });
  }
  

  Future<void> updateTask(KanbanCard task,{required String taskId, String? title,int?position, String? description, String? dueDate,String? columnId}) async {
    state = await AsyncValue.guard(() async {
      await _cardService.updateCard(taskId, title: title, description: description, dueDate: dueDate,position:position,columnId: columnId);
      return _fetchBoardData(initialBoard);
    });
  }
  Future<void> moveTask(KanbanCard task, {required int newPosition,required String toColumnId,}) async {
    state = await AsyncValue.guard(() async {
      await _cardService.updateCard(task.id, position: newPosition,columnId: toColumnId,);
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
