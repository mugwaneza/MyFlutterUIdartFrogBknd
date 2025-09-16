import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'dart:typed_data';

Future<Response> onRequest(RequestContext context) async {

  final request = context.request;

  if (request.method != HttpMethod.post) {
    return Response.json(statusCode: 405, body: {'error': 'Method not allowed'});
  }
  final formData = await request.formData();
  // Retrieve fields
  final izina_ryababyeyi = formData.fields['izina_ryababyeyi'];
  final izina_rindi = formData.fields['izina_rindi'];
  final igitsina = formData.fields['igitsina'];
  final nid = formData.fields['nid'];
  final tel1 = formData.fields['tel1'];
  final tel2 = formData.fields['tel2'];
  final icyo_akora = formData.fields['icyo_akora'];
  final icyo_ashinzwe = formData.fields['icyo_ashinzwe'];
  final ahoatuye = formData.fields['ahoatuye'];

  // Define storage paths
  final basePath = Directory('C:/MyFlutterUIdartFrogBknd/uploads/aborozi'); // Adjust as needed
  final imageDir = Directory(p.join(basePath.path, 'images'));
  final docsDir = Directory(p.join(basePath.path, 'docs'));

  if (!await imageDir.exists()) await imageDir.create(recursive: true);
  if (!await docsDir.exists()) await docsDir.create(recursive: true);

  final now = DateTime.now();
  final timestamp ='${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  final stat_filepath = "C:/MyFlutterUIdartFrogBknd/uploads/aborozi/docs/";
  final stat_imagepath = "C:/MyFlutterUIdartFrogBknd/uploads/aborozi/images/";

  // Save image
  String? imagePath;

  final imageFile = formData.files['image'];
  if (imageFile != null) {

    final nameWithoutExtension = p.basenameWithoutExtension(imageFile.name ?? 'unnamed');
    final extension = p.extension(imageFile.name ?? '');
    final imageName = '${nameWithoutExtension}_$timestamp$extension';
    final Path = p.join(stat_imagepath, imageName);
    await File(Path).writeAsBytes(await imageFile.readAsBytes());
    imagePath = Path;
  }

  // Save documents
  final docPaths = <String>[];

  final multipleDocs = formData.files.entries
      .where((entry) => entry.key.startsWith('documents['));
  print('files>>>>>>>> ${formData.files.keys}');
  for (final entry in multipleDocs) {
    final doc = entry.value;

    final nameWithoutExtension = p.basenameWithoutExtension(doc.name ?? 'unnamed');
    final extension = p.extension(doc.name ?? '');
    final fileName = '${nameWithoutExtension}_$timestamp$extension';

    final docPath = p.join(stat_filepath, fileName);

    final file = File(docPath);
    final bytes = await doc.readAsBytes();
    await file.writeAsBytes(bytes);
    docPaths.add(docPath);

  }

// Save to PostgreSQL
  try {
    await db.transaction((ctx) async {
      await ctx.query(
        'INSERT INTO aborozi.abashumba (izina_ryababyeyi, izina_rindi, igitsina, nid, tel1, tel2, icyo_akora, icyo_ashinzwe, ahoatuye, ifoto_url, amasezerano_url) VALUES '
            '(@izina_ryababyeyi, @izina_rindi, @igitsina, @nid, @tel1, @tel2, @icyo_akora, @icyo_ashinzwe, @ahoatuye, @ifoto_url, @amasezerano_url)',
        substitutionValues: {
          'izina_ryababyeyi': izina_ryababyeyi,
          'izina_rindi': izina_rindi,
          'igitsina': igitsina,
          'nid': nid,
          'tel1': tel1,
          'tel2': tel2,
          'icyo_akora': icyo_akora,
          'icyo_ashinzwe': icyo_ashinzwe,
          'ahoatuye': ahoatuye,
          'ifoto_url': imagePath,
          'amasezerano_url': docPaths,
        },
      );
    });

    return Response.json(statusCode: 201, body: {'message': 'Saved successfully'});
  } catch (e) {
    print("DB Error: $e");
    return Response.json(statusCode: 500, body: {'error': 'DB Error', 'details': e.toString()});
  }
}






