class Review {
  String author;
  String content;

  Review({this.author, this.content});

  Review.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    content = json['content'];
  }
}
