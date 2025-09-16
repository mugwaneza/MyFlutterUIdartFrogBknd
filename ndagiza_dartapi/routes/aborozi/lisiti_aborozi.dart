import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
Future<Response> onRequest(RequestContext context) async {

  final result = await db.query('SELECT  abshuui ,izina_ryababyeyi,izina_rindi, igitsina, irangamimerere, nid, tel1, tel2, icyo_akora, icyo_ashinzwe, ahoatuye, ifoto_url, amasezerano_url from aborozi.abashumba');

  return Response.json(body: result);
}
