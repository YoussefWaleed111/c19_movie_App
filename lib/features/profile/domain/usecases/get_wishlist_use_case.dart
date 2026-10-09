import '../../../movies/domain/entities/movie_entity.dart';
import '../repositories/profile_repository.dart';

class GetWishlistUseCase {
  final ProfileRepository repository;

  GetWishlistUseCase(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getWishlist();
  }
}
