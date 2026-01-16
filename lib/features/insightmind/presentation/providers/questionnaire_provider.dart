import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/question.dart';
import '../../data/local/questions_repository.dart';

/// Provider untuk repository pertanyaan
final questionsRepositoryProvider = Provider<QuestionsRepository>((ref) {
  return QuestionsRepository();
});

/// Provider daftar pertanyaan (dinamis dari Hive)
final questionsProvider = StateNotifierProvider<QuestionsNotifier, List<Question>>((ref) {
  final repo = ref.read(questionsRepositoryProvider);
  return QuestionsNotifier(repo);
});

class QuestionsNotifier extends StateNotifier<List<Question>> {
  final QuestionsRepository _repo;

  QuestionsNotifier(this._repo) : super([]) {
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    state = await _repo.getAll();
  }

  Future<void> addQuestion(Question question) async {
    await _repo.addQuestion(question);
    await loadQuestions();
  }

  Future<void> updateQuestion(int index, Question question) async {
    await _repo.updateQuestion(index, question);
    await loadQuestions();
  }

  Future<void> deleteQuestion(int index) async {
    await _repo.deleteQuestion(index);
    await loadQuestions();
  }
}

/// State: map id pertanyaan -> skor (0..3)
class QuestionnaireState {
  final Map<String, int> answers;
  final int questionsCount;

  const QuestionnaireState({this.answers = const {}, this.questionsCount = 0});

  QuestionnaireState copyWith({Map<String, int>? answers, int? questionsCount}) {
    return QuestionnaireState(
      answers: answers ?? this.answers,
      questionsCount: questionsCount ?? this.questionsCount,
    );
  }

  bool get isComplete => answers.length >= questionsCount && questionsCount > 0;

  int get totalScore => answers.values.fold(0, (a, b) => a + b);
}

class QuestionnaireNotifier extends Notifier<QuestionnaireState> {
  @override
  QuestionnaireState build() {
    final questions = ref.watch(questionsProvider);
    return QuestionnaireState(questionsCount: questions.length);
  }

  void selectAnswer({required String questionId, required int score}) {
    final newMap = Map<String, int>.from(state.answers);
    newMap[questionId] = score;
    state = state.copyWith(answers: newMap);
  }

  void reset() {
    state = QuestionnaireState(questionsCount: state.questionsCount);
  }
}

/// Provider state form
final questionnaireProvider =
    NotifierProvider<QuestionnaireNotifier, QuestionnaireState>(
      QuestionnaireNotifier.new,
    );
