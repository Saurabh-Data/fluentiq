import 'package:fluentIQ/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { signUp, logIn, reset }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool obstructPassword = true;
  bool obstructConfirmPassword = true;
  AuthMode _authMode = AuthMode.logIn;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  resetPassword() async {
    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill all the fields.'),
      ));
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim())
          .then((value) =>
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Password reset link sent to your email!'),
          )));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  login() async {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill all the fields.'),
      ));
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text, password: password.text);
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (_) => const HomeScreen()));
      } else {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email not verified!'),
        ));
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = error.toString();
      if (error.toString().contains('invalid-email')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('invalid-credential')) {
        errorMessage = 'Invalid login credentials.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  signup() async {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill all the fields!'),
      ));
      return;
    }
    if (password.text.trim() != confirmPassword.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Re-enter same password!'),
      ));
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.text, password: password.text)
          .then((value) async {
        await FirebaseAuth.instance.currentUser
            ?.sendEmailVerification()
            .then((value) {
          setState(() {
            _authMode = AuthMode.logIn;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Verification link sent to your email!',
                      style: TextStyle(letterSpacing: 1, color: Colors.white)),
                  Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              backgroundColor: Colors.black87,
              duration: Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      });
    } on FirebaseAuthException catch (error) {
      var errorMessage = error.toString();
      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('invalid-email')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'Password is too weak (minimum 6 characters).';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('FluentIQ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black87,
                    )),
                SizedBox(height: 10),
                Text(
                  _authMode == AuthMode.logIn
                      ? 'Login Here'
                      : _authMode == AuthMode.signUp
                      ? 'Register Here'
                      : 'Reset Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  _authMode == AuthMode.logIn
                      ? 'Login with your email-id & password'
                      : _authMode == AuthMode.signUp
                      ? 'Create your account with email-id & password'
                      : 'Enter your registered email to get password reset link',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 9),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.blue,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_authMode != AuthMode.reset)
                  TextFormField(
                    obscureText: obstructPassword,
                    controller: password,
                    cursorColor: Colors.blue,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obstructPassword = !obstructPassword;
                          });
                        },
                        icon: Icon(obstructPassword == false
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                if (_authMode == AuthMode.logIn)
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _authMode = AuthMode.reset;
                        });
                      },
                      child: Text('Forgot Password?',
                          style: TextStyle(color: Colors.black54)),
                    ),
                  ),
                if (_authMode == AuthMode.signUp) const SizedBox(height: 10),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    obscureText: obstructConfirmPassword,
                    controller: confirmPassword,
                    cursorColor: Colors.blue,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obstructConfirmPassword = !obstructConfirmPassword;
                          });
                        },
                        icon: Icon(obstructConfirmPassword == false
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                if (_authMode == AuthMode.signUp) const SizedBox(height: 10),
                isLoading
                    ? const Center(
                    child:
                    CircularProgressIndicator(color: Colors.lightBlue))
                    : ElevatedButton(
                  onPressed: () => _authMode == AuthMode.logIn
                      ? login()
                      : _authMode == AuthMode.signUp
                      ? signup()
                      : resetPassword(),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 15,
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(_authMode == AuthMode.logIn
                      ? 'Login'
                      : _authMode == AuthMode.signUp
                      ? 'Sign Up'
                      : 'Send Link'),
                ),
                const SizedBox(height: 25),
                Text(
                  _authMode == AuthMode.logIn
                      ? 'Don\'t have an account?'
                      : _authMode == AuthMode.signUp
                      ? 'Already have an account?'
                      : 'Don\'t want to reset password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    '${_authMode == AuthMode.logIn ? 'SIGN-UP' : 'LOGIN'} INSTEAD',
                    style: const TextStyle(
                        color: Colors.lightBlue,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
