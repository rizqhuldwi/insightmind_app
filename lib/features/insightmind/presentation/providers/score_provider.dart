// Lightweight local stand-ins to avoid external package dependencies in this file.
// These minimal classes provide the small API surface used in this file (Provider, StateProvider, Ref).
typedef Create<T> = T Function(Ref ref);

class Ref {
  T watch<T>(ProviderBase<T> provider) => provider.create(this);
}

abstract class ProviderBase<T> {
  final Create<T> create;
  ProviderBase(this.create);
}

class Provider<T> extends ProviderBase<T> {
  Provider(Create<T> create) : super(create);
}

class StateProvider<T> extends Provider<T> {
  StateProvider(Create<T> create) : super(create);
}

// Simple repository implementation to calculate score.
class ScoreRepository {
  int calculateScore(List<int>? answers) {
    if (answers == null || answers.isEmpty) return 0;
    return answers.fold(0, (a, b) => a + b);
  }
}

// Simple use-case to convert score into a risk level.
class CalculateRiskLevel {
  Map<String, dynamic> execute(int score) {
    final level = score < 5 ? 'low' : score < 10 ? 'medium' : 'high';
    return {'score': score, 'level': level};
  }
}

/// Simpan jawaban kuisioner di memori (sementara).
final answersProvider = StateProvider<List<int>>((ref) => []);

/// Repository sederhana untuk hitung skor total.
final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  return ScoreRepository();
});

/// Use case untuk konversi skor -> level risiko.
final calculateRiskProvider = Provider<CalculateRiskLevel>((ref) {
  return CalculateRiskLevel();
});

/// Hasil scoring mentah.
final scoreProvider = Provider<int>((ref) {
  final repo = ref.watch(scoreRepositoryProvider);
  final answers = ref.watch(answersProvider);
  return repo.calculateScore(answers);
});

/// Hasil akhir (skor + level risiko).
final resultProvider = Provider((ref) {
  final score = ref.watch(scoreProvider);
  final usecase = ref.watch(calculateRiskProvider);
  return usecase.execute(score);
});