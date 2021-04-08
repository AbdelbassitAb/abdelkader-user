import 'package:abdelkader_user/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abdelkader_user/models/chef.dart';
import 'package:abdelkader_user/services/database.dart';

class AuthService {
  String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Chef _userFromFirebaseUser(User user) {
    return user != null ? Chef(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Chef> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String numTlf, double money,String pic) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      // create a new document for the user with a uniq uid
      await DatabaseService(uid: user.uid)
          .updateUserData(user.uid, name, email, numTlf, money,false,pic: pic);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print('error');
      //print(error.toString());
      return null;
    }
  }


  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      uid = user.uid;


      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
