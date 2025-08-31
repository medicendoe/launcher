import 'package:equatable/equatable.dart';
import 'window_config.dart';
import 'shortcut_config.dart';

class AppConfig extends Equatable {
  final List<WindowConfig> windowConfigs;
  final List<ShortcutConfig> appPageShortcuts;

  const AppConfig({
    required this.windowConfigs,
    required this.appPageShortcuts,
  });

  factory AppConfig.initial() {
    return AppConfig(
      windowConfigs: [
        WindowConfig(
          type: WindowType.chat,
          appPackageNames: [
            'com.whatsapp',
            'com.Slack',
            'org.telegram.messenger',
            'com.discord',
            'com.instagram.android',
            'com.bumble.app',
            'enterprises.dating.boo',
            'com.google.android.gm',
          ],
          shortcuts: [
            const ShortcutConfig(
              direction: SwipeDirection.right,
              packageName: 'com.samsung.android.dialer',
            ),
            const ShortcutConfig(
              direction: SwipeDirection.down,
              packageName: 'com.sec.android.app.camera',
            ),
          ],
        ),
        WindowConfig(
          type: WindowType.sport,
          appPackageNames: [
            'com.strava',
          ],
          shortcuts: [
            const ShortcutConfig(
              direction: SwipeDirection.right,
              packageName: 'com.google.android.apps.maps',
            ),
            const ShortcutConfig(
              direction: SwipeDirection.down,
              packageName: 'com.garmin.android.apps.connectmobile',
            ),
            const ShortcutConfig(
              direction: SwipeDirection.up,
              packageName: 'com.peaksware.trainingpeaks',
            ),
          ],
        ),
        WindowConfig(
          type: WindowType.quick,
          appPackageNames: [
            'notion.id',
            'cl.uchile.ing.adi.ucursos',
            'bbl.intl.bambulab.com',
            'net.veritran.becl.prod',
            'cl.bancochile.mi_banco',
            'cl.bancochile.mi_pass',
            'com.google.android.apps.docs',
          ],
          shortcuts: [
            const ShortcutConfig(
              direction: SwipeDirection.left,
              packageName: 'com.android.chrome',
            ),
            const ShortcutConfig(
              direction: SwipeDirection.down,
              packageName: 'com.google.android.calendar',
            ),
            const ShortcutConfig(
              direction: SwipeDirection.up,
              packageName: 'com.spotify.music',
            ),
          ],
        ),
      ],
      appPageShortcuts: [
        const ShortcutConfig(
          direction: SwipeDirection.right,
          packageName: 'com.sec.android.app.popupcalculator',
        ),
        const ShortcutConfig(
          direction: SwipeDirection.left,
          packageName: 'com.sec.android.app.myfiles',
        ),
        const ShortcutConfig(
          direction: SwipeDirection.down,
          packageName: 'com.android.settings',
        ),
      ],
    );
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      windowConfigs: (json['windowConfigs'] as List<dynamic>?)
          ?.map((e) => WindowConfig.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      appPageShortcuts: (json['appPageShortcuts'] as List<dynamic>?)
          ?.map((e) => ShortcutConfig.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'windowConfigs': windowConfigs.map((e) => e.toJson()).toList(),
      'appPageShortcuts': appPageShortcuts.map((e) => e.toJson()).toList(),
    };
  }

  WindowConfig? getWindowConfig(WindowType type) {
    try {
      return windowConfigs.firstWhere((config) => config.type == type);
    } catch (e) {
      return null;
    }
  }

  ShortcutConfig? getShortcut(SwipeDirection direction, {WindowType? windowType}) {
    List<ShortcutConfig> shortcuts;
    
    if (windowType != null) {
      final windowConfig = getWindowConfig(windowType);
      shortcuts = windowConfig?.shortcuts ?? [];
    } else {
      shortcuts = appPageShortcuts;
    }
    
    try {
      return shortcuts.firstWhere((shortcut) => shortcut.direction == direction);
    } catch (e) {
      return null;
    }
  }

  AppConfig copyWith({
    List<WindowConfig>? windowConfigs,
    List<ShortcutConfig>? appPageShortcuts,
  }) {
    return AppConfig(
      windowConfigs: windowConfigs ?? this.windowConfigs,
      appPageShortcuts: appPageShortcuts ?? this.appPageShortcuts,
    );
  }

  @override
  List<Object> get props => [windowConfigs, appPageShortcuts];
}
