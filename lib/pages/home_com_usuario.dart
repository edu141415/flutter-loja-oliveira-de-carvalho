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
  String nomeUsuario = '';
  bool carregando = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('nome_completo, is_admin')
          .eq('auth_user_id', user.id)
          .single();

      if (!mounted) return;

      setState(() {
        nomeUsuario = response['nome_completo'] ?? 'Usuário';
        isAdmin = response['is_admin'] == true;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        nomeUsuario = 'Usuário';
        isAdmin = false;
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
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
              // AuthGate reage automaticamente
            },
          ),
        ],
      ),

      // 🛠 Drawer aparece apenas para administradores
      drawer: isAdmin ? const AdminDrawer() : null,

      body: ListaProdutos(),
    );
  }
}