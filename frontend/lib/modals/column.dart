
import 'package:frontend/modals/board.dart';
import 'package:frontend/modals/card.dart';

class KanbanColumn {
  final String id;
  final String name;
  final int position;
  final List<KanbanCard> tasks;
 
  KanbanColumn({
    required this.id,
    required this.name,
    required this.position,
    this.tasks = const [],
  });
 
factory KanbanColumn.fromJson(Map<String, dynamic> json, [List<KanbanCard> cards = const []]) { //here the dependency allows a list of card objects to get injected to the column
  return KanbanColumn(
    id: json['id'].toString(),
    name: json['title'] ?? "",
    position: (json['position']  ?? 0) as int, 
    tasks: cards,       //assigned here
  );
}
}

class DashboardState {
  final String user;
  final List<Board> boards;

  DashboardState({
    required this.user,
    required this.boards,
  });
}