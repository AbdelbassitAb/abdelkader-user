class Chantier {
  final String name;
  Chantier({this.name});

  factory Chantier.fromMap(Map data) {
    return Chantier(
      name: data['name'],
    );
  }

}

