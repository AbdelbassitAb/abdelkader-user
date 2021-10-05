class Chef {
   String uid;
   String name;
  Chef({this.uid,this.name});

  factory Chef.fromMap(Map data) {
    return Chef(
      uid: data['uid'],
      name: data['name'],
    );
  }


}

