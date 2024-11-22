import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserViewModel {
  final UserRepository repository;

  UserViewModel(this.repository);

  // Método para cadastrar um novo usuário, verificando se o e-mail existe na tabela `pessoas`.
  Future<String> registerUser(
      String email, String usuario, String senha) async {
    final emailExists =
        await repository.emailExists(email); // Deve retornar um bool

    if (emailExists) {
      // Certifique-se de que emailExists é bool
      final db = await repository.initDb();
      final result =
          await db.query('pessoas', where: 'email = ?', whereArgs: [email]);
      final idPessoa = result[0]['id'] as int;

      // Verifica se já existe um usuário com idPessoa
      final userAlreadyExists = await repository.userExistsByIdPessoa(idPessoa);
      if (userAlreadyExists) {
        return 'Usuário já está cadastrado!';
      }

      final user = User(usuario: usuario, senha: senha, idPessoa: idPessoa);
      await repository.insertUser(user);

      return 'Usuário cadastrado com sucesso!';
    } else {
      return 'E-mail não encontrado. Procure o administrador.';
    }
  }

  // Método para verificar as credenciais de login
  Future<bool> loginUser(String usuario, String senha) async {
    return await repository.verifyLogin(usuario, senha);
  }
}
