part of 'app_list_cubit.dart';

class AppListState extends Equatable{
  final List<AppInfo> installedApps;
  final bool isUpdating;
  final bool isInitialLoad;

  const AppListState({
    required this.installedApps,
    this.isUpdating = false,
    this.isInitialLoad = true,
  });

  factory AppListState.initial() {
    return const AppListState(
      installedApps: [],
      isUpdating: false,
      isInitialLoad: true,
    );
  }

  AppListState copyWith({
    List<AppInfo>? installedApps,
    bool? isUpdating,
    bool? isInitialLoad,
  }) {
    return AppListState(
      installedApps: installedApps ?? this.installedApps,
      isUpdating: isUpdating ?? this.isUpdating,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
    );
  }

  @override
  List<Object> get props => [installedApps, isUpdating, isInitialLoad];
}