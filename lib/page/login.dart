import 'package:flutter/material.dart';
import 'package:qr_code_scanner_example/page/qr_scan_page.dart';
import 'package:qr_code_scanner_example/repos/auth.dart';
import 'package:qr_code_scanner_example/widget/flare_sized_circular_progress_indicator.dart';
import 'package:qr_code_scanner_example/widget/flare_text_form_field..dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image(image: AssetImage('assets/images/logo.jpg')),
                ),
              ),
              SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _authRepo = AuthRepo();
  String email;
  String password;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  @override
  Widget build(BuildContext context) {
    final _emailField = FlareTextFormField(
      labelText: "Email",
      hintText: "jamesbond@cia.com",
      onSaved: (value) {
        email = value;
      },
      validator: (value) {
        if (!_validateEmail(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
    );

    final _passwordField = FlareTextFormField(
      labelText: "Password",
      obscureText: true,
      onSaved: (value) {
        password = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a password";
        }
        return null;
      },
    );

    final _signInButton = ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  _formKey.currentState.save();
                  _authRepo
                      .signIn(email: email, password: password)
                      .then((success) {
                    if (success) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRScanPage()));
                    } else {
                      final snackBar = SnackBar(
                          content: Text(
                              "Sorry, the credentials weren't correct. Please try again."),
                          backgroundColor: Theme.of(context).errorColor);
                      Scaffold.of(context).showSnackBar(snackBar);
                      _formKey.currentState.reset();
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                }
              },
        child: _isLoading
            ? FlareSizedCircularProgressIndicator(size: 16)
            : Text("Sign In"));

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            _emailField,
            SizedBox(height: 16),
            _passwordField,
            SizedBox(height: 24),
            _signInButton
          ],
        ),
      ),
    );
  }
}
