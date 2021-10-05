
class ChefData {
   String uid;
  final String name;
  final String email;
  final String numTlf;
  final double argent;
  final bool deleted;


  ChefData({this.uid, this.name, this.email, this.numTlf, this.argent,this.deleted,});

  factory ChefData.fromMap(Map data) {
    return ChefData(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      numTlf:  data['numTlf'] ?? '',
      argent: data['argent'],
      deleted: data['deleted'] ?? '',

    );
  }


}