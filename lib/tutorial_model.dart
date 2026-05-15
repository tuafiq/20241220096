class TutorialModel {
  final int id;
  final String name;
  final String arabic;
  final String latin;
  final String terjemahan;

  TutorialModel({
    required this.id,
    required this.name,
    required this.arabic,
    required this.latin,
    required this.terjemahan,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      id: json['id'],
      name: json['name'],
      arabic: json['arabic'],
      latin: json['latin'],
      terjemahan: json['terjemahan'],
    );
  }
}
