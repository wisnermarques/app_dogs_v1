import '../../data/models/pessoa_model.dart';
import '../../data/repositories/pessoa_repository.dart';

class PessoaViewModel {
  final PessoaRepository repository;

  PessoaViewModel(this.repository);

  Future<void> addPessoa(Pessoa pessoa) async {
    await repository.insertPessoa(pessoa);
  }

  Future<List<Pessoa>> getPessoas() async {
    return await repository.getPessoas();
  }

  Future<void> updatePessoa(Pessoa pessoa) async {
    await repository.updatePessoa(pessoa);
  }

  Future<void> deletePessoa(int? id) async {
    if (id != null) {
      await repository.deletePessoa(id);
    }
  }
}
