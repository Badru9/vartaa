import 'author_article.dart';

class NewsModel {
  String? status;
  int? totalResults;
  List<AuthorArticle>? articles;

  NewsModel({this.status, this.totalResults, this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles:
          json['articles'] != null
              ? List<AuthorArticle>.from(
                json['articles'].map((x) => AuthorArticle.fromJson(x)),
              )
              : null,
    );
  }
}
