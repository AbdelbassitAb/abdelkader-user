import 'package:abdelkader_user/controlers/controler.dart';
import 'package:abdelkader_user/screens/constant.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = '';
  String password = '';
  String error = '';
  bool signIn = true;
  bool loading = false;
  final AuthService _auth = AuthService();
  final _key = GlobalKey<FormState>();
  final UserController userController = Get.put(UserController());

  @override

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: loading ? CircularProgressIndicator() : Container(
            width: size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: textinputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.blue,
                        ),
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                     validator: (val) =>
                          val.isEmpty ? 'Entrer un email svp' : null,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,

                      decoration: textinputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.blue,
                        ),
                        hintText: 'Mot de passe',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (val) => val.length < 6 ? 'Entrer un mot de passe 6+ caractère' : null,
                      onChanged: (val) => setState(() => password = val),
                    ),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Connecter',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          signIn = true;

                          if(_key.currentState.validate()){
                           setState((){
                             loading = true;

                           });
                           dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                           userController.chef.uid = _auth.uid;


                           if(result == null) {
                              setState(() {
                                signIn = false;
                                loading = false;
                                error = 'Veuillez vérifier vos informations svp';
                              });
                            }
                          }
                        }
                    ),
                    signIn ? SizedBox() : Text(error,style: TextStyle(color: Colors.red),)
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
