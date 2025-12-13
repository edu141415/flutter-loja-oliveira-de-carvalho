class Produto {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final List<String> imagens;
  final bool ativo;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagens,
    this.ativo = true,
  });
}
