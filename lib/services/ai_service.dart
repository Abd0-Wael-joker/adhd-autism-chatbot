import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  late final GenerativeModel _model;
  static const String _apiKey = 'YOUR_GOOGLE_GEMINI_API_KEY'; // Replace with actual API key

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  Future<String> generateResponse(String userMessage, String? context) async {
    try {
      final systemPrompt = '''
You are a compassionate and supportive chatbot designed specifically for people with ADHD and autism. 
Your role is to:
1. Provide coping strategies and support
2. Help manage tasks and reminders
3. Offer sensory-friendly advice
4. Suggest calming techniques
5. Provide evidence-based strategies

Key guidelines:
- Use clear, simple language
- Avoid sensory overwhelming descriptions
- Break down complex information into smaller parts
- Be patient and non-judgmental
- Suggest professional help when appropriate
- Remember that this is not medical advice

Context: ${context ?? 'General support'}
User message: $userMessage
''';

      final content = [Content.text(systemPrompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'I could not generate a response. Please try again.';
    } catch (e) {
      return 'Sorry, I encountered an error: $e. Please check your API key and internet connection.';
    }
  }

  Future<String> generateCopingStrategy(String situation) async {
    final prompt = '''
A person with ADHD/autism is dealing with: $situation

Please provide:
1. Quick calming techniques (under 2 minutes)
2. Long-term coping strategies
3. Resources or professional help if needed

Keep responses clear, non-overwhelming, and practical.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not generate strategy.';
    } catch (e) {
      return 'Error generating strategy: $e';
    }
  }

  Future<String> generateTaskBreakdown(String task) async {
    final prompt = '''
Help break down this task into smaller, manageable steps for someone with ADHD:
"$task"

Provide:
1. Step-by-step breakdown
2. Time estimate for each step
3. Sensory-friendly environment suggestions
4. Motivation tips

Make it clear and actionable.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not break down task.';
    } catch (e) {
      return 'Error breaking down task: $e';
    }
  }
}