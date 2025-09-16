import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }
  final body = await context.request.formData();
  final file = body.files['photo'];
  String? savedPath;

  if (file != null) {
    final imageDir = Directory('C:/MyFlutterUIdartFrogBknd/uploads/amatungo/images');
    if (!imageDir.existsSync()) {
      imageDir.createSync(recursive: true);
    }
    // Take extension from uploaded filename, fallback to mime
    final ext = p.extension(file.name);
    String extension = ext.isNotEmpty
        ? ext.replaceFirst('.', '') // strip "."
        : (file.contentType?.mimeType.split('/').last ?? 'bin');

    // Generate unique filename
    final now = DateTime.now();
    final filename =
        '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}.$extension';
    final filePath = p.join(imageDir.path, filename);
    final savedFile = File(filePath);
    savedPath = filePath.replaceAll(r'\', '/');
    await savedFile.writeAsBytes(await file.readAsBytes());

    print("Saved image at $savedPath");
  try {
      final result = await db.query(
          'SELECT count(itunguui) FROM amatungo.itungo');
      final count = result[0][0];
      final itungo = jsonDecode(body.fields['itungo']!) as Map<String, dynamic>;
      final ukozororoka = jsonDecode(body.fields['ukozororoka']!) as Map<String, dynamic>;
      final ubuzimabwaryo = jsonDecode(body.fields['ubuzimabwaryo']!) as Map<String, dynamic>;
      final isokoryaryo = jsonDecode(body.fields['isokoryaryo']!) as Map<String, dynamic>;


      try {
        await db.transaction((ctx) async {
          dynamic itngcode = itungo['itngcode'];
          if (itngcode == 'Inka' && count != null) {
            itngcode = 'INK0000${(count + 1).toString()}';
          } else if (itngcode == 'Ihene' && count != null) {
            itngcode = 'IHE0000${(count + 1).toString()}';
          }
          else if (itngcode == 'Inkoko' && count != null) {
            itngcode = 'KOK0000${(count + 1).toString()}';
          }
          else if (itngcode == 'Intama' && count != null) {
            itngcode = 'INT0000${(count + 1).toString()}';
          }

          // Insert itungo
          final userResult = await ctx.query(
            'INSERT INTO amatungo.itungo (itunguui_imyruui, igitsina, ifoto_url, ubukure, itngcode, ibara) VALUES (@itunguui_imyruui, @igitsina, @ifoto_url, @ubukure, @itngcode, @ibara) RETURNING itunguui',
            substitutionValues: {
              'itunguui_imyruui': itungo['itunguui_imyruui'],
              'igitsina': itungo['igitsina'],
              'ifoto_url': filename,
              'ubukure': itungo['ubukure'],
              'itngcode': itngcode,
              'ibara': itungo['ibara']
            },
          );

          print("itunguui_imyruui: ${itungo['itunguui_imyruui']}");

          final itunguui = userResult.first[0];
          print('returnedId $itunguui');
          dynamic ukoz = ukozororoka['ukozruui'];
          print('ukozzzzz $ukoz');


          // Insert itungo_ukozororoka_abashumba
          await ctx.query(
            'INSERT INTO amatungo.itungo_ukozororoka_abashumba (itunguui, ukozruui) VALUES (@itunguui, @ukozruui)',
            substitutionValues: {
              'itunguui': itunguui,
              'ukozruui': ukozororoka['ukozruui'],
            },
          );

          // Insert itungoubuzimabwaryo
          await ctx.query(
            'INSERT INTO amatungo.itungo_ubuzimabwaryo (itunguui, uzmuui) VALUES (@itunguui, @uzmuui)',
            substitutionValues: {
              'itunguui': itunguui,
              'uzmuui': ubuzimabwaryo['uzmuui'],
            },
          );

          // Insert itungoisokoryaryo
          await ctx.query(
            'INSERT INTO amatungo.itungo_isokoryaryo (itunguui, amafaranga_rihagaze, iskuui) VALUES (@itunguui, @amafaranga_rihagaze, @isoko)',
            substitutionValues: {
              'itunguui': itunguui,
              'amafaranga_rihagaze': isokoryaryo['amafaranga_rihagaze'],
              'isoko': isokoryaryo['isoko'],
            },
          );
        });
      } catch (e, stackTrace) {
        print('Error: $e');
        print('Stack trace: $stackTrace');
      }
      return Response.json(
        body: {'message': 'Form submitted successfully'},
        statusCode: 201,
      );
    } catch (e) {
      return Response.json(
        body: {'error': 'Failed to submit form', 'details': e.toString()},
        statusCode: 500,
      );
    }
  } else{

    return Response.json(
      body: {'error': 'No photo uploaded'},
      statusCode: 400,
    );
  }
}

