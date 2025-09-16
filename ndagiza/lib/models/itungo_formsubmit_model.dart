import 'package:ndagiza/models/Itungo_ukozororoka_model.dart';
import 'package:ndagiza/models/itungo_isokoryaryo_model.dart';
import 'package:ndagiza/models/itungo_ubuzimabwaryo_model.dart';

import 'itungo_model.dart';

class FormSubmission {
  final Itungo itungo;
  final ItungoIsokoryaryo isokoryaryo;
  final ItungoUbuzimabwaryo ubuzimabwaryo;
  final ItungoUkozororoka ukozororoka;

  FormSubmission({
    required this.isokoryaryo,
    required this.itungo,
    required this.ubuzimabwaryo,
    required this.ukozororoka,
  });

  Map<String, dynamic> toJson() => {
        'itungo': itungo.toJson(),
        'isokoryaryo': isokoryaryo.toJson(),
        'ubuzimabwaryo': ubuzimabwaryo.toJson(),
        'ukozororoka': ukozororoka.toJson(),
      };
}
