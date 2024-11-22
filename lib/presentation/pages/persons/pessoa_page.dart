import 'package:app_dogs/data/repositories/pessoa_repository.dart';
import 'package:app_dogs/presentation/pages/persons/pessoa_form_page.dart';
import 'package:app_dogs/presentation/viewmodels/pessoa_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../../data/models/pessoa_model.dart';
import 'pessoa_details_page.dart';

class PessoaPage extends StatefulWidget {
  const PessoaPage({super.key});

  @override
  PessoaPageState createState() => PessoaPageState();
}

class PessoaPageState extends State<PessoaPage> {
  final PessoaViewModel _viewModel = PessoaViewModel(PessoaRepository());
  List<Pessoa> _clientes = [];
  Pessoa? _lastDeletedCliente;
  bool _isLoading = true; // Variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    _clientes = await _viewModel.getPessoas();

    if (mounted) {
      setState(() {
        _isLoading = false; // Finaliza o carregamento
      });
    }
  }

  Future<void> _deleteCliente(Pessoa cliente) async {
    await _viewModel.deletePessoa(cliente.id!);
    _lastDeletedCliente = cliente;

    final snackBar = SnackBar(
      content: Text('${cliente.nome} excluído'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          if (_lastDeletedCliente != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Exclusão de ${_lastDeletedCliente!.nome} desfeita'),
            ));
            _viewModel.addPessoa(_lastDeletedCliente!);
            setState(() {
              _clientes.add(_lastDeletedCliente!);
              _lastDeletedCliente = null;
            });
          }
        },
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    await _loadClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading // Condição para exibir o indicador de carregamento
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _clientes.isEmpty
                ? const Center(child: Text('Nenhum cliente disponível.'))
                : ListView.builder(
                    itemCount: _clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = _clientes[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Bordas arredondadas
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade200,
                            child: Text(
                              cliente.nome[0], // Primeira letra do nome
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            cliente.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Telefone: ${cliente.telefone ?? "N/A"}'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PessoaDetailsPage(pessoa: cliente),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Mais detalhes',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () {
                                  // Navegar para a página de edição se necessário
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteCliente(cliente);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PessoaFormPage()),
          ).then((_) => _loadClientes());
        },
        backgroundColor: Colors.teal,
        tooltip: 'Adicionar Cliente',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
