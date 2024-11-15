import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> initDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) async {
        // Criação da tabela dogs
        await db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );

        // Criação da tabela pessoas
        await db.execute('CREATE TABLE pessoas ('
            'id INTEGER PRIMARY KEY, '
            'nome TEXT NOT NULL, '
            'telefone TEXT, '
            'email TEXT, '
            'enderecoAvRua TEXT, '
            'enderecoNumero TEXT, '
            'enderecoCep TEXT, '
            'enderecoCidade TEXT, '
            'enderecoEstado TEXT'
            ');');

        // Criação da tabela login com chave estrangeira para a tabela pessoas
        await db.execute('CREATE TABLE login ('
            'id INTEGER PRIMARY KEY, '
            'usuario TEXT NOT NULL UNIQUE, '
            'senha TEXT NOT NULL, '
            'id_pessoa INTEGER NOT NULL UNIQUE, '
            'FOREIGN KEY (id_pessoa) REFERENCES pessoas(id)'
            ');');
      },
      version: 3, // Atualize a versão para 3
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE pessoas ADD COLUMN bairro TEXT;',
          );
        }
        if (oldVersion < 3) {
          await db.execute('CREATE TABLE login ('
              'id INTEGER PRIMARY KEY, '
              'usuario TEXT NOT NULL UNIQUE, '
              'senha TEXT NOT NULL, '
              'id_pessoa INTEGER NOT NULL UNIQUE, '
              'FOREIGN KEY (id_pessoa) REFERENCES pessoas(id)'
              ');');
        }
      },
    );
  }
}
