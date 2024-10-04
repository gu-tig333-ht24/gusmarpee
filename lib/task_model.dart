import 'package:flutter/material.dart';
import 'todo_service.dart';

class Task {
  final String id;
  final String title;
  final bool done;
  final bool deleted; // New property to mark if the task is deleted

  Task({
    required this.id,
    required this.title,
    this.done = false,
    this.deleted = false, // Default to not deleted
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      done: json['done'],
      deleted: json['deleted'] ?? false, // Handle if deleted field is not present
    );
  }

  // Method to update done or deleted status
  Task copyWith({String? title, bool? done, bool? deleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      deleted: deleted ?? this.deleted, // Allow updating the deleted status
    );
  }
}

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _filter = 'All'; // Track the current filter ('All', 'Done', 'Deleted')
  final TodoService _todoService = TodoService();

  // Getter for filtered tasks based on the current filter
  List<Task> get tasks {
    if (_filter == 'Done') {
      return _tasks.where((task) => task.done && !task.deleted).toList();
    } else if (_filter == 'Deleted') {
      return _tasks.where((task) => task.deleted).toList();
    }
    return _tasks.where((task) => !task.deleted).toList(); // Show all non-deleted tasks
  }

  bool get isLoading => _isLoading;

  // Fetch tasks from the API
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

  // Set the filter for the tasks ('All', 'Done', 'Deleted')
  void setFilter(String filter) {
    _filter = filter;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Add a new task to the API
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

  // Toggle the task's status (done/undone)
  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(done: !task.done);
    await updateTask(updatedTask);
  }

  // Update a task in the API
  Future<void> updateTask(Task task) async {
    try {
      await _todoService.updateTodo(task.id, task.title, task.done);
      await fetchTodos(); // Refresh the list after updating the task
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Mark a task as deleted instead of removing it
  Future<void> deleteTask(String id) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(deleted: true); // Mark as deleted
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
