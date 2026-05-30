import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final AIService _aiService = AIService();
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatProvider() {
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      _messages.clear();
      final history = await _dbService.getChatHistory();
      _messages.addAll(history.reversed);
      notifyListeners();
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Future<void> sendMessage(String userMessage) async {
    // Add user message
    final userMsg = ChatMessage(
      content: userMessage,
      isUser: true,
    );
    _messages.insert(0, userMsg);
    await _dbService.saveChatMessage(userMsg);
    notifyListeners();

    // Get AI response
    _isLoading = true;
    notifyListeners();

    try {
      final aiResponse = await _aiService.generateResponse(
        userMessage,
        'General support for ADHD and autism',
      );
      final botMsg = ChatMessage(
        content: aiResponse,
        isUser: false,
        category: _categorizeMessage(userMessage),
      );
      _messages.insert(0, botMsg);
      await _dbService.saveChatMessage(botMsg);
    } catch (e) {
      final errorMsg = ChatMessage(
        content: 'Sorry, I could not process your message. Please try again.',
        isUser: false,
      );
      _messages.insert(0, errorMsg);
      await _dbService.saveChatMessage(errorMsg);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _categorizeMessage(String message) {
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('coping') || lowerMessage.contains('stress')) {
      return 'coping_strategy';
    }
    if (lowerMessage.contains('remind') || lowerMessage.contains('task')) {
      return 'reminder';
    }
    return null;
  }

  Future<void> clearHistory() async {
    _messages.clear();
    await _dbService.clearChatHistory();
    notifyListeners();
  }
}