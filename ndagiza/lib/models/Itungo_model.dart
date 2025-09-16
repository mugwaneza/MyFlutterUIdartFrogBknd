import 'package:flutter/foundation.dart';

class Itungo {
  final String itunguui_imyruui;
  final String igitsina;
  final double ubukure;
  final String itngcode;
  final String ibara;

  Itungo(
      {required this.itunguui_imyruui,
      required this.igitsina,
      required this.ubukure,
      required this.itngcode,
      required this.ibara});

  Map<String, dynamic> toJson() => {
        'itunguui_imyruui': itunguui_imyruui,
        'igitsina': igitsina,
        'ubukure': ubukure,
        'itngcode': itngcode,
        'ibara': ibara,
      };
}
