import 'package:frontend/modals/column.dart';
import 'package:intl/intl.dart';

class Board {
  final String id;
  final String name;
  final String createdAt;
  final List<KanbanColumn> columnNames;
 
  Board({
    required this.id,
    required this.name,
    required this.createdAt,
    this.columnNames = const []
  });

  Board copyWith({List<KanbanColumn>? columnNames}) {
    return Board(
      id: id,
      name: name,
      createdAt: createdAt,
      columnNames: columnNames ?? this.columnNames,
    );
  }
 
factory Board.fromJson(Map<String, dynamic> json) {
  return Board(
    id: json['id'].toString(),
    name: json['name'] ?? "",
    createdAt: json['created_at'] != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(json['created_at']))
        : "",
    columnNames: (json['columns'] as List?)
            ?.map((col) => KanbanColumn.fromJson(col))
            .toList() ?? [],
    
  );
}
}



 



