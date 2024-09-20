import 'package:flutter/material.dart';

class Task {
  const Task({required this.name, this.isDone = false});
  final String name;
  final bool isDone;
}

class TaskModel extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(name: 'Write a book'),
    Task(name: 'Do homework'),
    Task(name: 'Tidy room'),
    Task(name: 'Watch TV'),
    Task(name: 'Nap'),
    Task(name: 'Shop groceries'),
    Task(name: 'Text friend'),
  ];

  final List<Task> _deletedTasks = [];
  final Set<Task> _completedTasks = {};

  String _filter = 'All'; // 'All', 'Done', 'Deleted'

  List<Task> get filteredTasks {
    if (_filter == 'All') {
      return _tasks;
    } else if (_filter == 'Done') {
      return _tasks.where((task) => _completedTasks.contains(task)).toList();
    } else if (_filter == 'Deleted') {
      return _deletedTasks;
    }
    return _tasks;
  }

  Set<Task> get completedTasks => _completedTasks;

  void addTask(String name) {
    _tasks.add(Task(name: name));
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    _deletedTasks.add(task);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    if (_completedTasks.contains(task)) {
      _completedTasks.remove(task);
    } else {
      _completedTasks.add(task);
    }
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  String get filter => _filter;
}
