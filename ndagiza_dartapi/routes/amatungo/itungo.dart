
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';

Future<Response> onRequest(RequestContext context) async {
  final result = await db.query('''
  SELECT COUNT(icy.izina) AS umubare,
         icy.izina
  FROM amatungo.itungo itung
  INNER JOIN amatungo.imyororokere imyor
    ON itung.itunguui_imyruui = imyor.imyruui
  INNER JOIN amatungo.icyiciro icy
    ON imyor.imyruui_icyuui = icy.icyuui
  GROUP BY icy.izina
  ''');

  return Response.json(body: result);
}