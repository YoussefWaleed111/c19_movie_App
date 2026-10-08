import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/movies/data/models/movies_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://yts.lt/api/v2/')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('list_movies.json')
  Future<MoviesResponseModel> getFeaturedMovies(
    @Query('sort_by') String sortBy,
    @Query('limit') int limit,
  );

  @GET('list_movies.json')
  Future<MoviesResponseModel> getMoviesByGenre(
    @Query('genre') String genre,
    @Query('limit') int limit,
  );
}
