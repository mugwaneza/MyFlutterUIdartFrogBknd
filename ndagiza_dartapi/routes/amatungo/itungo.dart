
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ndagiza_dartapi/db.dart';
Future<Response> onRequest(RequestContext context) async {


  // Check Authorization header
  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'error': 'Unauthorized: Missing token'},
    );
  }
  final token = authHeader.substring(7);
  try {
    final jwt = JWT.verify(token, SecretKey('APP_SECRET_KEY'));

    // Optional: check payload type
    if (jwt.payload['type'] != 'app') {
      return Response.json(
        statusCode: 403,
        body: {'error': 'Forbidden: Invalid token type'},
      );
    }
  } catch (e) {
  return Response.json(
  statusCode: 401,
  body: {'error': 'Invalid token: $e'},
  );
  }

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