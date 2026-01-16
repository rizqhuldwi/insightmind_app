import 'package:hive/hive.dart';
import '../../domain/entities/question.dart';
import 'package:uuid/uuid.dart';

class QuestionRepository {
  static const String _boxName = 'questions';

  Box<Question> get _box => Hive.box<Question>(_boxName);

  List<Question> getQuestions() {
    return _box.values.toList();
  }

  Future<void> addQuestion(String text, List<AnswerOption> options) async {
    final id = const Uuid().v4();
    final question = Question(id: id, text: text, options: options);
    await _box.put(id, question);
  }

  Future<void> updateQuestion(Question question) async {
    await _box.put(question.id, question);
  }

  Future<void> deleteQuestion(String id) async {
    await _box.delete(id);
  }

  Future<void> initDefaultQuestions() async {
    if (_box.isEmpty) {
      for (final q in defaultQuestions) {
        await _box.put(q.id, q);
      }
    }
  }
}
