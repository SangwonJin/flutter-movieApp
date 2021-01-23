import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

import '../api/movie/model/movie_model.dart';
import '../api/review/controller/review_api.dart';
import '../api/review/model/review_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailScreen({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height * 3,
        child: Stack(children: [
          _backGroundImage(movie.posterPath),
          _mainCard(movie, height, width),
          _subImageAndDescription(height, width, movie),
          _backButton(height, width, context),
        ]),
      ),
    );
  }
}

Widget _backGroundImage(String posterPath) {
  return Container(
    decoration: BoxDecoration(
        image: DecorationImage(
      colorFilter:
          new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
      fit: BoxFit.cover,
      image: NetworkImage('https://image.tmdb.org/t/p/w500${posterPath}'),
    )),
  );
}

Widget _mainCard(Movie movie, double height, double width) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        height: height * 0.6,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: height * 0.2),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _getSession('개요'),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          movie.overview,
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      _getSession('주요 출연진'),
                      Container(
                        width: width * 0.2,
                        height: height * 0.15,
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text('Actor name')
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: ReviewController().getReviews(movie.id),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return _listViewOfReview(context, snapshot);
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

Widget _subImageAndDescription(double height, double width, Movie movie) {
  return Positioned(
    top: height / 3.2,
    left: width / 14,
    child: Row(
      children: [
        Container(
          width: height / 6,
          height: width / 2.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
                child: Text(
                  movie.adult ? 'Adult' : 'No adult',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    width: 175,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) => Container(
                        child: Text(
                          '${movie.genre[i].name}, ',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      itemCount: movie.genre.length,
                    ),
                  ),
                ],
              ),
              Text(
                '${movie.releaseDate} Released',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              RatingBar.builder(
                itemSize: 15.0,
                initialRating: movie.voteAverage / 2,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _backButton(double height, double width, BuildContext context) {
  return Positioned(
    child: Padding(
      padding: EdgeInsets.all(
        (height / 20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: width / 8,
        width: width / 8,
        child: Center(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 40.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    ),
    top: 0.0,
  );
}

Widget _getSession(String title) {
  return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ));
}

Widget _listViewOfReview(BuildContext context, AsyncSnapshot snapshot) {
  return Column(
    children: [
      _getSession('리뷰'),
      ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (ctx, index) {
          Review review = snapshot.data[index];
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
              left: 20,
              bottom: 20,
              right: 20,
            ),
            height: 105,
            width: 180,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.content,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    review.author,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: snapshot.data.length,
      ),
    ],
  );
}
