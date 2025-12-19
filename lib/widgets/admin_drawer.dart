import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// IMPORTS CORRETOS
import 'package:flutter_application_1/pages/admin/admin_home_page.dart';
import 'package:flutter_application_1/pages/admin/admin_produto_page.dart';
import 'package:flutter_application_1/pages/admin/admin_usuarios_page.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'Administrador',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.admin_panel_settings, size: 32),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Painel'),
              onTap: () {
                Navigator.pop(context); // 🔑 fecha drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminHomePage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Anunciar novo produto'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProdutoPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Usuários'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminUsuariosPage(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
