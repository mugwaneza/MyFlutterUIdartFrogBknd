import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/env.dart'; // ✅ Correctly import the file where `env` is defined

Response onRequest(RequestContext context) {
  return Response(body: 'Welcome to Dart Frog!');
}
