import 'package:flutter/material.dart';

class AdminProdutoPage extends StatelessWidget {
  const AdminProdutoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anunciar novo produto'),
      ),
      body: const Center(
        child: Text(
          'Tela de cadastro de produto\n(em breve)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}