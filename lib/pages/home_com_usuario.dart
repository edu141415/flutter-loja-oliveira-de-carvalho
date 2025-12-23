import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lista_produtos.dart';
import '../widgets/admin_drawer.dart';

class HomeComUsuario extends StatefulWidget {
  const HomeComUsuario({super.key});

  @override
  State<HomeComUsuario> createState() => _HomeComUsuarioState();
}

class _HomeComUsuarioState extends State<HomeComUsuario> {
  String nomeUsuario = 'Usuário';
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() => carregando = false);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('nome_completo')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      setState(() {
        nomeUsuario = response?['nome_completo'] ?? 'Usuário';
        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔴 DRAWER SEM QUALQUER CONDIÇÃO
      drawer: const AdminDrawer(),

      appBar: AppBar(
        automaticallyImplyLeading: false, // 🔴 IMPORTANTE NO WEB
        title: const Text('Loja Oliveira de Carvalho'),

        // 🔴 BOTÃO DE MENU FORÇADO
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Abrir menu',
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),

        actions: [
          if (carregando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  nomeUsuario,
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