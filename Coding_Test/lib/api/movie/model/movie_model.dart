class Movie {
  int id;
  bool adult;
  String originalLanguage;
  String originalTitle;
  String overview;
  dynamic popularity;
  String posterPath;
  String releaseDate;
  String title;
  dynamic voteAverage;
  dynamic voteCount;
  List<int> genreIds = [];
  List<Genre> genre = [];

  Movie(
      {this.id,
      this.adult,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.voteAverage,
      this.voteCount,
      this.genre,
      this.genreIds});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adult = json['adult'] ? true : false;
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    for (int i in json['genre_ids']) {
      genreIds.add(i);
    }
  }
}

class Genre {
  int id;
  String name;

  Genre({
    this.id,
    this.name,
  });

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
