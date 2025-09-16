import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:ndagiza_dartapi/db.dart';

final env = DotEnv()..load();
bool _isDbConnected = false;

Handler middleware(Handler handler) {
  return (RequestContext context) async {
    // Handle CORS preflight requests
    if (context.request.method == HttpMethod.options) {
      return Response(
        statusCode: 204,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Access-Control-Allow-Credentials': 'true',
        },
      );
    }

    // Ensure database is connected once
    if (!_isDbConnected) {
      await connectToDatabase();
      _isDbConnected = true;
    }

    // Get the original response
    final response = await handler(context);

    // Return the response with CORS headers added, without changing the body
    return response.copyWith(
      headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Access-Control-Allow-Credentials': 'true',
      },
    );
  };
}
