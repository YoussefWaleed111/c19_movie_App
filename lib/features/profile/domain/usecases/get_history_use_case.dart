import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/profile_repository.dart';

class GetHistoryUseCase {
  final ProfileRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getHistory();
  }
}
