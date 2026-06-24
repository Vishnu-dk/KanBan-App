// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanbanprovider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Kanban)
final kanbanProvider = KanbanFamily._();

final class KanbanProvider extends $AsyncNotifierProvider<Kanban, Board> {
  KanbanProvider._({
    required KanbanFamily super.from,
    required Board super.argument,
  }) : super(
         retry: null,
         name: r'kanbanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kanbanHash();

  @override
  String toString() {
    return r'kanbanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Kanban create() => Kanban();

  @override
  bool operator ==(Object other) {
    return other is KanbanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kanbanHash() => r'd73b3967ba837bcfbbe5049dc9c6356fd118b97a';

final class KanbanFamily extends $Family
    with
        $ClassFamilyOverride<
          Kanban,
          AsyncValue<Board>,
          Board,
          FutureOr<Board>,
          Board
        > {
  KanbanFamily._()
    : super(
        retry: null,
        name: r'kanbanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  KanbanProvider call(Board initialBoard) =>
      KanbanProvider._(argument: initialBoard, from: this);

  @override
  String toString() => r'kanbanProvider';
}

abstract class _$Kanban extends $AsyncNotifier<Board> {
  late final _$args = ref.$arg as Board;
  Board get initialBoard => _$args;

  FutureOr<Board> build(Board initialBoard);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Board>, Board>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Board>, Board>,
              AsyncValue<Board>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
