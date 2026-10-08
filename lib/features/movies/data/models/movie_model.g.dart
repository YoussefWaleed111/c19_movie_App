// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String?,
  rating: MovieModel._ratingFromJson(json['rating']),
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  summary: json['summary'] as String?,
  mediumCoverImage: json['medium_cover_image'] as String?,
  largeCoverImage: json['large_cover_image'] as String?,
  backgroundImage: json['background_image'] as String?,
  year: (json['year'] as num?)?.toInt(),
  runtime: (json['runtime'] as num?)?.toInt(),
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'rating': instance.rating,
      'genres': instance.genres,
      'summary': instance.summary,
      'medium_cover_image': instance.mediumCoverImage,
      'large_cover_image': instance.largeCoverImage,
      'background_image': instance.backgroundImage,
      'year': instance.year,
      'runtime': instance.runtime,
    };
