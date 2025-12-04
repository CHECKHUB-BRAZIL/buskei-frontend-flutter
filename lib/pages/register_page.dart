import 'package:buskei/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  final controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Criar conta")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            SizedBox(height: 12),

            TextField(
              controller: emailController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Senha"),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final success = await controller.register(
                  nomeController.text,
                  emailController.text,
                  senhaController.text,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Usuário criado com sucesso!")),
                  );

                  Navigator.pushNamed(context, "/login");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao criar usuário")),
                  );
                }
              },
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
