import 'package:sqflite/sqflite.dart';
import '../../core/database_helper.dart';
import '../models/pessoa_model.dart';

class PessoaRepository {
  Future<void> insertPessoa(Pessoa pessoa) async {
    final db = await DatabaseHelper.initDb();
    await db.insert(
      'pessoas',
      pessoa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pessoa>> getPessoas() async {
    final db = await DatabaseHelper.initDb();
    final List<Map<String, Object?>> pessoaMaps = await db.query('pessoas');
    return pessoaMaps.map((map) {
      return Pessoa(
        id: map['id'] as int?,
        nome: map['nome'] as String,
        telefone: map['telefone'] as String?,
        email: map['email'] as String?,
        enderecoAvRua: map['enderecoAvRua'] as String?,
        enderecoNumero: map['enderecoNumero'] as String?,
        enderecoCep: map['enderecoCep'] as String?,
        enderecoCidade: map['enderecoCidade'] as String?,
        enderecoEstado: map['enderecoEstado'] as String?,
        bairro: map['bairro'] as String?, // Novo campo bairro
      );
    }).toList();
  }

  Future<void> updatePessoa(Pessoa pessoa) async {
    final db = await DatabaseHelper.initDb();
    await db.update(
      'pessoas', // Corrigido para 'pessoas'
      pessoa.toMap(),
      where: 'id = ?',
      whereArgs: [pessoa.id],
    );
  }

  Future<void> deletePessoa(int id) async {
    final db = await DatabaseHelper.initDb();
    await db.delete(
      'pessoas', // Corrigido para 'pessoas'
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
