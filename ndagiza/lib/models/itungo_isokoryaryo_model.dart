class ItungoIsokoryaryo {
  final String itunguui;
  final double amafaranga_rihagaze;
  final String isoko;

  ItungoIsokoryaryo({
    required this.itunguui,
    required this.amafaranga_rihagaze,
    required this.isoko,
  });

  Map<String, dynamic> toJson() => {
        'itunguui': itunguui,
        'amafaranga_rihagaze': amafaranga_rihagaze,
        'isoko': isoko,
      };
}
