
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
 
factory KanbanColumn.fromJson(Map<String, dynamic> json, [List<KanbanCard> cards = const []]) {
  return KanbanColumn(
    id: json['id'].toString(),
    name: json['title'] ?? "",
    position: (json['position']  ?? 0) as int, 
    tasks: cards, 
  );
}
}