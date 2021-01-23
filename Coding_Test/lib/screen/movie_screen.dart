import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../api/movie/model/movie_model.dart';
import '../api/movie/controller/movie_api.dart';

class MovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coding Test'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height * 3.3,
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getSession('현재 상영중'),
              _horizontalUI(context, height, width),
              _getSession('개봉 예정'),
              _verticalUI(context, 'upcoming', height, width),
              _getSession('인기'),
              _verticalUI(context, 'popular', height, width),
              _getSession('높은 평점'),
              _verticalUI(context, 'top_rated', height, width),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getSession(String title) {
  return Container(
    padding: EdgeInsets.all(10),
    alignment: Alignment.topLeft,
    child: Text(
      title,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _horizontalUI(BuildContext context, double height, double width) {
  return Container(
    height: height * 0.4,
    child: FutureBuilder(
        future: MovieController().getMovies('now_playing'),
        builder: (ctx, snapshot) => !snapshot.hasData
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => InkWell(
                  onTap: () {
                    Movie m = snapshot.data[index];
                    Navigator.of(context)
                        .pushNamed('/movieDetail', arguments: m);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.3,
                        height: height * 0.3,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${snapshot.data[index].poster_path}'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.3,
                        alignment: Alignment.center,
                        child: Text(
                          snapshot.data[index].title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RatingBar.builder(
                        itemSize: 15.0,
                        initialRating: snapshot.data[index].vote_average / 2,
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
                itemCount: snapshot.data.length,
              )),
  );
}

Widget _verticalUI(
    BuildContext context, String url, double height, double width) {
  return Expanded(
    child: FutureBuilder(
      future: MovieController().getMovies(url),
      builder: (ctx, snapshot) => !snapshot.hasData
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, index) => InkWell(
                onTap: () {
                  Movie m = snapshot.data[index];
                  Navigator.of(context).pushNamed('/movieDetail', arguments: m);
                },
                child: Row(
                  children: [
                    Container(
                      width: width * 0.3,
                      height: height * 0.25,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${snapshot.data[index].poster_path}'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.6,
                      height: height * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index].title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RatingBar.builder(
                                  itemSize: 15.0,
                                  initialRating:
                                      snapshot.data[index].vote_average / 2,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: height * 0.03,
                                width: width * 0.4,
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, i) => Container(
                                          child: Text(
                                            '${snapshot.data[index].genre[i].name}, ',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: width * 0.03),
                                          ),
                                        ),
                                    itemCount:
                                        snapshot.data[index].genre.length),
                              ),
                              Text(snapshot.data[index].release_date,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: width * 0.03))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: 3,
            ),
    ),
  );
}
