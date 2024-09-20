import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_model.dart';

class ToDoItem extends StatelessWidget {
  final Task task;
  final bool isDone;

  const ToDoItem({
    Key? key,
    required this.task,
    required this.isDone,
  }) : super(key: key);

  Color _getColor(BuildContext context) {
    return isDone ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!isDone) return null;
    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Provider.of<TaskModel>(context, listen: false).toggleTaskStatus(task);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(task.name[0]),
      ),
      title: Text(
        task.name,
        style: _getTextStyle(context),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.clear_outlined),
        onPressed: () {
          Provider.of<TaskModel>(context, listen: false).deleteTask(task);
        },
      ),
    );
  }
}
