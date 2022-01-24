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
