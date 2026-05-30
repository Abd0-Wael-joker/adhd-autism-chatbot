import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/ai_service.dart';

class CopingStrategiesScreen extends StatefulWidget {
  const CopingStrategiesScreen({Key? key}) : super(key: key);

  @override
  State<CopingStrategiesScreen> createState() => _CopingStrategiesScreenState();
}

class _CopingStrategiesScreenState extends State<CopingStrategiesScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _situationController = TextEditingController();
  String? _strategy;
  bool _isLoading = false;

  final List<String> _presetStrategies = [
    'Feeling overwhelmed',
    'Difficulty concentrating',
    'Social anxiety',
    'Sensory overload',
    'Executive dysfunction',
    'Anxiety or panic',
  ];

  @override
  void dispose() {
    _situationController.dispose();
    super.dispose();
  }

  Future<void> _generateStrategy(String situation) async {
    setState(() => _isLoading = true);
    try {
      final strategy = await _aiService.generateCopingStrategy(situation);
      setState(() => _strategy = strategy);
    } catch (e) {
      setState(() => _strategy = 'Error generating strategy. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you dealing with?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: themeProvider.fontSize.toDouble() + 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _presetStrategies
                .map(
                  (strategy) => ActionChip(
                    label: Text(
                      strategy,
                      style: TextStyle(
                        fontSize: themeProvider.fontSize.toDouble(),
                      ),
                    ),
                    onPressed: () => _generateStrategy(strategy),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Or describe your situation:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: themeProvider.fontSize.toDouble(),
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _situationController,
            maxLines: 4,
            style: TextStyle(fontSize: themeProvider.fontSize.toDouble()),
            decoration: InputDecoration(
              hintText: 'Describe what you\'re experiencing...',
              hintStyle: TextStyle(
                fontSize: themeProvider.fontSize.toDouble(),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading || _situationController.text.isEmpty
                  ? null
                  : () => _generateStrategy(_situationController.text),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Get Strategy',
                      style: TextStyle(
                        fontSize: themeProvider.fontSize.toDouble(),
                      ),
                    ),
            ),
          ),
          if (_strategy != null) ...[const SizedBox(height: 24.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue),
              ),
              child: SelectableText(
                _strategy!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: themeProvider.fontSize.toDouble(),
                      height: 1.6,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}