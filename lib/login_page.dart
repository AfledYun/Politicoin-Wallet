import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:pblcwallet/stores/login_store.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.loginStore, {Key key, this.title}) : super(key: key);

  final LoginStore loginStore;
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.loginStore.reset();
    _accountController.value =
        TextEditingValue(text: widget.loginStore.accountId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // FlutterLogo(size: 150),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bkg1.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Sign In Now",
                        style: TextStyle(fontSize: 32.0, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please sign in below \n to use the Politicoin app wallet",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                SignInButton(
                  Buttons.Google,
                  text: "Sign in with Google",
                  onPressed: () async {
                    await widget.loginStore.attemptGoogleSignIn(context);
                  },
                ),
                SignInButton(
                  Buttons.Facebook,
                  text: "Sign in with Facebook",
                  onPressed: () async {
                    await widget.loginStore.attemptFacebookSignIn(context);
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Text(
                    "Make sure you have a different email account, in Google and Facebook!",
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "or enter your account id",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: TextField(
                    controller: _accountController,
                    autofocus: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xfff3f3f3),
                      labelText: 'account id',
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 15.0, top: 5.0, bottom: 5.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                    onChanged: widget.loginStore.setAccountId,
                    onSubmitted: (String value) async {
                      // apple review account
                      if (value == 'ZIE5Wkj1t3V0x5ZAMS3W4UI5mKz2') {
                        await widget.loginStore.attemptEmailSignIn(
                          context,
                          "apple-review@publicae.com",
                          "123456789",
                        );
                      } else {
                        // future functionality
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }
}
