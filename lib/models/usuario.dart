class Usuario {
  final String id;
  final String nomeCompleto;
  final String email;
  final bool isAdmin;
  final bool ativo;

  Usuario({
    required this.id,
    required this.nomeCompleto,
    required this.email,
    required this.isAdmin,
    required this.ativo,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['auth_user_id'] as String,
      nomeCompleto: map['nome_completo'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['is_admin'] ?? false,
      ativo: map['ativo'] ?? true,
    );
  }
}