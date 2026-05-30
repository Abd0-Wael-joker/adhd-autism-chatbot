import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chat_message.dart';
import '../models/task.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'adhd_autism_chatbot.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Chat messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        isUser INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        category TEXT
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        category TEXT
      )
    ''');
  }

  // Chat message methods
  Future<void> saveChatMessage(ChatMessage message) async {
    final db = await database;
    await db.insert('chat_messages', message.toMap());
  }

  Future<List<ChatMessage>> getChatHistory() async {
    final db = await database;
    final results = await db.query('chat_messages', orderBy: 'timestamp DESC');
    return results.map((map) => ChatMessage.fromMap(map)).toList();
  }

  Future<void> clearChatHistory() async {
    final db = await database;
    await db.delete('chat_messages');
  }

  // Task methods
  Future<void> saveTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  Future<List<Task>> getTasks({bool? completed}) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (completed != null) {
      where = 'isCompleted = ?';
      whereArgs = [completed ? 1 : 0];
    }

    final results = await db.query(
      'tasks',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'dueDate ASC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('chat_messages');
    await db.delete('tasks');
  }
}