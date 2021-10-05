import 'package:abdelkader_user/components/inputDecoration.dart';
import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/controlers/controler.dart';
import 'package:abdelkader_user/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Center(
        child: loading ? CircularProgressIndicator() : Container(
          width: size.width * 0.8,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Kader',
                  style: TextStyle(color: primaryColor, fontSize: 45,fontWeight: FontWeight.bold),),

              Text('workplace',
                style: TextStyle(color: Colors.black, fontSize: 30),),
              ],
            ),

            SvgPicture.asset('assets/engineer.svg', height: MediaQuery
                .of(context)
                .size
                .height * 0.4,),


            TextFormField(
              decoration: textinputDecoration.copyWith(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: primaryColor,
                ),
                hintText: 'Email',

              ),
              validator: (val) =>
              val.isEmpty ? 'Entrer un email svp' : null,
              onChanged: (val) => setState(() => email = val),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,

              decoration: textinputDecoration.copyWith(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: primaryColor,
                ),
                hintText: 'Mot de passe',

              ),
              validator: (val) =>
              val.length < 6
                  ? 'Entrer un mot de passe 6+ caractère'
                  : null,
              onChanged: (val) => setState(() => password = val),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Connecter',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () async {
                  signIn = true;

                  if (_key.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.signInWithEmailAndPassword(
                        email, password);
                    userController.chef.uid = _auth.uid;


                    if (result == null) {
                      setState(() {
                        signIn = false;
                        loading = false;
                        error = 'Veuillez vérifier vos informations svp';
                      });
                    }
                  }
                }
            ),
            signIn ? SizedBox() : Text(
              error, style: TextStyle(color: Colors.red),)
            ],
        ),
      ),
    ),
          ),)
    ,
    )
    ,
    );
  }
}
