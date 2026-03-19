import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mime/mime.dart';

Future<Response> onRequest(RequestContext context,String imagename) async {
  // Get the image name from the URL path
 // print('Requested image: $imagename');

  final basePath = Platform.isWindows
      ? 'C:/MyFlutterUIdartFrogBknd/uploads/amatungo/images'
      : '/home/dartapi/api/ndagiza_dartapi/uploads/amatungo/images';


  final file = File('$basePath/$imagename');

  if (await file.exists()) {
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final bytes = await file.readAsBytes();
    return Response.bytes(
      body: bytes,
      headers: {
        'Content-Type': mimeType,
        'Cache-Control': 'public, max-age=3600', // optional caching

      },
    );
  } else {
    return Response(statusCode: 404, body: 'Image not found');
  }
}