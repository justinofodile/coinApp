import 'dart:convert';

import 'package:coin_app/models/app_config.dart';
import 'package:coin_app/pages/home_page.dart';
import 'package:coin_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  // await GetIt.instance.get<HTTPService>().get('/coins/bitcoin');
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  // ignore: no_leading_underscores_for_local_identifiers
  String _configContent =
      await rootBundle.loadString("assets/config/main.json");
  // ignore: no_leading_underscores_for_local_identifiers
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(
      COIN_API_BASE_URL: _configData['COIN_API_BASE_URL'],
    ),
  );
  // print(_configData);
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
      ),
      home: const HomePage(),
    );
  }
}
