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
  String? nomeUsuario;
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

      final rawIsAdmin = response['is_admin'];

      debugPrint('IS_ADMIN RAW => $rawIsAdmin (${rawIsAdmin.runtimeType})');

      setState(() {
        nomeUsuario = response['nome_completo'];

        // conversão robusta
        isAdmin = rawIsAdmin == true ||
            rawIsAdmin == 1 ||
            rawIsAdmin == 'true';

        carregando = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
      setState(() {
        nomeUsuario = 'Usuário';
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isAdmin ? const AdminDrawer() : null,

      appBar: AppBar(
        title: const Text('Loja Oliveira de Carvalho'),

        // ☰ BOTÃO DO MENU (OBRIGATÓRIO NO WEB)
        leading: isAdmin
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Menu administrativo',
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              )
            : null,

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
              child: Text(
                nomeUsuario ?? '',
                style: const TextStyle(fontSize: 14),
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
