import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
Future<Response> onRequest(RequestContext context) async {
  final result = await db.query('''
    SELECT 
      i.itunguui,                -- 0
      i.itunguui_imyruui,        -- 1
      i.igitsina,                -- 2
      i.ibara,                   -- 3
      i.ifoto_url,               -- 4
      i.ubukure,                 -- 5
      i.itngcode,                -- 6
      i.ibiro,                   -- 7
      i.ahoryavuye,              -- 8
      uab.ukozruui,              -- 9
      ub.uzmuui,                 -- 10
      iso.amafaranga_rihagaze,   -- 11
      iso.iskuui,                -- 12
      imyr.ubwokobwitungo,       -- 13
      i.igihe                    -- 14
    FROM amatungo.itungo i
    LEFT JOIN amatungo.itungo_ukozororoka_abashumba uab
         ON i.itunguui = uab.itunguui
    LEFT JOIN amatungo.itungo_ubuzimabwaryo ub
         ON i.itunguui = ub.itunguui
    LEFT JOIN amatungo.itungo_isokoryaryo iso
         ON i.itunguui = iso.itunguui
    LEFT JOIN amatungo.imyororokere imyr
         ON i.itunguui_imyruui = imyr.imyruui
   ''');

// Map each row to JSON
  final data = result.map((row) => {
    'itunguui': row[0],
    'itunguui_imyruui': row[1],
    'igitsina': row[2],
    'ibara': row[3],
    'ifoto_url': row[4],
    'ubukure': row[5],
    'itngcode': row[6],
    'ibiro': row[7],
    'ahoryavuye': row[8],
    'ukozruui': row[9],
    'uzmuui': row[10],
    'amafaranga_rihagaze': row[11],
    'iskuui': row[12],
    'ubwokobwitungo': row[13],
    'igihe': '${row[14]?.year}-${row[14]?.month.toString().padLeft(2, '0')}-${row[14]?.day.toString().padLeft(2, '0')}'
  }).toList();

  return Response.json(body: data);

}
