//database.dart
import 'dart:async';

import 'package:todolist/data/medicament.dart';
import 'package:todolist/data/utilisateur.dart';
import 'package:todolist/data/vente.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

/// Ici on create une connection à la base de données.
/// Il faut noter que tu ne doit avoir qu'une seule connection a la db pour
/// toute l'application
Future<Database> getAppDatabase() async {
  final dbDirecotory = await getDatabasesPath();
  final dbPath = path.join(dbDirecotory, 'demo.db');

  return openDatabase(
    dbPath,
    version: 1,
    onCreate: initializeDatabase,
  );
}

/// Ici on create le schema de la base de données
FutureOr<void> initializeDatabase(Database db, int version) async {
  // 1
  await db.execute(Utilisateur.sql);
  // 2
  await db.execute(Medicament.sql);
  // 3
  await db.execute(Vente.sql);
  // ...
}
