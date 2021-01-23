import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../model/movie_model.dart';
import '../../API_KEY.dart';

class MovieController extends ControllerMVC {
  var url = 'https://api.themoviedb.org/3/movie/';
  final http.Client _client = http.Client();

  List<Movie> _movies = [];
  List<Movie> get items {
    return [..._movies];
  }

  List<Genre> _genres = [];

  Future<List<Movie>> getMovies(String inputUrl) async {
    url += '$inputUrl?api_key=${APIHelper.getAPI()}';

    final response = await _client.get(
      url,
    );

    print("$inputUrl Code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      parseMovieList(response.body);

      //get Genre
      _genres = await getGenre();

      //adding Genres into Movies
      for (Movie movie in _movies) {
        for (int genreId in movie.genreIds) {
          _genres
              .where((genre) => genre.id == genreId)
              .map((genre) => movie.genre.add(genre))
              .toList();
        }
      }

      return _movies;
    } else {
      return null;
    }
  }

  List<Movie> parseMovieList(String body) {
    try {
      var movies = json.decode(body);

      _movies =
          movies['results'].map<Movie>((code) => Movie.fromJson(code)).toList();

      print(_movies);
      return _movies;
    } catch (e) {
      print('Movie Error:  $e');
      return null;
    }
  }

  Future<List<Genre>> getGenre() async {
    String genreAPI =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=${APIHelper.getAPI()}&language=en-US';

    final response = await _client.get(
      genreAPI,
    );

    print("get GenreAPI Code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var dataList = json.decode(response.body);

      return dataList['genres']
          .map<Genre>((code) => Genre.fromJson(code))
          .toList();
    }
    print('getGenre Methods ' + _genres.toString());
    return null;
  }
}
