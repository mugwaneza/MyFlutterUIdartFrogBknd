class ItungoUkozororoka {
  final String itunguui;
  final String ukozruui;
  final String? itari_ryimiye;
  final String? itariki_ribyariye;
  final String? itariki_rivukiye;
  final String? igitsina_cyavutse;

  ItungoUkozororoka({
    required this.itunguui,
    required this.ukozruui,
    required this.itari_ryimiye,
    required this.itariki_ribyariye,
    required this.itariki_rivukiye,
    required this.igitsina_cyavutse,
  });

  Map<String, dynamic> toJson() => {
        'itunguui': itunguui,
        'ukozruui': ukozruui,
        'itari_ryimiye': itari_ryimiye,
        'itariki_ribyariye': itariki_ribyariye,
        'itariki_rivukiye': itariki_rivukiye,
        'igitsina_cyavutse': igitsina_cyavutse,
      };
}
