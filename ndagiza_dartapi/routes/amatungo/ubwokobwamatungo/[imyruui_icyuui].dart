
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
Future<Response> onRequest(RequestContext context, String uuid) async {

  if (uuid == null) {
    return Response.json(
      body: {'error': 'uuid is required'},
      statusCode: 400,
    );
  }
  final result = await db.query('SELECT '
      'imy.imyruui,imy.ubwokobwitungo, '
      'imy.imyakayokororoka, imy.ameziibyarira '
      'FROM amatungo.icyiciro  icy '
      'INNER JOIN amatungo.imyororokere '
      ' imy ON icy.icyuui = imy.imyruui_icyuui '
      'where imy.imyruui_icyuui= @uuid',
    substitutionValues: {
      'uuid': uuid,
    },
  );

  return Response.json(body: result);
}

