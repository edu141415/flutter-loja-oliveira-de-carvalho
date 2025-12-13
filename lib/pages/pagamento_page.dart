import 'package:flutter/material.dart';
import '../models/produto.dart';

class PagamentoPage extends StatelessWidget {
  final Produto produto;

  const PagamentoPage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Valor: R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pagamento via Pix (simulado)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: const Text('Chave Pix: contato@lojademo.com'),
            ),
          ],
        ),
      ),
    );
  }
}
