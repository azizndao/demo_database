import 'package:demo/data/medicament.dart';
import 'package:demo/data/utilisateur.dart';

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
