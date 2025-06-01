import 'article.dart';

class NewsModel {
  String? status;
  int? totalResults;
  List<Article>? articles;

  NewsModel({this.status, this.totalResults, this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles:
          json['articles'] != null
              ? List<Article>.from(
                json['articles'].map((x) => Article.fromJson(x)),
              )
              : null,
    );
  }
}
