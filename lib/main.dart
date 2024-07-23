import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/service/category/category_provider.dart';
import 'package:shopping_app/service/product/product_provider.dart';
import 'package:shopping_app/service/stand/stand_provider.dart';

import 'package:shopping_app/view/category_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StandProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CategoryScreen(),
    );
  }
}
