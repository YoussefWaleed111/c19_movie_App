// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviesResponseModel _$MoviesResponseModelFromJson(Map<String, dynamic> json) =>
    MoviesResponseModel(
      status: json['status'] as String?,
      statusMessage: json['status_message'] as String?,
      data: json['data'] == null
          ? null
          : MoviesDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoviesResponseModelToJson(
  MoviesResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'status_message': instance.statusMessage,
  'data': instance.data,
};

MoviesDataModel _$MoviesDataModelFromJson(Map<String, dynamic> json) =>
    MoviesDataModel(
      movieCount: (json['movie_count'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      pageNumber: (json['page_number'] as num?)?.toInt(),
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MoviesDataModelToJson(MoviesDataModel instance) =>
    <String, dynamic>{
      'movie_count': instance.movieCount,
      'limit': instance.limit,
      'page_number': instance.pageNumber,
      'movies': instance.movies,
    };
