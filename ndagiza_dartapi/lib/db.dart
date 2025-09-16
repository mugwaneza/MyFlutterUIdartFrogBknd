import 'package:postgres/postgres.dart';
import 'env.dart'; // for env['DB_HOST'] etc

late final PostgreSQLConnection db;

Future<void> connectToDatabase() async {
  db = PostgreSQLConnection(
    env['DB_HOST'] ?? 'localhost',
    int.parse(env['DB_PORT'] ?? '5432'),
    env['DB_NAME'] ?? 'ndagiza_nangedb',
    username: env['DB_USER'],
    password: env['DB_PASSWORD'],
  );

  await db.open();
  print('✅ Connected to DB');

}
