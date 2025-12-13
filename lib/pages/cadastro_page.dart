import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final numeroController = TextEditingController();
  final cepController = TextEditingController();
  final cidadeController = TextEditingController();

  bool possuiWhatsapp = true;
  String ufSelecionado = 'SP';
  bool carregando = false;

  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final celularMask = MaskTextInputFormatter(mask: '(##) #####-####');
  final cepMask = MaskTextInputFormatter(mask: '#####-###');

  final estados = [
    'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA',
    'MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN',
    'RS','RO','RR','SC','SP','SE','TO',
  ];

  Future<void> buscarCep(String cep) async {
    if (cep.length < 9) return;

    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['erro'] != true) {
        setState(() {
          ruaController.text = data['logradouro'] ?? '';
          bairroController.text = data['bairro'] ?? '';
          cidadeController.text = data['localidade'] ?? '';
          ufSelecionado = data['uf'] ?? ufSelecionado;
        });
      }
    }
  }

  Future<void> criarConta() async {
    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não conferem')),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      // 1️⃣ Criar usuário no Auth
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      final user = authResponse.user;
      if (user == null) throw 'Erro ao criar usuário';

      // 2️⃣ Inserir dados na tabela usuarios
      await Supabase.instance.client.from('usuarios').insert({
        'id': user.id,
        'nome_completo': nomeController.text,
        'cpf': cpfController.text,
        'email': emailController.text,
        'celular': celularController.text,
        'possui_whatsapp': possuiWhatsapp,
        'rua': ruaController.text,
        'bairro': bairroController.text,
        'numero': numeroController.text,
        'cep': cepController.text,
        'cidade': cidadeController.text,
        'uf': ufSelecionado,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 420,
                child: Column(
                  children: [
                    _campo(nomeController, 'Nome completo', Icons.person),
                    _campo(cpfController, 'CPF', Icons.badge,
                        inputFormatters: [cpfMask]),
                    _campo(emailController, 'Email', Icons.email),
                    _campo(celularController, 'Celular', Icons.phone,
                        inputFormatters: [celularMask]),

                    // WhatsApp (alinhado corretamente)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: possuiWhatsapp,
                            onChanged: (v) =>
                                setState(() => possuiWhatsapp = v ?? false),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Possui WhatsApp',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    _campo(cepController, 'CEP', Icons.mail,
                        inputFormatters: [cepMask],
                        onChanged: buscarCep),
                    _campo(ruaController, 'Rua', Icons.location_on),
                    _campo(bairroController, 'Bairro', Icons.location_city),
                    _campo(numeroController, 'Número', Icons.numbers),
                    _campo(cidadeController, 'Cidade', Icons.location_city),

                    DropdownButtonFormField<String>(
                      initialValue: ufSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'UF',
                        prefixIcon: Icon(Icons.map),
                      ),
                      items: estados
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => ufSelecionado = v!),
                    ),

                    const SizedBox(height: 12),

                    _campo(senhaController, 'Senha', Icons.lock, obscure: true),
                    _campo(confirmarSenhaController, 'Confirmar senha',
                        Icons.lock_outline,
                        obscure: true),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: carregando ? null : criarConta,
                        child: carregando
                            ? const CircularProgressIndicator()
                            : const Text('Criar conta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
    List inputFormatters = const [],
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        inputFormatters: inputFormatters.cast(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
