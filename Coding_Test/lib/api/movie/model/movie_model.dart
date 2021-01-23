class Movie {
  int id;
  bool adult;
  String original_language;
  String original_title;
  String overview;
  dynamic popularity;
  String poster_path;
  String release_date;
  String title;
  dynamic vote_average;
  dynamic vote_count;
  List<int> genre_ids = [];
  List<Genre> genre = [];

  Movie(
      {this.id,
      this.adult,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.release_date,
      this.title,
      this.vote_average,
      this.vote_count,
      this.genre,
      this.genre_ids});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adult = json['adult'] ? true : false;
    original_language = json['original_language'];
    original_title = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    poster_path = json['poster_path'];
    release_date = json['release_date'];
    title = json['title'];
    vote_average = json['vote_average'];
    vote_count = json['vote_count'];
    for (int i in json['genre_ids']) {
      genre_ids.add(i);
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
