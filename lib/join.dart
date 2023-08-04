import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => JoinPage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Now'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/background_image.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          JoinForm(),
        ],
      ),
    );
  }
}

class JoinForm extends StatefulWidget {
  @override
  _JoinFormState createState() => _JoinFormState();
}

class _JoinFormState extends State<JoinForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _acceptLicense = false;

  String? _validateEmail(String email) {
    if (!email.contains('@')) {
      return 'Invalid email address';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String name = nameController.text;
      String surname = surnameController.text;
      String email = emailController.text;
      String phoneNumber = phoneNumberController.text;
      String password = passwordController.text;

      if (_acceptLicense) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = userCredential.user;
          if (user != null) {
            // Send email verification
            await user.sendEmailVerification();

            // Show success message to the user
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Verification Email Sent'),
                  content: Text('An email verification link has been sent to your email address. Please verify your email before logging in.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } catch (e) {
          print('Sign-up error: $e');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Sign-up Error'),
                content: Text('An error occurred during sign-up. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('License Agreement'),
              content: Text('Please read and accept the license agreement before submitting the form.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/Majesty_logo.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 8),
                ],
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'Surname',
                  filled: true,
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  filled: true,
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(),
                ),
                validator: (email) => _validateEmail(email ?? ''),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.amber,
                  border: OutlineInputBorder(),
                ),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Add any password validation logic you need here
                  // e.g., minimum length, special characters, etc.
                  return null;
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: InternationalPhoneNumberInput(
                    keyboardType: TextInputType.phone,
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {},
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET, // Use bottom sheet for country selection
                      setSelectorButtonAsPrefixIcon: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    inputDecoration: InputDecoration(
                      labelText: 'Telephone Number',
                      border: InputBorder.none,
                    ),
                    selectorTextStyle: TextStyle(color: Colors.black), // Style of the selected country text
                    searchBoxDecoration: InputDecoration(
                      hintText: 'Search for a country',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    validator: (phoneNumber) {
                      if (phoneNumber == null || phoneNumber.isEmpty) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // License Agreement Section
              Text(
                'License Agreement:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              Text(
                'By submitting this form, you agree to participate in e-sports activities, subject to abiding by club rules and respect our terms and conditions.',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _acceptLicense,
                    onChanged: (value) {
                      setState(() {
                        _acceptLicense = value ?? false;
                      });
                    },
                  ),
                  Text('I have read and accepted the license', style: TextStyle(color: Colors.white)),
                ],
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
