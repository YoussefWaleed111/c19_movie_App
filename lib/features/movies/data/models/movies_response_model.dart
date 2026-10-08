import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'movies_response_model.g.dart';

@JsonSerializable()
class MoviesResponseModel {
  final String? status;
  @JsonKey(name: 'status_message')
  final String? statusMessage;
  final MoviesDataModel? data;

  const MoviesResponseModel({
    this.status,
    this.statusMessage,
    this.data,
  });

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesResponseModelToJson(this);
}

@JsonSerializable()
class MoviesDataModel {
  @JsonKey(name: 'movie_count')
  final int? movieCount;
  final int? limit;
  @JsonKey(name: 'page_number')
  final int? pageNumber;
  final List<MovieModel>? movies;

  const MoviesDataModel({
    this.movieCount,
    this.limit,
    this.pageNumber,
    this.movies,
  });

  factory MoviesDataModel.fromJson(Map<String, dynamic> json) =>
      _$MoviesDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesDataModelToJson(this);
}
