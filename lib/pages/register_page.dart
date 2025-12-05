import 'package:buskei/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0057FF),
              Color.fromARGB(255, 71, 121, 221),
            ],
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Busquei",
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  width: 380,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      CustomInput(
                        hint: "Nome",
                        controller: nomeController,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      CustomInput(
                        hint: "Email",
                        controller: emailController,
                      ),
                      
                      const SizedBox(height: 12),

                      CustomInput(
                        hint: "Senha",
                        controller: senhaController,
                        obscure: true,
                      ),
                      const SizedBox(height: 20),

                      CustomButton(
                        text: "Cadastrar",
                        onPressed: () async {
                          final success = await controller.register(
                            nomeController.text,
                            emailController.text,
                            senhaController.text,
                          );

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Usuário criado com sucesso!")),
                            );
                            Navigator.pushNamed(context, "/login");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Erro ao criar usuário")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
