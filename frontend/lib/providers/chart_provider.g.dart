// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sunburstTree)
final sunburstTreeProvider = SunburstTreeProvider._();

final class SunburstTreeProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChartTreeNode>,
          ChartTreeNode,
          FutureOr<ChartTreeNode>
        >
    with $FutureModifier<ChartTreeNode>, $FutureProvider<ChartTreeNode> {
  SunburstTreeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sunburstTreeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sunburstTreeHash();

  @$internal
  @override
  $FutureProviderElement<ChartTreeNode> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChartTreeNode> create(Ref ref) {
    return sunburstTree(ref);
  }
}

String _$sunburstTreeHash() => r'22548b8f6298dfd746b579b0dfe5685ba24965d2';
