import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/task_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Display Settings', themeProvider),
          _buildDarkModeToggle(themeProvider),
          _buildHighContrastToggle(themeProvider),
          _buildFontSizeSlider(themeProvider),
          const SizedBox(height: 24.0),
          _buildSectionTitle(context, 'Data Management', themeProvider),
          _buildClearHistoryButton(),
          _buildClearTasksButton(),
          _buildClearAllDataButton(),
          const SizedBox(height: 24.0),
          _buildSectionTitle(context, 'About', themeProvider),
          _buildAboutInfo(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    ThemeProvider themeProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: themeProvider.fontSize.toDouble() + 2,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDarkModeToggle(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dark Mode',
            style: TextStyle(fontSize: themeProvider.fontSize.toDouble()),
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleDarkMode(),
          ),
        ],
      ),
    );
  }

  Widget _buildHighContrastToggle(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'High Contrast (Sensory-Friendly)',
            style: TextStyle(fontSize: themeProvider.fontSize.toDouble()),
          ),
          Switch(
            value: themeProvider.highContrast,
            onChanged: (_) => themeProvider.toggleHighContrast(),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSlider(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Font Size: ${themeProvider.fontSize}',
            style: TextStyle(fontSize: themeProvider.fontSize.toDouble()),
          ),
          Slider(
            value: themeProvider.fontSize.toDouble(),
            min: 12,
            max: 24,
            divisions: 12,
            onChanged: (value) => themeProvider.setFontSize(value.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildClearHistoryButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showConfirmDialog(
            'Clear Chat History?',
            'This will delete all your chat messages.',
            () => context.read<ChatProvider>().clearHistory(),
          ),
          child: const Text('Clear Chat History'),
        ),
      ),
    );
  }

  Widget _buildClearTasksButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showConfirmDialog(
            'Clear All Tasks?',
            'This will delete all your tasks.',
            () => context.read<TaskProvider>().clearAllTasks(),
          ),
          child: const Text('Clear All Tasks'),
        ),
      ),
    );
  }

  Widget _buildClearAllDataButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showConfirmDialog(
            'Clear All Data?',
            'This will delete all your data including chat history and tasks. This action cannot be undone.',
            () async {
              await DatabaseService().database.then((db) {
                db.execute('DELETE FROM chat_messages');
                db.execute('DELETE FROM tasks');
              });
              context.read<ChatProvider>().clearHistory();
              context.read<TaskProvider>().clearAllTasks();
            },
          ),
          icon: const Icon(Icons.warning),
          label: const Text('Clear All Data'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAboutInfo(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADHD & Autism Chatbot',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: themeProvider.fontSize.toDouble() + 1,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Version 1.0.0\n\nA compassionate support app designed for people with ADHD and autism. This app is not a replacement for professional mental health care.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: themeProvider.fontSize.toDouble() - 2,
                ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}