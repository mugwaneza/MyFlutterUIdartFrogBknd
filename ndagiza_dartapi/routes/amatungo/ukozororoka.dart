
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';

Future<Response> onRequest(RequestContext context) async {
  final result = await db.query('SELECT ukozruui, kororoka FROM amatungo.ukozororoka');
  return Response.json(body: result);
}

