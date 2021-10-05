class TR {
  final String uid;
  final String name;
  final String description;
  final String time;
  final double argent;
  final double somme;
  final String type;
  final String chantier;
  final String workerName;
  final String workerId;
  final bool deleted;

  TR(
      {this.uid,
        this.name,
        this.type,
        this.chantier,
        this.description,
        this.time,
        this.argent,
        this.somme,
        this.workerName,
        this.workerId,
        this.deleted});

  factory TR.fromMap(Map data) {
    return TR(
      uid: data['uid'],
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      time: data['time'] ?? '',
      type: data['type'] ?? '',
      chantier: data['chantier'] ?? '',
      argent: data['argent'] ?? '',
      deleted: data['deleted'] ?? '',
      somme: data['somme'] ?? '',
      workerId: data['workerId'] ?? '',
      workerName: data['workerName'] ?? '',
    );
  }
}
