
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:starwarsproj_flutter/configs/app_config.dart';
import 'package:starwarsproj_flutter/pages/login_page.dart';

void main() async {
  // loads environtment variable
  await dotenv.load(fileName: ".env");

  var ensevalGuardUrl = dotenv.env["ENSEVAL_GUARD_URL"];
  var swapiBaseUrl = dotenv.env["SWAPI_BASE_URL"];

  if(ensevalGuardUrl != null) {
    AppConfig.ensevalGuardUrl = ensevalGuardUrl;
  }

  if(swapiBaseUrl != null){
    AppConfig.apiBaseUrl = swapiBaseUrl;
  }

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const RootApp());
}

class RootApp extends StatelessWidget{
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Watcher',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {    
    return LoginPage();
  }
}
