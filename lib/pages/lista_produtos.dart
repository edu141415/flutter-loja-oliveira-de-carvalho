import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/produto.dart';
import 'detalhe_produto.dart';
import 'login_page.dart';
import 'cadastro_page.dart';
import '../widgets/produto_card.dart';

class ListaProdutos extends StatelessWidget {
  ListaProdutos({super.key});

  // 🎨 Cores
  final Color azulPrincipal = const Color(0xFF0B3C6F);
  final Color azulEscuro = const Color(0xFF0A2F57);

  // 🛒 contador fake (próximo passo vira estado real)
  final int itensCarrinho = 0;

  final List<Produto> produtos = [
    Produto(
      id: '1',
      nome: 'Camiseta',
      preco: 49.90,
      descricao: 'Camiseta confortável, tecido leve e ótimo caimento.',
      imagens: [
        'https://res.cloudinary.com/dghjbuuht/image/upload/v1765588098/cld-sample-5.jpg',
        'https://res.cloudinary.com/dghjbuuht/image/upload/v1765588086/samples/shoe.jpg',
      ],
    ),
    Produto(
      id: '2',
      nome: 'Tênis',
      preco: 199.90,
      descricao: 'Tênis esportivo ideal para caminhada e uso diário.',
      imagens: [
        'https://res.cloudinary.com/dghjbuuht/image/upload/tenis_1.jpg',
        'https://res.cloudinary.com/dghjbuuht/image/upload/tenis_2.jpg',
      ],
    ),
    Produto(
      id: '3',
      nome: 'Boné',
      preco: 39.90,
      descricao: 'Boné ajustável com design moderno.',
      imagens: [
        'https://res.cloudinary.com/dghjbuuht/image/upload/bone_1.jpg',
      ],
    ),
  ];

  void compartilharProduto(Produto produto) {
    Share.share(
      '🔥 ${produto.nome}\n💰 R\$ ${produto.preco.toStringAsFixed(2)}\n\nConfira no app Loja Demo 👇',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final bool logado = user != null;

    // tenta pegar nome, senão usa email
    final String nomeUsuario =
        user?.userMetadata?['name'] ??
        user?.email ??
        '';

    return Scaffold(
      backgroundColor: azulPrincipal,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: azulEscuro,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Loja Demo',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // 👤 Usuário logado
          if (logado)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  nomeUsuario,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

          // 🛒 Carrinho
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Carrinho em breve')),
                  );
                },
              ),
              if (itensCarrinho > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      itensCarrinho.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // 🔐 Login / Cadastro
          if (!logado)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('Entrar',
                  style: TextStyle(color: Colors.white)),
            ),

          if (!logado)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroPage()),
                );
              },
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Cadastrar',
                  style: TextStyle(color: Colors.white)),
            ),

          // 🚪 Logout
          if (logado)
            IconButton(
              tooltip: 'Sair',
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
              },
            ),
        ],
      ),

      // ================= GRID =================
      body: LayoutBuilder(
        builder: (context, constraints) {
          int colunas = 2;
          if (constraints.maxWidth > 900) colunas = 4;
          if (constraints.maxWidth > 1200) colunas = 5;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: produtos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: colunas,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) {
              final produto = produtos[index];
              if (!produto.ativo) return const SizedBox.shrink();

              return ProdutoCard(
                produto: produto,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalheProduto(produto: produto),
                    ),
                  );
                },
                onShare: () => compartilharProduto(produto),
              );
            },
          );
        },
      ),
    );
  }
}
