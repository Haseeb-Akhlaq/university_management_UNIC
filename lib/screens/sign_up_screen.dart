import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:university_management/styles/colors.dart';
import 'package:university_management/widgets/error_snackBar.dart';

import 'landing_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBlue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xff18384f),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
            child: SizedBox(
              width: 450,
              child: Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email = '';
  String? password = '';
  String? firstName = '';
  String? secondName = '';

  bool isLoading = false;

  registerWithEmail() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    email = email.toString().trim();

    setState(() {
      isLoading = true;
    });

    try {
      final authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      String userId = authResult.user!.uid;

      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (user.exists) {
        print(
            '$userId----------------------------------------------setting user ID------');
        return;
      } else {
        final result = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
          'email': authResult.user!.email,
          'userId': authResult.user!.uid,
          'name': firstName! + secondName!,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Account Created Successfully!!'),
      ));

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LandingScreen(),
            ),
            (Route<dynamic> route) => false);
      });
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
    return Container(
      alignment: Alignment.centerLeft,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'First Name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSaved: (v) {
                    firstName = v;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Last Name',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSaved: (v) {
                    secondName = v;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Second Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Email',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
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
              height: 20,
            ),
            const Text(
              'Password',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSaved: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid password';
                    }
                    if (value.length < 6) {
                      return 'Password Must be 6 characters long';
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
                        registerWithEmail();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Done',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: const [
                  Text(
                    'By Clicking "Sign Up". you accept',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Terms and Condition of Use',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
