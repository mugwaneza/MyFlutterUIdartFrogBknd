
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
Future<Response> onRequest(RequestContext context, String uuid) async {

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

