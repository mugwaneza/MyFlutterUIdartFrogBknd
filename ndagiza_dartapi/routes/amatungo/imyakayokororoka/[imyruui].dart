
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
Future<Response> onRequest(RequestContext context, String uuid) async {
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
  if (uuid == null) {
    return Response.json(
      body: {'error': 'Id is not availabe'},
      statusCode: 400,
    );
  }
  final result = await db.query('SELECT imyakayokororoka, ameziibyarira FROM amatungo.imyororokere where imyruui= @uuid',
    substitutionValues: {
      'uuid': uuid,
    },
  );

  return Response.json(body: result);
}

