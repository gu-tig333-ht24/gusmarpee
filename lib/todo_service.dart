import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoService {
  static const String apiKey = 'c53d8abd-ce2d-4818-852d-79a1155b0db6';
  static const String baseUrl = 'https://todoapp-api.apps.k8s.gu.se'; 


  Future<List<dynamic>> fetchTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos?key=$apiKey'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load todos');
    }
  }


  Future<List<dynamic>> addTodo(String title) async {
  final response = await http.post(
    Uri.parse('$baseUrl/todos?key=$apiKey'), 
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'done': false,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to add todo');
  }
}



  Future<void> updateTodo(String id, String title, bool done) async {
  final response = await http.put(
    Uri.parse('$baseUrl/todos/$id?key=$apiKey'), 
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'done': done,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update todo');
  }
}

Future<void> deleteTodo(String id) async {
  final response = await http.delete(Uri.parse('$baseUrl/todos/$id?key=$apiKey')); // 

  if (response.statusCode != 200) {
    throw Exception('Failed to delete todo');
  }
}

}
