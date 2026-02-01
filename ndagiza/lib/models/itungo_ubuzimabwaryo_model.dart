class ItungoUbuzimabwaryo {
  final String itunguui;
  final String uzmuui;
  final String? ibisobanuro;

  ItungoUbuzimabwaryo({
    required this.itunguui,
    required this.uzmuui,
    required this.ibisobanuro,
  });

  Map<String, dynamic> toJson() => {
        'itunguui': itunguui,
        'uzmuui': uzmuui,
        'ibisobanuro': ibisobanuro,
      };
}
