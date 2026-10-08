import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_entity.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final int id;
  final String? title;
  @JsonKey(fromJson: _ratingFromJson)
  final double? rating;
  final List<String>? genres;
  final String? summary;
  @JsonKey(name: 'medium_cover_image')
  final String? mediumCoverImage;
  @JsonKey(name: 'large_cover_image')
  final String? largeCoverImage;
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  final int? year;
  final int? runtime;

  const MovieModel({
    required this.id,
    this.title,
    this.rating,
    this.genres,
    this.summary,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.backgroundImage,
    this.year,
    this.runtime,
  });

  static double? _ratingFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title ?? '',
      rating: rating ?? 0.0,
      genres: genres ?? [],
      summary: summary ?? '',
      mediumCoverImage: mediumCoverImage ?? '',
      largeCoverImage: largeCoverImage ?? '',
      backgroundImage: backgroundImage ?? '',
      year: year ?? 0,
      runtime: runtime ?? 0,
    );
  }
}
