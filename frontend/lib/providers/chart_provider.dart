import 'package:crystal_charts/crystal_charts.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/providers/dashboard_provider.dart';
import 'package:frontend/providers/kanbanprovider.dart';

part 'chart_provider.g.dart';

const Color boardColor = Color(0xFF6B705C);
const Color columnColor = Color(0xFFB7B7A4);
const Color taskColor = Color(0xFF3F4238);

@riverpod
Future<ChartTreeNode> sunburstTree(Ref ref) async {
  final dashboardAsync = ref.watch(dashboardProvider);

  final dashboard = dashboardAsync.value;
  if (dashboard == null) {
    return ChartTreeNode(name: 'root');
  }

  final boards = dashboard.boards;
  final List<ChartTreeNode> boardNodes = [];

  for (final board in boards) {
    final kanbanAsync = ref.watch(kanbanProvider(board));
    final kanbanBoard = kanbanAsync.value;
    if (kanbanBoard == null) continue;

    final List<ChartTreeNode> columnNodes = [];

    for (final column in kanbanBoard.columnNames) {
      final List<ChartTreeNode> taskNodes = [];

      for (final task in column.tasks) {
        taskNodes.add(
          ChartTreeNode(
            name: task.title,
            value: 1,
            color: taskColor,
          ),
        );
      }

      columnNodes.add(
        ChartTreeNode(
          name: column.name,
          children: taskNodes.isNotEmpty ? taskNodes : const [],
          value: taskNodes.isEmpty ? 1 : null,
          color: columnColor,
        ),
      );
    }

    boardNodes.add(
      ChartTreeNode(
        name: board.name,
        children: columnNodes.isNotEmpty ? columnNodes : const [],
        value: columnNodes.isEmpty ? 1 : null,
        color: boardColor,
      ),
    );
  }

  return ChartTreeNode(
    name: 'root',
    children: boardNodes,
  );
}