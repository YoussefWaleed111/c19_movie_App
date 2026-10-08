import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/movies/data/models/movie_details_response_model.dart';
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

  @GET('movie_details.json')
  Future<MovieDetailsResponseModel> getMovieDetails(
    @Query('movie_id') int movieId,
    @Query('with_images') bool withImages,
    @Query('with_cast') bool withCast,
  );

  @GET('movie_suggestions.json')
  Future<MoviesResponseModel> getMovieSuggestions(
    @Query('movie_id') int movieId,
  );

  @GET('list_movies.json')
  Future<MoviesResponseModel> searchMovies(
    @Query('query_term') String query,
  );
}
