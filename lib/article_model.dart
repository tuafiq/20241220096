class Article {
  final String title;
  final String link;
  final String contentSnippet;
  final String isoDate;
  final String image;

  Article({
    required this.title,
    required this.link,
    required this.contentSnippet,
    required this.isoDate,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // Handle image field which can be a String (Antara) or an Object (CNN)
    // or a thumbnail (some portals)
    String imageUrl = '';
    
    // Check 'image' field first
    if (json['image'] != null) {
      if (json['image'] is String) {
        imageUrl = json['image'];
      } else if (json['image'] is Map) {
        imageUrl = json['image']['large'] ?? json['image']['small'] ?? '';
      }
    } 
    
    // Fallback to 'thumbnail' if imageUrl is still empty
    if (imageUrl.isEmpty && json['thumbnail'] != null) {
      imageUrl = json['thumbnail'].toString();
    }

    return Article(
      title: json['title'] ?? '',
      link: json['link']?.toString().trim() ?? '',
      // Handle different content fields across portals
      contentSnippet: json['contentSnippet'] ?? json['description'] ?? json['content'] ?? '',
      isoDate: json['isoDate'] ?? json['pubDate'] ?? '',
      image: imageUrl,
    );
  }
}
