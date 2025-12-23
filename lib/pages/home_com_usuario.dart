import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lista_produtos.dart';

// páginas admin
import '../pages/admin/admin_home_page.dart';
import '../pages/admin/admin_produto_page.dart';
import '../pages/admin/admin_usuarios_page.dart';

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
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
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
    } catch (_) {
      setState(() {
        nomeUsuario = 'Usuário';
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
          // 🔹 MENU ADMIN FUNCIONAL NO WEB
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'painel':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminHomePage()),
                  );
                  break;

                case 'produto':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminProdutoPage()),
                  );
                  break;

                case 'usuarios':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminUsuariosPage()),
                  );
                  break;

                case 'logout':
                  Supabase.instance.client.auth.signOut();
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'painel',
                child: Text('Painel administrativo'),
              ),
              PopupMenuItem(
                value: 'produto',
                child: Text('Anunciar produto'),
              ),
              PopupMenuItem(
                value: 'usuarios',
                child: Text('Usuários'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
          ),

          if (carregando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
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
                  nomeUsuario ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
        ],
      ),

      body: ListaProdutos(),
    );
  }
}