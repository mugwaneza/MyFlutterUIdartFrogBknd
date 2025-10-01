import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:ndagiza_dartapi/db.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;

  // Parse JSON body
  final payload = jsonDecode(await request.body()) as Map<String, dynamic>;
  final itunguui = payload['itunguui'];
  final abshuui_umworoz = payload['abshuui_umworoz'];
  final abshuui_uhagariy = payload['abshuui_uhagariy'];


  print('itunguui: $itunguui');
  print('abshuui_umworoz: $abshuui_umworoz');
  print('abshuui_uhagariy: $abshuui_uhagariy');


  bool alreadyAssigned = false;

  try {
    await db.transaction((ctx) async {
      final updated = await ctx.query(
        '''
      UPDATE amatungo.itungo_ukozororoka_abashumba
      SET abshuui_umworoz = @abshuui_umworoz,
          abshuui_uhagariy = @abshuui_uhagariy,
          riraragijwe_yo = 'YEGO',
          itariki_ariherewe = NOW()
      WHERE itunguui = @itunguui
        AND (abshuui_umworoz IS NULL)
        AND (abshuui_uhagariy IS NULL)
        AND (riraragijwe_yo <> 'YEGO')
      ''',
        substitutionValues: {
          'itunguui': itunguui,
          'abshuui_umworoz': abshuui_umworoz,
          'abshuui_uhagariy': abshuui_uhagariy,
        },
      );

      // Check number of rows affected
      if (updated.affectedRowCount == 0) {
        alreadyAssigned = true;
      }
    });

    // After transaction, return Response
    if (alreadyAssigned) {
      return Response.json(
        body: {'message': 'Itungo ryamaze kuragizwa abandi'},
        statusCode: 400,
      );
    }

    return Response.json(
      body: {'message': 'Itungo ryaragijwe neza!'},
      statusCode: 201,
    );

  } catch (e) {
    return Response.json(
      body: {'message': e.toString()},
      statusCode: 500,
    );
  }

}
