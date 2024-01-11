import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // API pendaftaran atau logic lainnya bisa diimplementasikan di sini
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? _name;
    String? _email;
    String? _password;
    String? _phone;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0,
                top: 20.0,
                right: 30.0), // Add padding for the title section
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign Up',
                  textAlign:
                      TextAlign.center, // Align text to center horizontally
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Sign up now to take control of your glucose management',
                  textAlign:
                      TextAlign.center, // Align text to center horizontally
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    TextFormField(
                      focusNode: _nameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                      ),
                      onSaved: (value) => _name = value,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      focusNode: _emailFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                      ),
                      obscureText: true,
                      onSaved: (value) => _password = value,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      focusNode: _phoneFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                      ),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => _phone = value,
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      child: Text('Sign Up'),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF715C0C),
                          onPrimary: Colors.white,
                          minimumSize: Size(double.infinity, 36),
                          padding: EdgeInsets.symmetric(vertical: 12.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        child: Text(
                          'Already have an account? Log In',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          // Pastikan ini mengarah ke LoginPage yang sudah ada
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
