import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../model/review_model.dart';
import '../../API_KEY.dart';

class ReviewController extends ControllerMVC {
  final http.Client _client = http.Client();

  List<Review> _reviews = [];
  List<Review> get items {
    return [..._reviews];
  }

  Future<List<Review>> getReviews(int movieId) async {
    var url =
        'https://api.themoviedb.org/3/movie/${movieId}/reviews?api_key=${APIHelper.getAPI()}&language=en-US&page=1';

    final response = await _client.get(
      url,
    );

    print("$url Code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return parseReviews(response.body);
    }
    return null;
  }

  List<Review> parseReviews(String body) {
    try {
      var movies = json.decode(body);

      _reviews = movies['results']
          .map<Review>((code) => Review.fromJson(code))
          .toList();

      print(_reviews);
      if (_reviews.isNotEmpty) {
        return _reviews;
      }
      return null;
    } catch (e) {
      print('Movie Error:  $e');
      return null;
    }
  }
}
