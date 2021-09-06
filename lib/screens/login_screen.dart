import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:university_management/screens/sign_up_screen.dart';
import 'package:university_management/styles/colors.dart';
import 'package:university_management/widgets/error_snackBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email = '';
  String? password = '';
  bool isLoading = false;

  login() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      _formKey.currentState!.save();

      email = email.toString().trim();

      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } on FirebaseAuthException catch (error) {
      showErrorSnackBar(context, error.message!);
    } catch (e) {
      print(e);

      showErrorSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff18384f),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset('assets/images/logo.png'),
            SizedBox(
              width: 400,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                hintText: 'Email',
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid Email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              obscureText: true,
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                hintText: '**********',
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                password = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    login();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: AppColors.mainBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Dont Have an account ?',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
