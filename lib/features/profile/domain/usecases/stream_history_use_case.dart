import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/profile_repository.dart';

class StreamHistoryUseCase {
  final ProfileRepository repository;

  StreamHistoryUseCase(this.repository);

  Stream<List<MovieEntity>> call(String userId) {
    return repository.streamHistory(userId);
  }
}
