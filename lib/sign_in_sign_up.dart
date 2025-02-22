import 'package:flutter/material.dart';

class SigninOrSignupScreen extends StatelessWidget {
  const SigninOrSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.network(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "https://i.postimg.cc/nz0YBQcH/Logo-light.png"
                    : "https://i.postimg.cc/MHH0DKv1/Logo-dark.png",
                height: 146,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                 Navigator.pushNamed(context, '/sign_in_screen');

                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF00BF6D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Sign In"),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/sign_up_screen');

                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFFE9901)),
                child: const Text("Sign Up"),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
