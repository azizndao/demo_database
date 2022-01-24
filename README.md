# demo

Une application to demontrer comment se connecter à une base de données de maniere efficasse.

## Getting Started

Dans ce projet on utilisera les dependances suisant.

- [sqlfite](https://pub.dev/packages/sqflite) c'est le package SQLite le plus populaire. Pour l'installer 
```bash
flutter pub add sqflite
```
- [Provider](https://pub.dev/packages/provider) qui nous permettra de garder une même instance de notre base de données durant tout la cicle de vie de l'application. Pour l'installer 
```bash
flutter pub add provider
```

## Connection à la base
Pour connecter à la base de données, il faut en premier recuperer le schemes puis `future` gère plusieur plateformes qui ont chac'une sa propre maniere ses données. Le extrait de code suivant nous montre comment faire.
```dart
import 'package:path/path.dart' as path;

// On recupère le repertoire de base de données de notre app.
final dbDirecotory = await getDatabasesPath();
// On ajoute en suite le nom de base.
final dbPath = path.join(dbDirecotory, 'demo.db');
```  
Ensuite if faut ouvrir une session de connection.
```dart
import 'package:sqflite/sqflite.dart';

final datbase  = await openDatabase(
    dbPath,
    version: 1,
    onCreate: initializeDatabase,
);
```
Lors de la connection, on a la possibilité de lui donner de callbacks qui vont s'executer en des moment bien precis. Nous ce qui nous conserne c'est créer notre schema de base lors de notre premier connection, Pour se faire on definit la fonction suivante
```dart
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
```
En somme on a dans le fichier database.dart le code suivant.
```dart
import 'dart:async';

import 'package:demo/data/medicament.dart';
import 'package:demo/data/utilisateur.dart';
import 'package:demo/data/vente.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

/// Ici on create une connection à la base de données.
/// Il faut noter que tu ne doit avoir qu'une seule connection a la db pour
/// toute l'application
Future<Database> openAppDatabase() async {
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
```
J'ai choisi de mettre le code sql permettant de créer chaque table dans la class correspondant par soucci de simplicité.
```dart
// utilisateur.dart
class Utilisateur {
  final int id;
  final String prenom;
  final String nom;

  Utilisateur({this.id = 0, required this.prenom, required this.nom});

  static get sql {
    return """CREATE TABLE Utilisateur (
      id INTEGER PRIMARY KEY AUTO_INCREMENT,
      prenom TEXT NOT NULL,
      nom TEXT NOT NULL
    )""";
  }
}

// medicament.dart
class Medicament {
  final int id;
  final String nom;
  final String prix;

  Medicament({this.id = 0, required this.nom, required this.prix});

  static get sql {
    return """CREATE TABLE Utilisateur (
      id INTEGER PRIMARY KEY AUTO_INCREMENT,
      nom TEXT NOT NULL,
      prix DOUBLE NOT NULL
    )""";
  }
}

// vente.dart
class Vente {
  final int id;
  final Medicament medicament;
  final Utilisateur utilisateur;

  Vente({this.id = 0, required this.medicament, required this.utilisateur});

  static get sql {
    return """CREATE TABLE Utilisateur (
      id INTEGER PRIMARY KEY AUTO_INCREMENT,
      id_medicament INTEGER NOT NULL,
      id_utilisateur INTEGER NOT NULL,
    )""";
  }
}

```
Pour utiliser la DB dans l'application. Je package [Provider](https://pub.dev/packages/provider) qui me permettant garder la même connection a la DB, mais aussi l possibilié d'appeler la DB partout dans l'application.
```dart
void main() {
  runApp(
    FutureProvider<Database?>(
      create: (_) => openAppDatabase(),
      initialData: null,
      child: const MyApp(),
    ),
  );
}
```
Pour recuperer la DB il faut failte 
```dart
var database = Provider.of<Database?>(context)
```