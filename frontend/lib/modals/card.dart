class KanbanCard {
  final String id;
  final String title;
  final String description; 
  final int position;
  final String? dueDate;    
  final String columnId;

  KanbanCard({
    required this.id,
    required this.title,
    this.description = "",
    required this.position,
    this.dueDate,
    required this.columnId,
  });

  factory KanbanCard.fromJson(Map<String, dynamic> json) {
    return KanbanCard(
      id: json['id'].toString(),
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      position: (json['position']  ?? 0) as int, 
      dueDate: json['due_date'],
      columnId: json['column_id'].toString(),
    );
  }
}
