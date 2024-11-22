import 'package:app_dogs/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import '../../viewmodels/user_viewmodel.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmSenhaController = TextEditingController();

  final UserViewModel userViewModel = UserViewModel(UserRepository());

  final _formKey = GlobalKey<FormState>();

  registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = emailController.text;
      final usuario = usuarioController.text;
      final senha = senhaController.text;

      final message = await userViewModel.registerUser(email, usuario, senha);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor:
              message.contains("sucesso") ? Colors.green : Colors.red,
        ));

        if (message.contains("sucesso")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Criar Conta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Por favor, preencha os campos abaixo para se cadastrar.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: emailController,
                  label: 'E-mail',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: usuarioController,
                  label: 'Usuário',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um nome de usuário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: senhaController,
                  label: 'Senha',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: confirmSenhaController,
                  label: 'Redigite a Senha',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value != senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 12.0),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Já tem login? Clique aqui para entrar',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.teal),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}
