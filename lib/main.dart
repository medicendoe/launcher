import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher/app/theme/app_theme.dart';
import 'package:launcher/app/route/router.dart';
import 'package:launcher/app/route/route_constants.dart';
import 'package:launcher/features/app_list/app_list_feature.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Precargar apps antes de mostrar la UI
  final appListCubit = AppListCubit();
  await appListCubit.refreshAppList(); // Forzar carga inicial
  
  runApp(MyApp(appListCubit: appListCubit));
}

class MyApp extends StatelessWidget {
  final AppListCubit appListCubit;

  const MyApp({super.key, required this.appListCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: appListCubit,
      child: MaterialApp(
        title: 'Launcher',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: RouteConstants.home,
      ),
    );
  }
}