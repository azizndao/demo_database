import 'package:demo/data/database.dart';
import 'package:flutter/widgets.dart';

class Utilisateur {
  static const tableName = "utilisateur";

  final int id;
  final String prenom;
  final String nom;

  Utilisateur({this.id = 0, required this.prenom, required this.nom});

  static Utilisateur fromMap(Map<String, dynamic> value) {
    return Utilisateur(
      id: value['id'],
      prenom: value['prenom'],
      nom: value['nom'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "prenom": prenom,
      "nom": nom,
    };
  }

  static get sql {
    return """CREATE TABLE Utilisateur (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      prenom TEXT NOT NULL,
      nom TEXT NOT NULL
    )""";
  }
}

class UtilisateurRepository extends ChangeNotifier {
  Future<void> insertUsers(List<Utilisateur> users) async {
    final db = await getAppDatabase();
    for (var item in users) {
      db.insert(Utilisateur.tableName, item.toMap());
    }
  }

  Future<Utilisateur?> getUserById({required int id}) async {
    final db = await getAppDatabase();
    var result = await db.query(
      Utilisateur.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Utilisateur.fromMap(result.first);
  }

  Future<List<Utilisateur>> getUsers() async {
    final db = await getAppDatabase();
    final result = await db.query(
      Utilisateur.tableName,
      where: '',
      whereArgs: [],
    );
    return result.map((element) => Utilisateur.fromMap(element)).toList();
  }
}
