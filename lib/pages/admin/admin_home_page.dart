import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Administração',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 📦 PRODUTOS
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Anunciar novo produto'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-produtos');
              },
            ),

            // 👥 USUÁRIOS
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manutenção de usuários'),
              onTap: () {
                Navigator.pushNamed(context, '/admin-usuarios');
              },
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          'Bem-vindo ao Painel Administrativo',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}