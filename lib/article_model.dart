class Article {
  final String id;
  final String title;
  final String url;
  final String date;
  final String dateTime;
  final String author;
  final String authorLink;
  final String type;
  final String thumbnail;
  final List<String> categories;

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.date,
    required this.dateTime,
    required this.author,
    required this.authorLink,
    required this.type,
    required this.thumbnail,
    required this.categories,
  });

  // Compatibility getters for the rest of the application
  String get link => url;
  String get image => thumbnail;
  String get isoDate => date;
  String get contentSnippet => categories.isNotEmpty 
      ? 'Kategori: ${categories.join(", ")}' 
      : 'Artikel Islam';

  factory Article.fromJson(Map<String, dynamic> json) {
    // Categories parsed from array of maps or strings
    List<String> categoryNames = [];
    if (json['categories'] != null && json['categories'] is List) {
      for (var cat in json['categories']) {
        if (cat is Map && cat['name'] != null) {
          categoryNames.add(cat['name'].toString());
        } else if (cat is String) {
          categoryNames.add(cat);
        }
      }
    }

    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? json['link']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      dateTime: json['date_time']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      authorLink: json['author_link']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      categories: categoryNames,
    );
  }
}
