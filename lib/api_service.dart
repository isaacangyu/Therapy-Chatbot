import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:8001/api/entries/";

// POST new entry (now uses token)
Future<void> addEntryToApi(String content, String token) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Token $token",
    },
    body: jsonEncode({"content": content}),
  );

  if (response.statusCode != 201) {
    throw Exception("Failed to add entry: ${response.body}");
  }
}

// GET entries (also uses token)
Future<List<dynamic>> fetchEntries(String token) async {
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      "Authorization": "Token $token",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load entries: ${response.body}");
  }
}