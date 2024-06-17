import 'package:arcane/apps_page.dart';
import 'package:arcane/arcade_mode.dart';
import 'package:arcane/files_from_fire.dart';
import 'package:arcane/form_.dart';
import 'package:arcane/test_launch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        home: const TestLaunch(),
        routes: {
          'apps': (context) => const AppsPage(),
          'arcade mode': (context) => const ArcadeMode(),
          'test launch': (context) => const TestLaunch(),
          'Login form': (context) => FormsOf(),
          'FilesFromFire': (context) => FilesFromFire()
        },
      ),
    );
  }
}
