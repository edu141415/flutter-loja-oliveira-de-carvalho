import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoCard extends StatefulWidget {
  final Produto produto;
  final VoidCallback onTap;
  final VoidCallback onShare;

  const ProdutoCard({
    super.key,
    required this.produto,
    required this.onTap,
    required this.onShare,
  });

  @override
  State<ProdutoCard> createState() => _ProdutoCardState();
}

class _ProdutoCardState extends State<ProdutoCard> {
  late final PageController _pageController;
  int paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _proximaImagem() {
    if (paginaAtual < widget.produto.imagens.length - 1) {
      _pageController.animateToPage(
        paginaAtual + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _imagemAnterior() {
    if (paginaAtual > 0) {
      _pageController.animateToPage(
        paginaAtual - 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagens = widget.produto.imagens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4EB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= IMAGEM =================
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imagens.length,
                      onPageChanged: (index) {
                        setState(() => paginaAtual = index);
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.network(
                            imagens[index],
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // ⬅️ SETA ESQUERDA
                    if (imagens.length > 1 && paginaAtual > 0)
                      Positioned(
                        left: 4,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.chevron_left, size: 34),
                            onPressed: _imagemAnterior,
                          ),
                        ),
                      ),

                    // ➡️ SETA DIREITA
                    if (imagens.length > 1 &&
                        paginaAtual < imagens.length - 1)
                      Positioned(
                        right: 4,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.chevron_right, size: 34),
                            onPressed: _proximaImagem,
                          ),
                        ),
                      ),

                    // 🔴 DESCONTO
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '22%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= TEXTO =================
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.produto.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.orange),
                        Icon(Icons.star, size: 14, color: Colors.orange),
                        Icon(Icons.star, size: 14, color: Colors.orange),
                        Icon(Icons.star, size: 14, color: Colors.orange),
                        Icon(Icons.star, size: 14, color: Colors.orange),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: widget.onShare,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
