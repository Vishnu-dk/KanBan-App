// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Dashboard)
final dashboardProvider = DashboardProvider._();

final class DashboardProvider
    extends $AsyncNotifierProvider<Dashboard, List<Board>> {
  DashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardHash();

  @$internal
  @override
  Dashboard create() => Dashboard();
}

String _$dashboardHash() => r'8286060dc75ad22e1c15075b6c7f95bf40ebb046';

abstract class _$Dashboard extends $AsyncNotifier<List<Board>> {
  FutureOr<List<Board>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Board>>, List<Board>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Board>>, List<Board>>,
              AsyncValue<List<Board>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
