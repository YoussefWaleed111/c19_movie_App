import 'package:json_annotation/json_annotation.dart';
import 'movie_details_model.dart';

part 'movie_details_response_model.g.dart';

@JsonSerializable()
class MovieDetailsResponseModel {
  final String? status;
  @JsonKey(name: 'status_message')
  final String? statusMessage;
  final MovieDetailsDataModel? data;

  const MovieDetailsResponseModel({
    this.status,
    this.statusMessage,
    this.data,
  });

  factory MovieDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsResponseModelToJson(this);
}

@JsonSerializable()
class MovieDetailsDataModel {
  final MovieDetailsModel? movie;

  const MovieDetailsDataModel({this.movie});

  factory MovieDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsDataModelToJson(this);
}
