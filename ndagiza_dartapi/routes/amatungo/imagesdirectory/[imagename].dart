import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mime/mime.dart';

Future<Response> onRequest(RequestContext context, dynamic imagename) async {

   imagename = context.request.uri.pathSegments.last;
  print('Requested image: $imagename');
  final filePath = 'C:/MyFlutterUIdartFrogBknd/uploads/amatungo/images/$imagename';

  final file = File(filePath);

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
