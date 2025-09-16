class ItungoUkozororoka {
  final String itunguui;
  final String ukozruui;

  ItungoUkozororoka({
    required this.itunguui,
    required this.ukozruui,
  });

  Map<String, dynamic> toJson() => {
        'itunguui': itunguui,
        'ukozruui': ukozruui,
      };
}
