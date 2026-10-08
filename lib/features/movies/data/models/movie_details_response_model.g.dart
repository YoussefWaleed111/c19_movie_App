// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsResponseModel _$MovieDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => MovieDetailsResponseModel(
  status: json['status'] as String?,
  statusMessage: json['status_message'] as String?,
  data: json['data'] == null
      ? null
      : MovieDetailsDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieDetailsResponseModelToJson(
  MovieDetailsResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'status_message': instance.statusMessage,
  'data': instance.data,
};

MovieDetailsDataModel _$MovieDetailsDataModelFromJson(
  Map<String, dynamic> json,
) => MovieDetailsDataModel(
  movie: json['movie'] == null
      ? null
      : MovieDetailsModel.fromJson(json['movie'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieDetailsDataModelToJson(
  MovieDetailsDataModel instance,
) => <String, dynamic>{'movie': instance.movie};
