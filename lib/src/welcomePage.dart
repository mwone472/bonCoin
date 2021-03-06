import 'package:bonCoin/services/auth.dart';
import 'package:bonCoin/src/loginPage.dart';
import 'package:bonCoin/src/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;
  String error = '';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  FacebookLogin facebookLogin = new FacebookLogin();
  AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget _googleButton() {
    return GestureDetector(
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('G',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Continuer avec Google',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        _onLoading();
        dynamic result = await AuthService().loginWithGoogle();
        if (result == null) {
          setState(() {
            widget.error = 'Impossible de se connecter avec ces identifiants';
          });
        } else {
          // Navigator.of(context).pushReplacementNamed('/home');
        }
      },
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('ou'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    String phone;
    return GestureDetector(
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  LineIcons.phone,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('S\'inscrire avec un numéro',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Alert(
          context: context,
          buttons: [
            DialogButton(
              child: Text(
                "Valider",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                if (_fbKey.currentState.saveAndValidate()) {
                  await AuthService().loginWithPhoneNumber(phone, context);
                  // print(_fbKey.currentState.value);
                  // print(phone);
                } else {
                  print(_fbKey.currentState.value);
                  print('validation failed');
                }
              },
              width: 120,
            )
          ],
          title: 'Test',
          content: FormBuilder(
            key: _fbKey,
            readOnly: false,
            child: Column(
              children: [
                FormBuilderPhoneField(
                  defaultSelectedCountryIsoCode: 'SN',
                  attribute: 'phone_number',
                  // defaultSelectedCountryIsoCode: 'KE',
                  cursorColor: Colors.black,
                  // style: TextStyle(color: Colors.black, fontSize: 18),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Téléphone',
                  ),
                  onSaved: (val) {
                    setState(() {
                      phone = val;
                    });
                  },
                  priorityListByIsoCode: ['SN'],
                  validators: [
                    FormBuilderValidators.numeric(errorText: 'Numéro invalide'),
                    FormBuilderValidators.required(
                        errorText: 'Ce champ est obligatoire')
                  ],
                ),
                // SizedBox(
                //   height: 10.0,
                // ),
                // MaterialButton(
                //   color: Theme.of(context).accentColor,
                //   child: Text(
                //     'Submit',
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   onPressed: () {
                //     if (_fbKey.currentState.saveAndValidate()) {
                //       print(_fbKey.currentState.value);
                //     } else {
                //       print(_fbKey.currentState.value);
                //       print('validation failed');
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ).show();
      },
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'bon',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'C',
              style: TextStyle(color: Colors.deepOrange, fontSize: 30),
            ),
            TextSpan(
              text: 'oin',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  void _onLoading() {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("  Connection...")
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: Colors.white,
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [Colors.indigo[500], Colors.indigo[700]],
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              SizedBox(
                height: 80,
              ),
              _googleButton(),
              SizedBox(
                height: 20,
              ),
              _divider(),
              _facebookButton(),
              SizedBox(
                height: 50,
              ),
              // FlatButton(
              //     onPressed: () {
              //       Alert(context: context, title: 'null', type: AlertType.info)
              //           .show();
              //     },
              //     child: Text('tap')),
              Text(
                widget.error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
