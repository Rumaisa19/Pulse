import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  final String id;

  @JsonKey(name: 'webTitle')
  @HiveField(1)
  final String title;

  @HiveField(2)
  final Map<String, dynamic>? fields;

  @HiveField(3)
  final String sectionName;

  @HiveField(4)
  final String webUrl;

  @HiveField(5)
  final String webPublicationDate;

  Article({
    required this.id,
    required this.title,
    required this.fields,
    required this.sectionName,
    required this.webUrl,
    required this.webPublicationDate,
  });

  String get summary => fields?['trailText'] ?? 'No summary available';
  String get thumbnail => fields?['thumbnail'] ?? '';

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
