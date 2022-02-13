import 'package:flutter/material.dart';
import 'package:note_app_hive/pages/detail_page.dart';
import 'package:note_app_hive/pages/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:note_app_hive/services/db_service.dart';

void main() async {
  ///Initialization
  await Hive.initFlutter();
  await Hive.openBox(DBService.dbName);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DBService.box.listenable(),
      builder: (context, box, widget) {
        return MaterialApp(
          themeMode: DBService.loadMode() ? ThemeMode.light : ThemeMode.dark,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: const HomePage(),
          routes: {
            HomePage.id: (context) => const HomePage(),
            DetailPage.id:(context)=>const DetailPage(),
          },
        );
      },
    );
  }
}
