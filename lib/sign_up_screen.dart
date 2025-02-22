import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../home_screen.dart'; // Import your HomeScreen after sign-up
import '../home_screen.dart'; // Import your HomeScreen after sign-up

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedCountry;
  bool isLoading = false;

  // Future<void> signUp() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => isLoading = true);

  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );

  //     // Store user details in Firestore
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .set({
  //       'name': _nameController.text.trim(),
  //       'phone': _phoneController.text.trim(),
  //       'email': _emailController.text.trim(),
  //       'country': selectedCountry ?? '',
  //       'uid': userCredential.user!.uid,
  //     });

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: ${e.toString()}")),
  //     );
  //   }
  //   setState(() => isLoading = false);
  // }

  Future<void> signUp() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => isLoading = true);

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Store user details in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'country': selectedCountry ?? '',
      'uid': userCredential.user!.uid,
    });

    // Navigate to HomeScreen after successful sign-up
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
  setState(() => isLoading = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.network(
                "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                height: 100,
              ),
              const SizedBox(height: 30),
              Text(
                "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter your full name" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Enter a valid email" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Phone',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "Enter a valid phone number" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) => value!.length < 6
                          ? "Password must be at least 6 characters"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: selectedCountry,
                      items: countries,
                      icon: const Icon(Icons.expand_more),
                      onChanged: (value) {
                        setState(() => selectedCountry = value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Country',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading ? null : signUp,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF00BF6D),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const StadiumBorder(),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign Up"),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_in_screen');
                      },
                      child: Text.rich(
                        const TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(color: Color(0xFF00BF6D)),
                            ),
                          ],
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Country dropdown list
List<DropdownMenuItem<String>>? countries = [
  "Bangladesh",
  "Switzerland",
  'Canada',
  'Japan',
  'Germany',
  'Australia',
  'Sweden',
].map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(value: value, child: Text(value));
}).toList();
