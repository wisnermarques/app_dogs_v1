import 'package:flutter/material.dart';

import '../../../../data/models/pessoa_model.dart';

class HeaderWidget extends StatelessWidget {
  final Pessoa pessoa;

  const HeaderWidget({super.key, required this.pessoa});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.teal.shade200,
          child: Text(
            pessoa.nome[0], // Primeira letra do nome
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            pessoa.nome,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
