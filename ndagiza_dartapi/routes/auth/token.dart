import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final appId = body['appId'];

  if (appId != 'nozasecretId-api') {
    return Response.json(statusCode: 403, body: {'error': 'Invalid appId'});
  }

  final jwt = JWT(
    {'type': 'app', 'appId': appId},
    issuer: 'nozasecretId-api',
  );

  final token = jwt.sign(
    SecretKey('APP_SECRET_KEY'),
    expiresIn: const Duration(days: 30),
  );

  return Response.json(body: {'token': token});
}
