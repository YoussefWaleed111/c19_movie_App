class MovieEntity {
  final int id;
  final String title;
  final double rating;
  final List<String> genres;
  final String summary;
  final String mediumCoverImage;
  final String largeCoverImage;
  final String backgroundImage;
  final int year;
  final int runtime;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.rating,
    required this.genres,
    required this.summary,
    required this.mediumCoverImage,
    required this.largeCoverImage,
    required this.backgroundImage,
    required this.year,
    required this.runtime,
  });
}
