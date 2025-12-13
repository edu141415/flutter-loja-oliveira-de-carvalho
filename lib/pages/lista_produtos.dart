import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/produto.dart';
import 'detalhe_produto.dart';
import 'login_page.dart';
import 'cadastro_page.dart'; // ✅ IMPORT DO CADASTRO
import '../widgets/produto_card.dart';

class ListaProdutos extends StatelessWidget {
  ListaProdutos({super.key});

  // 🎨 Cores estilo Newegg
  final Color azulPrincipal = const Color(0xFF0B3C6F);
  final Color azulEscuro = const Color(0xFF0A2F57);

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
    return Scaffold(
      backgroundColor: azulPrincipal,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: azulEscuro,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Loja Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.login, color: Colors.white),
            label: const Text(
              'Entrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CadastroPage()),
              );
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              'Cadastrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),

      // ================= MENU LATERAL =================
      drawer: Drawer(
        backgroundColor: azulEscuro,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: azulPrincipal),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.white),
              title: const Text(
                'Produtos',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text(
                'Categorias',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Categorias em breve')),
                );
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.login, color: Colors.white),
              title: const Text(
                'Entrar / Login',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
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
