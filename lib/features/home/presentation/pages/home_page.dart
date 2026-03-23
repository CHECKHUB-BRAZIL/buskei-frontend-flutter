import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController boletoController = TextEditingController();

  String? result;
  List<String> reasons = [];

  void checkLink() {
    final text = linkController.text;
    if (text.isEmpty) return;

    setState(() {
      result = "🔴 Alto risco";
      reasons = ["Domínio suspeito", "Não usa HTTPS"];
    });
  }

  void checkBoleto() {
    final text = boletoController.text;
    if (text.isEmpty) return;

    setState(() {
      result = "🟡 Suspeito";
      reasons = ["Banco desconhecido", "Formato inválido"];
    });
  }

  @override
  void dispose() {
    linkController.dispose();
    boletoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0057FF), Color(0xFF003FCC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Busquei',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Evite golpes verificando links, QR Codes e boletos.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // CONTAINER
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ListView(
                      children: [
                        // 🔗 LINK
                        _sectionTitle("Verificar link"),
                        const SizedBox(height: 10),

                        TextField(
                          controller: linkController,
                          decoration:
                              _inputDecoration("Cole o link aqui..."),
                        ),

                        const SizedBox(height: 12),

                        _primaryButton(
                          text: "Verificar link",
                          onTap: checkLink,
                        ),

                        const SizedBox(height: 24),

                        _divider(),

                        const SizedBox(height: 24),

                        // 📷 QR
                        _sectionTitle("Escanear QR Code"),
                        const SizedBox(height: 12),

                        _secondaryButton(
                          text: "Abrir câmera",
                          icon: Icons.qr_code_scanner,
                          onTap: () {},
                        ),

                        const SizedBox(height: 24),

                        _divider(),

                        const SizedBox(height: 24),

                        // 💸 BOLETO
                        _sectionTitle("Verificar boleto"),
                        const SizedBox(height: 10),

                        TextField(
                          controller: boletoController,
                          decoration: _inputDecoration(
                              "Cole a linha digitável do boleto..."),
                        ),

                        const SizedBox(height: 12),

                        _primaryButton(
                          text: "Verificar boleto",
                          onTap: checkBoleto,
                        ),

                        const SizedBox(height: 24),

                        if (result != null) _resultCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // COMPONENTES

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0057FF),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("OU"),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _resultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result!,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...reasons.map((r) => Text("• $r")),
        ],
      ),
    );
  }
}
