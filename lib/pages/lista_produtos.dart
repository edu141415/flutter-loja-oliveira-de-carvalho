import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/produto.dart';
import 'detalhe_produto.dart';
import '../widgets/produto_card.dart';

class ListaProdutos extends StatelessWidget {
  ListaProdutos({super.key});

  final Color azulPrincipal = const Color(0xFF0B3C6F);

  final List<Produto> produtos = [
    Produto(
      id: '1',
      nome: 'Camiseta',
      preco: 49.90,
      descricao: 'Camiseta confortável, tecido leve e ótimo caimento.',
      imagens: [
        'https://res.cloudinary.com/dghjbuuht/image/upload/v1765588098/cld-sample-5.jpg',
      ],
    ),
    Produto(
      id: '2',
      nome: 'Tênis',
      preco: 199.90,
      descricao: 'Tênis esportivo ideal para caminhada e uso diário.',
      imagens: [],
    ),
    Produto(
      id: '3',
      nome: 'Boné',
      preco: 39.90,
      descricao: 'Boné ajustável com design moderno.',
      imagens: [],
    ),
  ];

  void compartilharProduto(Produto produto) {
    Share.share(
      '🔥 ${produto.nome}\n'
      '💰 R\$ ${produto.preco.toStringAsFixed(2)}\n\n'
      'Confira no app Loja Oliveira de Carvalho 👇',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: azulPrincipal,
      child: LayoutBuilder(
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
