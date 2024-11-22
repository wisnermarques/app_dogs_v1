class User {
  final int? id;
  final String usuario;
  final String senha;
  final int idPessoa;

  User(
      {this.id,
      required this.usuario,
      required this.senha,
      required this.idPessoa});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'senha': senha,
      'id_pessoa': idPessoa,
    };
  }
}
