import 'package:crystal_charts/crystal_charts.dart' as cc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/chart_provider.dart';

class SunburstChart extends ConsumerWidget {
  const SunburstChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTree = ref.watch(sunburstTreeProvider);

    return asyncTree.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (tree) {
        return SizedBox(
          width: 380,
          height: 380,
          child: cc.SunburstChart(
            data: tree,

            theme: cc.ChartTheme.defaultTheme.copyWith(
              backgroundColor: Colors.transparent,
            ),

            textStyle: const TextStyle(
              fontSize: 0,
              height: 0,
              decoration: TextDecoration.none,
            ),

            tooltipBuilder:
                (BuildContext context, cc.ChartTreeNode node, int depth) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  node.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              );
            },

            showTooltip: true,
            visibleDepth: 3,
            innerRadiusRatio: 0.25,
          ),
        );
      },
    );
  }
}