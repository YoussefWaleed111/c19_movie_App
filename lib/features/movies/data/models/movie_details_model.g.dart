// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsModel _$MovieDetailsModelFromJson(Map<String, dynamic> json) =>
    MovieDetailsModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      year: (json['year'] as num?)?.toInt(),
      rating: MovieDetailsModel._ratingFromJson(json['rating']),
      runtime: (json['runtime'] as num?)?.toInt(),
      likeCount: MovieDetailsModel._likeCountFromJson(json['like_count']),
      descriptionFull: json['description_full'] as String?,
      summary: json['summary'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      backgroundImageOriginal: json['background_image_original'] as String?,
      mediumCoverImage: json['medium_cover_image'] as String?,
      largeScreenshot1: json['large_screenshot_image1'] as String?,
      largeScreenshot2: json['large_screenshot_image2'] as String?,
      largeScreenshot3: json['large_screenshot_image3'] as String?,
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => CastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieDetailsModelToJson(MovieDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'rating': instance.rating,
      'runtime': instance.runtime,
      'like_count': instance.likeCount,
      'description_full': instance.descriptionFull,
      'summary': instance.summary,
      'genres': instance.genres,
      'background_image_original': instance.backgroundImageOriginal,
      'medium_cover_image': instance.mediumCoverImage,
      'large_screenshot_image1': instance.largeScreenshot1,
      'large_screenshot_image2': instance.largeScreenshot2,
      'large_screenshot_image3': instance.largeScreenshot3,
      'cast': instance.cast,
    };
