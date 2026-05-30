import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_dialog.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final taskProvider = context.watch<TaskProvider>();

    final displayTasks = _showCompleted 
        ? taskProvider.completedTasks 
        : taskProvider.incompleteTasks;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showCompleted ? 'Completed Tasks' : 'Active Tasks',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: themeProvider.fontSize.toDouble() + 2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              FloatingActionButton(
                mini: true,
                onPressed: () => _showAddTaskDialog(),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: displayTasks.isEmpty
              ? Center(
                  child: Text(
                    _showCompleted
                        ? 'No completed tasks yet!'
                        : 'No active tasks. Add one to get started!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: themeProvider.fontSize.toDouble(),
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: displayTasks.length,
                  itemBuilder: (context, index) {
                    final task = displayTasks[index];
                    return TaskCard(
                      task: task,
                      onToggle: () =>
                          taskProvider.toggleTaskCompletion(task.id),
                      onDelete: () => taskProvider.deleteTask(task.id),
                      fontSize: themeProvider.fontSize.toDouble(),
                    );
                  },
                ),
        ),
        if (_showCompleted == false)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilterChip(
              label: const Text('Show Completed'),
              onSelected: (_) {
                setState(() => _showCompleted = true);
              },
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilterChip(
              label: const Text('Show Active'),
              onSelected: (_) {
                setState(() => _showCompleted = false);
              },
            ),
          ),
      ],
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          context.read<TaskProvider>().addTask(task);
        },
      ),
    );
  }
}