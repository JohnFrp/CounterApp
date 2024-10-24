import 'dart:io';

import 'package:counter/provider/counter.provider.dart';
import 'package:counter/provider/theme_provider';
import 'package:counter/view/home_view.dart';
import 'package:counter/view/tally_full_view.dart';
import 'package:counter/view/tally_set_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> args) {
  if (kIsWeb || !Platform.isAndroid) {
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CountProvider()..loadItems()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        "/": (_) => HomeView(),
        "tallySet": (_) => const TallySetView(),
        "tallyFull": (context) => const TallyFullView(),
      },
      initialRoute: "/",
    );
  }
}
