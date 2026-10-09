import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/profile_repository.dart';

class StreamWishlistUseCase {
  final ProfileRepository repository;

  StreamWishlistUseCase(this.repository);

  Stream<List<MovieEntity>> call(String userId) {
    return repository.streamWishlist(userId);
  }
}
