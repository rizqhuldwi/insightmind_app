import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/question.dart';
import '../../data/local/question_repository.dart';

final questionRepositoryProvider = Provider((ref) => QuestionRepository());

final questionsProvider = StateProvider<List<Question>>((ref) {
  final repo = ref.watch(questionRepositoryProvider);
  return repo.getQuestions();
});

/// State: map id pertanyaan -> skor (0..3)
class QuestionnaireState {
  final Map<String, int> answers;
  final List<Question> currentQuestions; // Track questions at start of session
  
  const QuestionnaireState({
    this.answers = const {},
    this.currentQuestions = const [],
  });

  QuestionnaireState copyWith({
    Map<String, int>? answers,
    List<Question>? currentQuestions,
  }) {
    return QuestionnaireState(
      answers: answers ?? this.answers,
      currentQuestions: currentQuestions ?? this.currentQuestions,
    );
  }

  bool get isComplete => answers.length >= currentQuestions.length && currentQuestions.isNotEmpty;

  int get totalScore => answers.values.fold(0, (a, b) => a + b);
}

class QuestionnaireNotifier extends Notifier<QuestionnaireState> {
  @override
  QuestionnaireState build() {
    final questions = ref.read(questionsProvider);
    return QuestionnaireState(currentQuestions: questions);
  }

  void selectAnswer({required String questionId, required int score}) {
    final newMap = Map<String, int>.from(state.answers);
    newMap[questionId] = score;
    state = state.copyWith(answers: newMap);
  }

  void reset() {
    final questions = ref.read(questionsProvider);
    state = QuestionnaireState(currentQuestions: questions);
  }
}

/// Provider state form
final questionnaireProvider =
    NotifierProvider<QuestionnaireNotifier, QuestionnaireState>(
      QuestionnaireNotifier.new,
    );
