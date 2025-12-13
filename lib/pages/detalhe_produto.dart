import 'package:flutter/material.dart';
import '../models/produto.dart';
import 'pagamento_page.dart';

class DetalheProduto extends StatelessWidget {
  final Produto produto;

  const DetalheProduto({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Preço: R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Comprar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PagamentoPage(produto: produto),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
