class Pessoa {
  final int? id; // Permite ser null
  final String nome;
  final String? telefone; // Pode ser null
  final String? email; // Pode ser null
  final String? enderecoAvRua; // Pode ser null
  final String? enderecoNumero; // Pode ser null
  final String? enderecoCep; // Pode ser null
  final String? enderecoCidade; // Pode ser null
  final String? enderecoEstado; // Pode ser null
  final String? bairro; // Novo campo, pode ser null

  Pessoa({
    this.id,
    required this.nome,
    this.telefone,
    this.email,
    this.enderecoAvRua,
    this.enderecoNumero,
    this.enderecoCep,
    this.enderecoCidade,
    this.enderecoEstado,
    this.bairro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'enderecoAvRua': enderecoAvRua,
      'enderecoNumero': enderecoNumero,
      'enderecoCep': enderecoCep,
      'enderecoCidade': enderecoCidade,
      'enderecoEstado': enderecoEstado,
      'bairro': bairro, // Novo campo no Map
    };
  }

  // Método para criar uma instância de Pessoa a partir de um Map
  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      enderecoAvRua: map['enderecoAvRua'],
      enderecoNumero: map['enderecoNumero'],
      enderecoCep: map['enderecoCep'],
      enderecoCidade: map['enderecoCidade'],
      enderecoEstado: map['enderecoEstado'],
      bairro: map['bairro'], // Novo campo no factory
    );
  }
}
