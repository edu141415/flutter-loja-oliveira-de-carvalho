import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/lista_produtos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ozxblhonawtqcswwedgb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96eGJsaG9uYXd0cWNzd3dlZGdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2NDYyMTUsImV4cCI6MjA4MTIyMjIxNX0.anCEzANHaefLuD-pCEsrhp2ohOOCv4TuKJSKrbNHdr0',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ListaProdutos(),
    );
  }
}
