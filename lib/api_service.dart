import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:8001/api/entries/";

// POST new entry
Future<void> addEntryToApi(String content) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"content": content}),
  );

  if (response.statusCode != 201) {
    throw Exception("Failed to add entry");
  }
}

// GET entries
Future<List<dynamic>> fetchEntries() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load entries");
  }
}