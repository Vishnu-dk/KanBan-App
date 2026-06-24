import 'package:frontend/modals/column.dart';
import 'package:intl/intl.dart';

class Board {
  final String id;
  final String name;
  final String createdAt;
  final List<KanbanColumn> columnNames;
  final String owner;
 
  Board({
    required this.id,
    required this.name,
    required this.createdAt,
    this.columnNames = const [],
    required this.owner
  });

  Board copyWith({List<KanbanColumn>? columnNames}) {   //creating the copy of the board object just to be able to overide this list  without changing orginal object
    return Board(
      id: id,
      name: name,
      createdAt: createdAt,
      columnNames: columnNames ?? this.columnNames,
      owner: owner
    );
  }
 
factory Board.fromJson(Map<String, dynamic> json) {  // create/modify a board intstance from a map 
  return Board(
    id: json['id'].toString(),
    name: json['name'] ?? "",
    owner: json['owner'] ?? "",
    createdAt: json['created_at'] != null
        ? DateFormat('dd-MM-yy')
            .format(DateTime.parse(json['created_at']))  //here formating it to the dd mm yyyy format
        : "",
    columnNames: (json['columns'] as List?)
            ?.map((col) => KanbanColumn.fromJson(col)) // casts column json array to list 
            .toList() ?? [],
  );
}
}



 



