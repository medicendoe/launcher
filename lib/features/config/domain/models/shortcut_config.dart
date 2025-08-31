import 'package:equatable/equatable.dart';

enum SwipeDirection {
  up,
  down,
  left,
  right,
}

class ShortcutConfig extends Equatable {
  final SwipeDirection direction;
  final String packageName;

  const ShortcutConfig({
    required this.direction,
    required this.packageName,
  });

  factory ShortcutConfig.fromJson(Map<String, dynamic> json) {
    return ShortcutConfig(
      direction: SwipeDirection.values.firstWhere(
        (e) => e.name == json['direction'],
        orElse: () => SwipeDirection.up,
      ),
      packageName: json['packageName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direction': direction.name,
      'packageName': packageName,
    };
  }

  ShortcutConfig copyWith({
    SwipeDirection? direction,
    String? packageName,
  }) {
    return ShortcutConfig(
      direction: direction ?? this.direction,
      packageName: packageName ?? this.packageName,
    );
  }

  @override
  List<Object> get props => [direction, packageName];
}
