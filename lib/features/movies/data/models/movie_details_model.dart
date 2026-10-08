import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_details_entity.dart';
import 'cast_model.dart';

part 'movie_details_model.g.dart';

@JsonSerializable()
class MovieDetailsModel {
  final int id;
  final String? title;
  final int? year;
  @JsonKey(fromJson: _ratingFromJson)
  final double? rating;
  final int? runtime;
  @JsonKey(name: 'like_count', fromJson: _likeCountFromJson)
  final int? likeCount;
  @JsonKey(name: 'description_full')
  final String? descriptionFull;
  final String? summary;
  final List<String>? genres;
  @JsonKey(name: 'background_image_original')
  final String? backgroundImageOriginal;
  @JsonKey(name: 'medium_cover_image')
  final String? mediumCoverImage;
  @JsonKey(name: 'large_screenshot_image1')
  final String? largeScreenshot1;
  @JsonKey(name: 'large_screenshot_image2')
  final String? largeScreenshot2;
  @JsonKey(name: 'large_screenshot_image3')
  final String? largeScreenshot3;
  final List<CastModel>? cast;

  const MovieDetailsModel({
    required this.id,
    this.title,
    this.year,
    this.rating,
    this.runtime,
    this.likeCount,
    this.descriptionFull,
    this.summary,
    this.genres,
    this.backgroundImageOriginal,
    this.mediumCoverImage,
    this.largeScreenshot1,
    this.largeScreenshot2,
    this.largeScreenshot3,
    this.cast,
  });

  static double? _ratingFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _likeCountFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsModelToJson(this);

  MovieDetailsEntity toEntity() {
    final finalDescription = (descriptionFull != null && descriptionFull!.isNotEmpty)
        ? descriptionFull!
        : (summary ?? '');

    return MovieDetailsEntity(
      id: id,
      title: title ?? '',
      year: year ?? 0,
      rating: rating ?? 0.0,
      runtime: runtime ?? 0,
      likeCount: likeCount ?? 0,
      descriptionFull: finalDescription,
      genres: genres ?? [],
      backgroundImageOriginal: backgroundImageOriginal ?? '',
      mediumCoverImage: mediumCoverImage ?? '',
      largeScreenshot1: largeScreenshot1 ?? '',
      largeScreenshot2: largeScreenshot2 ?? '',
      largeScreenshot3: largeScreenshot3 ?? '',
      cast: cast?.map((c) => c.toEntity()).toList() ?? [],
    );
  }
}
