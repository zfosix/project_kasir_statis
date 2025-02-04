import 'package:flutter/material.dart';
import 'cashier_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kasir', // Judul lebih relevan
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Mengaktifkan Material 3
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const CashierPage(),
    );
  }
}