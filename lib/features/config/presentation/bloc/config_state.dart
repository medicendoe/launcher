part of 'config_cubit.dart';

class ConfigState extends Equatable {
  final AppConfig config;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  const ConfigState({
    required this.config,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
  });

  factory ConfigState.initial() {
    return ConfigState(
      config: AppConfig.initial(),
      isLoading: false,
      isSaving: false,
    );
  }

  ConfigState copyWith({
    AppConfig? config,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
  }) {
    return ConfigState(
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [config, isLoading, isSaving, error, successMessage];
}
