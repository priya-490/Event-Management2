import 'package:flutter/material.dart';
import 'sign_in_screen.dart'; // Import your SignInScreen
import 'home_screen.dart';
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

  void navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
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
              Image.asset(
                "assets/logo.jpg", // Replaced network image with local asset
                height: 100,
                fit: BoxFit.contain,
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
                      onPressed: isLoading ? null : navigateToSignIn,
                      //here i made change 
    //                   onPressed: isLoading
    // ? null
    // : () {
    //     if (_formKey.currentState!.validate()) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => const HomeScreen()),
    //       );
    //     }
    //   },

                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFbc6c25),
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
                      onPressed: navigateToSignIn,
                      child: Text.rich(
                        const TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(color: Color(0xFFbc6c25)),
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
  "India",
  "Korea",
  'Canada',
  'Japan',
  'Germany',
  'Australia',
  'Sweden',
].map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(value: value, child: Text(value));
}).toList();
