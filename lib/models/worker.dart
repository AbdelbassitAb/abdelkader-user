class Workerr {

  String name;
  String uid;

  Workerr({this.name, this.uid});


  factory Workerr.fromMap(Map data) {
    return Workerr(
      uid: data['uid'],
      name: data['name'] ?? '',
    );
  }
}



