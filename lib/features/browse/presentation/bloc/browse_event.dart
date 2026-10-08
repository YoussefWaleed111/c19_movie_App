abstract class BrowseEvent {}

class LoadGenresEvent extends BrowseEvent {}

class ChangeGenreEvent extends BrowseEvent {
  final String selectedGenre;

  ChangeGenreEvent(this.selectedGenre);
}
