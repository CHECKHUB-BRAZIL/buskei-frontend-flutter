import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

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
                        hint: "Email",
                        controller: emailController,
                      ),

                      const SizedBox(height: 18),

                      CustomInput(
                        hint: "Senha",
                        controller: senhaController,
                        obscure: true,
                      ),

                      const SizedBox(height: 28),

                      CustomButton(
                        text: "Cadastrar",
                        onPressed: () {
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text("ou",
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 55,
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icon/google.svg",
                                  width: 40,
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 55,
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1877F2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Icon(Icons.facebook, size: 40, color: Colors.white),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 55,
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0A66C2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/icon/linkedin.png",
                                  width: 48,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ainda não tem uma conta? ",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Color(0xFF1B1E28),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              "Registrar-se",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0057FF),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Esqueceu seu senha? ",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Color(0xFF1B1E28),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              "Recuperar",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0057FF),
                              )
                            ),
                          )
                        ],
                      )
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
