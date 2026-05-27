import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/analyze_link_response_model.dart';
import '../models/boleto_validation_response_model.dart';
import '../models/qrcode_response_model.dart';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8000/api/v1';

  static String? token;

  // ==========================================================
  // TOKEN
  // ==========================================================

  static void setToken(String newToken) {
    token = newToken;
  }

  // ==========================================================
  // HEADERS
  // ==========================================================

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',

      if (token != null)
        'Authorization': 'Bearer $token',
    };
  }

  // ==========================================================
  // ANALISAR LINK
  // ==========================================================

  static Future<AnalyzeLinkResponseModel>
  analyzeLink(String url) async {
    final response = await http.post(
      Uri.parse('$baseUrl/links/analyze'),

      headers: _headers(),

      body: jsonEncode({
        'url': url,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return AnalyzeLinkResponseModel.fromJson(
        data,
      );
    }

    throw Exception(
      'Erro ao analisar link: ${response.body}',
    );
  }

  // ==========================================================
  // VALIDAR BOLETO
  // ==========================================================

  static Future<BoletoValidationResponseModel>
  validateBoleto(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/boletos/validate'),

      headers: _headers(),

      body: jsonEncode({
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return BoletoValidationResponseModel.fromJson(
        data,
      );
    }

    throw Exception(
      'Erro ao validar boleto: ${response.body}',
    );
  }

  // ==========================================================
  // ANALISAR QRCODE
  // ==========================================================

  static Future<QRCodeResponseModel>
  validateQRCode(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/qrcode/analyze'),

      headers: _headers(),

      body: jsonEncode({
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return QRCodeResponseModel.fromJson(
        data,
      );
    }

    throw Exception(
      'Erro ao analisar QRCode: ${response.body}',
    );
  }
}
