class Holiday {
  final DateTime date;
  final String description;

  Holiday({required this.date, required this.description});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
