import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Troca isso pela URL do backend
  static const String baseUrl = "http://10.0.2.2:8000/api/v1";

  // Se você estiver usando autenticação JWT
  static String? token;

  // -------------------------------
  // SET TOKEN
  // -------------------------------
  static void setToken(String newToken) {
    token = newToken;
  }

  // -------------------------------
  // HEADERS
  // -------------------------------
  static Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // -------------------------------
  // ANALISAR LINK
  // -------------------------------
  static Future<Map<String, dynamic>> analyzeLink(String url) async {
    final response = await http.post(
      Uri.parse("$baseUrl/links/analyze"),
      headers: _headers(),
      body: jsonEncode({"url": url}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao analisar link: ${response.body}");
    }
  }

  // -------------------------------
  // LISTAR LINKS
  // -------------------------------
  static Future<List<dynamic>> getAnalyses() async {
    final response = await http.get(
      Uri.parse("$baseUrl/links"),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["items"];
    } else {
      throw Exception("Erro ao buscar análises");
    }
  }
}
