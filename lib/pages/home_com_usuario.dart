import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lista_produtos.dart';

class HomeComUsuario extends StatelessWidget {
  const HomeComUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Oliveira de Carvalho'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  user.email ?? '',
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
