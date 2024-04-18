import 'package:flutter/material.dart';
import 'login.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../color_schemes.g.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedRole;
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signing in...'),
        duration: Duration(seconds: 2),
      ),
    );

    int roleValue = _selectedRole == 'Patient'
        ? 0
        : _selectedRole == 'Doctor'
        ? 1
        : _selectedRole == 'Volunteer'
        ? 2
        : 3;

    var response = await http.post(
      Uri.parse(
          'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ID': 0,
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'role': roleValue,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userID', data['ID'].toString());
      await prefs.setInt(
          'lastLoginTime', DateTime.now().millisecondsSinceEpoch);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to register user: ${json.decode(response.body)['message']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Sign up now to take control of your glucose management',
                  textAlign: TextAlign.center,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Use theme color
                        border: _border(Colors.grey),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary), // Use theme color
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'I am a',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Use theme color
                        border: _border(Colors.grey),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary), // Use theme color
                      ),
                      value: _selectedRole,
                      items: <String>[
                        'Patient',
                        'Volunteer',
                        'Relation'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Ensure the current state is updated
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                      onSaved: (String? newValue) {
                        _selectedRole = newValue!;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Use theme color
                        border: _border(Colors.grey),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary), // Use theme color
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Use theme color
                        border: _border(Colors.grey),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary), // Use theme color
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).colorScheme.primary, // Use theme color
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Use theme color
                        border: _border(Colors.grey),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary), // Use theme color
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      child: Text('Sign Up'),
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary, // Use theme color
                        onPrimary: Colors.white,
                        minimumSize: Size(double.infinity, 36),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary, // Use theme color
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
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
