
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: deviceSize.width > 500 ? 400 : deviceSize.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  'ShopUp',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontFamily: 'Anton',
                    fontSize: 50,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 30),
                const AuthCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {'email': '', 'password': ''};
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'No user found with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      _showErrorDialog('Could not authenticate you. Try again later.');
    }

    setState(() => _isLoading = false);
  }

  void _switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        height: _authMode == AuthMode.Signup ? 360 : 280,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.contains('@')) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be 6+ characters.';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value!,
              ),
              if (_authMode == AuthMode.Signup) ...[
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_person_outlined),
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 25),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _authMode == AuthMode.Login
                          ? 'Sign In'
                          : 'Create Account',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _switchAuthMode,
                child: Text(
                  _authMode == AuthMode.Login
                      ? "New to MyShop? Create an account"
                      : "Already have an account? Sign In",
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
