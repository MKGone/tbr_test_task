import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbr_test_task/theme/theme.dart';
import 'package:tbr_test_task/views/home_screen.dart';
import 'package:tbr_test_task/services/rocket_service.dart';
import 'blocs/rocket_bloc.dart';
import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider(
        create: (context) => RocketBloc(RocketService()),
        child: const HomeScreen(),
      ),
      theme: darkTheme,
    );
  }
}
