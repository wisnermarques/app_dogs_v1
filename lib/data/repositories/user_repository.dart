import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:path/path.dart';

class UserRepository {
  Future<Database> initDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      version: 3,
    );
  }

  Future<bool> emailExists(String email) async {
    final db = await initDb();
    final result =
        await db.query('pessoas', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }

  Future<bool> userExistsByIdPessoa(int idPessoa) async {
    final db = await initDb();
    final result =
        await db.query('login', where: 'id_pessoa = ?', whereArgs: [idPessoa]);
    return result.isNotEmpty;
  }

  insertUser(User user) async {
    final db = await initDb();
    final encryptedPassword =
        sha256.convert(utf8.encode(user.senha)).toString();
    await db.insert('login', user.toMap()..['senha'] = encryptedPassword);
  }

  Future<bool> verifyLogin(String usuario, String senha) async {
    final db = await initDb();
    final encryptedPassword = sha256.convert(utf8.encode(senha)).toString();
    final result = await db.query('login',
        where: 'usuario = ? AND senha = ?',
        whereArgs: [usuario, encryptedPassword]);
    return result.isNotEmpty;
  }
}
