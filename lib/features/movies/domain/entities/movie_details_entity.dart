import 'cast_entity.dart';

class MovieDetailsEntity {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final String descriptionFull;
  final List<String> genres;
  final String backgroundImageOriginal;
  final String mediumCoverImage;
  final String largeScreenshot1;
  final String largeScreenshot2;
  final String largeScreenshot3;
  final List<CastEntity> cast;

  const MovieDetailsEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.descriptionFull,
    required this.genres,
    required this.backgroundImageOriginal,
    required this.mediumCoverImage,
    required this.largeScreenshot1,
    required this.largeScreenshot2,
    required this.largeScreenshot3,
    required this.cast,
  });
}
