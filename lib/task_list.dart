import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_model.dart';
import 'to_do_item.dart';
import 'add_task_page.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch todos when the widget is built
    Provider.of<TaskModel>(context, listen: false).fetchTodos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TIG 333 To Do'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              Provider.of<TaskModel>(context, listen: false).setFilter(result); // Set the filter in TaskModel
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('All'),
              ),
              const PopupMenuItem<String>(
                value: 'Done',
                child: Text('Done'),
              ),
              const PopupMenuItem<String>(
                value: 'Deleted',
                child: Text('Deleted'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<TaskModel>(
        builder: (context, taskModel, child) {
          if (taskModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (taskModel.tasks.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: taskModel.tasks.length,
            itemBuilder: (context, index) {
              final task = taskModel.tasks[index];
              return ToDoItem(
                task: task,
                isDone: task.done,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
