import 'package:app_dogs/data/repositories/pessoa_repository.dart';
import 'package:app_dogs/presentation/viewmodels/pessoa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/models/pessoa_model.dart';

class PessoaFormPage extends StatefulWidget {
  const PessoaFormPage({super.key});

  @override
  PessoaFormPageState createState() => PessoaFormPageState();
}

class PessoaFormPageState extends State<PessoaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _enderecoAvRuaController = TextEditingController();
  final _enderecoNumeroController = TextEditingController();
  final _enderecoCepController = TextEditingController();
  final _enderecoCidadeController = TextEditingController();
  final _enderecoEstadoController = TextEditingController();
  final _bairroController =
      TextEditingController(); // Novo controlador para bairro
  final PessoaViewModel _viewModel = PessoaViewModel(PessoaRepository());

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _enderecoAvRuaController.dispose();
    _enderecoNumeroController.dispose();
    _enderecoCepController.dispose();
    _enderecoCidadeController.dispose();
    _enderecoEstadoController.dispose();
    _bairroController.dispose(); // Dispose do controlador bairro
    super.dispose();
  }

  _buscarEndereco(String cep) async {
    if (cep.length != 8) return;

    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (!mounted) return; // Verifica se o widget ainda está montado

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('erro')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CEP não encontrado!')),
            );
          }
          return;
        }

        setState(() {
          _enderecoAvRuaController.text = data['logradouro'] ?? '';
          _bairroController.text =
              data['bairro'] ?? ''; // Atualiza o campo bairro
          _enderecoCidadeController.text = data['localidade'] ?? '';
          _enderecoEstadoController.text = data['uf'] ?? '';
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar o endereço.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro de rede ao buscar o endereço.')),
        );
      }
    }
  }

  Future<void> _saveCliente() async {
    if (_formKey.currentState!.validate()) {
      final cliente = Pessoa(
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        enderecoAvRua: _enderecoAvRuaController.text,
        enderecoNumero: _enderecoNumeroController.text,
        enderecoCep: _enderecoCepController.text,
        enderecoCidade: _enderecoCidadeController.text,
        enderecoEstado: _enderecoEstadoController.text,
        bairro: _bairroController.text, // Inclui o campo bairro
      );

      await _viewModel.addPessoa(cliente);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente adicionado com sucesso!')),
        );
        Navigator.pop(context);
      }
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {TextInputType keyboardType = TextInputType.text,
      Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal.shade700),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade700),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hint;
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Cliente'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Registrar Novo Cliente',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_nomeController, 'Nome', 'Insira o nome'),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _telefoneController,
                        'Telefone',
                        'Insira o telefone',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                          _emailController, 'Email', 'Insira o email',
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _enderecoCepController,
                        'CEP',
                        'Insira o CEP',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.length == 8) _buscarEndereco(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_enderecoAvRuaController,
                          'Endereço (Av/Rua)', 'Insira o endereço'),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _bairroController, // Campo bairro
                        'Bairro',
                        'Insira o bairro',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _enderecoNumeroController,
                        'Número',
                        'Insira o número',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_enderecoCidadeController, 'Cidade',
                          'Insira a cidade'),
                      const SizedBox(height: 20),
                      _buildTextField(_enderecoEstadoController, 'Estado',
                          'Insira o estado'),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _saveCliente,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        icon: const Icon(Icons.save, size: 24),
                        label: const Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
