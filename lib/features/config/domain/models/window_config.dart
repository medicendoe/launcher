import 'package:equatable/equatable.dart';
import 'shortcut_config.dart';

enum WindowType {
  chat,
  sport,
  quick,
}

class WindowConfig extends Equatable {
  final WindowType type;
  final List<String> appPackageNames;
  final List<ShortcutConfig> shortcuts;

  const WindowConfig({
    required this.type,
    required this.appPackageNames,
    required this.shortcuts,
  });

  factory WindowConfig.fromJson(Map<String, dynamic> json) {
    return WindowConfig(
      type: WindowType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WindowType.chat,
      ),
      appPackageNames: List<String>.from(json['appPackageNames'] ?? []),
      shortcuts: (json['shortcuts'] as List<dynamic>?)
          ?.map((e) => ShortcutConfig.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'appPackageNames': appPackageNames,
      'shortcuts': shortcuts.map((e) => e.toJson()).toList(),
    };
  }

  WindowConfig copyWith({
    WindowType? type,
    List<String>? appPackageNames,
    List<ShortcutConfig>? shortcuts,
  }) {
    return WindowConfig(
      type: type ?? this.type,
      appPackageNames: appPackageNames ?? this.appPackageNames,
      shortcuts: shortcuts ?? this.shortcuts,
    );
  }

  @override
  List<Object> get props => [type, appPackageNames, shortcuts];
}
