class PlacePrediction {
  const PlacePrediction({
    required this.id,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  final String id;
  final String description;
  final String mainText;
  final String secondaryText;

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting =
        json['structured_formatting'] ?? <String, dynamic>{};
    return PlacePrediction(
      id: json['place_id'],
      description: json['description'],
      mainText: structuredFormatting['main_text'] ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
    );
  }
}
