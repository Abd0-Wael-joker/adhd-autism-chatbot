# ADHD & Autism Chatbot Flutter Application

A compassionate, sensory-friendly chatbot application designed to support individuals with ADHD and autism spectrum disorder. The app provides AI-powered support, task management, coping strategies, and a sensory-optimized interface.

## Features

✨ **Core Features:**
- 💬 **AI-Powered Chat** - Talk to an intelligent chatbot powered by Google Gemini API
- 📋 **Task Management** - Create, organize, and track tasks with reminders
- 💡 **Coping Strategies** - Get personalized strategies for common challenges
- 🎯 **Executive Function Support** - Help breaking down complex tasks
- 📞 **Resource Connections** - Links to professional help when needed

🎨 **Sensory-Friendly Design:**
- Minimal animations and transitions
- High contrast color schemes
- Clear, dyslexia-friendly fonts (OpenDyslexic)
- Adjustable font sizes
- Dark mode support
- No overwhelming visuals

🛠️ **Technical Features:**
- Local data persistence with SQLite
- Google Gemini AI integration
- State management with Provider
- Offline support capabilities
- User preference storage

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code
- Google Gemini API key

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Abd0-Wael-joker/adhd-autism-chatbot.git
   cd adhd-autism-chatbot
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Setup Google Gemini API:**
   - Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Replace `YOUR_GOOGLE_GEMINI_API_KEY` in `lib/services/ai_service.dart` with your actual API key

4. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── chat_message.dart    # Chat message model
│   └── task.dart            # Task model
├── screens/
│   ├── home_screen.dart     # Main navigation
│   ├── chat_screen.dart     # Chat interface
│   ├── tasks_screen.dart    # Task management
│   ├── coping_strategies_screen.dart  # Strategy recommendations
│   └── settings_screen.dart # User preferences
├── providers/
│   ├── theme_provider.dart  # Theme and accessibility settings
│   ├── chat_provider.dart   # Chat state management
│   └── task_provider.dart   # Task state management
├── services/
│   ├── ai_service.dart      # Google Gemini integration
│   └── database_service.dart # SQLite database management
└── widgets/
    ├── chat_bubble.dart     # Chat message display
    ├── task_card.dart       # Task display
    └── add_task_dialog.dart # Add task dialog
```

## Configuration

### API Key Setup
1. Open `lib/services/ai_service.dart`
2. Replace `YOUR_GOOGLE_GEMINI_API_KEY` with your actual Google Gemini API key
3. Save the file

### Environment Variables (Optional)
Create a `.env` file in the root directory:
```
GOOGLE_GEMINI_API_KEY=your_api_key_here
```

## Usage

### Chat Screen
- Type your message in the text field
- Receive AI-powered responses tailored for ADHD/autism support
- View your complete chat history

### Tasks Screen
- Click to add new tasks
- Set due dates and priority levels
- Track task completion
- Filter between active and completed tasks

### Coping Strategies
- Choose from preset situations or describe your own
- Receive personalized coping strategies and techniques
- Get quick calming techniques and long-term strategies

### Settings
- Adjust theme and accessibility options
- Modify font size
- Toggle high contrast mode
- Manage your data

## Accessibility Features

- **Dyslexia-Friendly Font**: OpenDyslexic font family
- **High Contrast Mode**: Enhanced color contrast for better visibility
- **Adjustable Font Sizes**: 12pt to 24pt
- **Dark Mode**: Reduce eye strain
- **Minimal Animations**: No overwhelming transitions
- **Clear Navigation**: Simple and intuitive interface
- **Readable Text**: Large line spacing and clear hierarchy

## Dependencies

- **google_generative_ai**: ^0.4.0 - AI integration
- **provider**: ^6.1.0 - State management
- **sqflite**: ^2.3.0 - Local database
- **shared_preferences**: ^2.2.0 - User preferences
- **intl**: ^0.19.0 - Date formatting
- **uuid**: ^4.0.0 - Unique identifiers

## Important Notes

⚠️ **Disclaimer**: This application is designed to provide support and strategies, but is NOT a replacement for professional mental health care. If you are experiencing a mental health crisis, please contact:
- National Suicide Prevention Lifeline: 1-800-273-8255
- Crisis Text Line: Text HOME to 741741
- International Association for Suicide Prevention: https://www.iasp.info/resources/Crisis_Centres/

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

If you encounter any issues or have suggestions, please open an issue on the GitHub repository.

## Future Enhancements

- 🔔 Push notifications for task reminders
- 🗣️ Voice input and text-to-speech
- 👥 Multi-language support
- 📱 iOS support
- ☁️ Cloud sync for data backup
- 🎓 Educational resources
- 🧘 Guided meditation and breathing exercises
- 📊 Progress tracking and analytics

## Author

Created by Abd0-Wael-joker

---

**Remember**: You are capable, valuable, and deserve support. Be kind to yourself. 💙