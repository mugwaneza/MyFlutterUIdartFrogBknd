class ItungoUbuzimabwaryo {
  final String itunguui;
  final String uzmuui;

  ItungoUbuzimabwaryo({
    required this.itunguui,
    required this.uzmuui,
  });

  Map<String, dynamic> toJson() => {
        'itunguui': itunguui,
        'uzmuui': uzmuui,
      };
}
