import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lista_produtos.dart';

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
    carregarNomeUsuario();
  }

  Future<void> carregarNomeUsuario() async {
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
          if (!carregando && nomeUsuario != null)
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
