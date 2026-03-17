import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mime/mime.dart';

Future<Response> onRequest(RequestContext context,dynamic imagename) async {
  // Get the image name from the URL path
 // print('Requested image: $imagename');

  final imageDir = Platform.isWindows
      ? Directory('C:/MyFlutterUIdartFrogBknd/uploads/amatungo/images/$imagename')
      : Directory('/home/dartapi/api/ndagiza_dartapi/uploads/amatungo/images/$imagename');

  // Create folder if it doesn't exist
  if (!imageDir.existsSync()) {
    imageDir.createSync(recursive: true);
  }

  final file = File(imageDir.path);

  if (await file.exists()) {
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final bytes = await file.readAsBytes();
    return Response.bytes(
      body: bytes,
      headers: {
        'Content-Type': mimeType,
      },
    );
  } else {
    return Response(statusCode: 404, body: 'Image not found');
  }
}