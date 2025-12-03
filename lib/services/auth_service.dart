import 'package:buskei/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "";

  Future<UserLoginResponse?> login(String email, String senha) async{
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senha}),
    );

    if (response.statusCode == 200){
      return UserLoginResponse.fromJson(jsonDecode(response.body));
    }

    return null;
  } 
}
