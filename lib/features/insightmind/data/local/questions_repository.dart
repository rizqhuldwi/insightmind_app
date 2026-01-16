import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/question.dart';

class QuestionsRepository {
  static const String boxName = 'screening_questions';

  Future<Box<Question>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Question>(boxName);
    }
    return Hive.box<Question>(boxName);
  }

  Future<List<Question>> getAll() async {
    final box = await _openBox();
    if (box.isEmpty) {
      // Initialize with default questions if empty
      await box.addAll(defaultQuestions);
    }
    return box.values.toList();
  }

  Future<void> saveQuestions(List<Question> questions) async {
    final box = await _openBox();
    await box.clear();
    await box.addAll(questions);
  }

  Future<void> addQuestion(Question question) async {
    final box = await _openBox();
    await box.add(question);
  }

  Future<void> updateQuestion(int index, Question question) async {
    final box = await _openBox();
    await box.putAt(index, question);
  }

  Future<void> deleteQuestion(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }
}
