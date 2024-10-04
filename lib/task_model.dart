import 'package:flutter/material.dart';
import 'todo_service.dart';

class Task {
  final String id;
  final String title;
  final bool done;
  final bool deleted; 

  Task({
    required this.id,
    required this.title,
    this.done = false,
    this.deleted = false, 
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      done: json['done'],
      deleted: json['deleted'] ?? false, 
    );
  }


  Task copyWith({String? title, bool? done, bool? deleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      deleted: deleted ?? this.deleted, 
    );
  }
}

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _filter = 'All'; 
  final TodoService _todoService = TodoService();


  List<Task> get tasks {
    if (_filter == 'Done') {
      return _tasks.where((task) => task.done && !task.deleted).toList();
    } else if (_filter == 'Deleted') {
      return _tasks.where((task) => task.deleted).toList();
    }
    return _tasks.where((task) => !task.deleted).toList(); 
  }

  bool get isLoading => _isLoading;


  Future<void> fetchTodos() async {
    try {
      _isLoading = true;
      notifyListeners();

      final todos = await _todoService.fetchTodos();
      _tasks = todos.map<Task>((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching todos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void setFilter(String filter) {
    _filter = filter;
    notifyListeners(); 
  }

  Future<void> addTask(String title) async {
    try {
      _isLoading = true;
      notifyListeners();

      final todos = await _todoService.addTodo(title);
      _tasks = todos.map<Task>((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print('Error adding task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(done: !task.done);
    await updateTask(updatedTask);
  }


  Future<void> updateTask(Task task) async {
    try {
      await _todoService.updateTodo(task.id, task.title, task.done);
      await fetchTodos(); 
    } catch (e) {
      print('Error updating task: $e');
    }
  }

 
  Future<void> deleteTask(String id) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(deleted: true); 
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
