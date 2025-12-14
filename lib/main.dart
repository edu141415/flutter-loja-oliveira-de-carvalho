import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// 🔐 Decide automaticamente Login ou App
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        if (session == null) {
          return const LoginPage();
        }

        return const HomeComUsuario();
      },
    );
  }
}

/// 🏠 Tela principal com usuário logado
class HomeComUsuario extends StatefulWidget {
  const HomeComUsuario({super.key});

  @override
  State<HomeComUsuario> createState() => _HomeComUsuarioState();
}

class _HomeComUsuarioState extends State<HomeComUsuario> {
  String? nomeUsuario;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('nome_completo')
          .eq('auth_user_id', user.id)
          .single();

      setState(() {
        nomeUsuario = response['nome_completo'];
        carregando = false;
      });
    } catch (e) {
      // fallback seguro
      setState(() {
        nomeUsuario = user.email;
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Oliveira de Carvalho'),
        actions: [
          if (carregando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (nomeUsuario != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  nomeUsuario!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: ListaProdutos(),
    );
  }
}
