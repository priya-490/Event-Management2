// import 'package:flutter/material.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   static final _formKey = GlobalKey<FormState>();

//   const ForgotPasswordScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: LogoWithTitle(
//         title: 'Forgot Password',
//         subText:
//             "Integer quis dictum tellus, a auctorlorem. Cras in biandit leo suspendiss.",
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: Form(
//               key: _formKey,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'Phone',
//                   filled: true,
//                   fillColor: Color(0xFFF5FCF9),
//                   contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.0 * 1.5, vertical: 16.0),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.all(Radius.circular(50)),
//                   ),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 onSaved: (phone) {
//                   // Save it
//                 },
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               backgroundColor: const Color(0xFF00BF6D),
//               foregroundColor: Colors.white,
//               minimumSize: const Size(double.infinity, 48),
//               shape: const StadiumBorder(),
//             ),
//             child: const Text("Next"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LogoWithTitle extends StatelessWidget {
//   final String title, subText;
//   final List<Widget> children;

//   const LogoWithTitle(
//       {super.key,
//       required this.title,
//       this.subText = '',
//       required this.children});
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: LayoutBuilder(builder: (context, constraints) {
//         return SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             children: [
//               SizedBox(height: constraints.maxHeight * 0.1),
//               Image.network(
//                 "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
//                 height: 100,
//               ),
//               SizedBox(
//                 height: constraints.maxHeight * 0.1,
//                 width: double.infinity,
//               ),
//               Text(
//                 title,
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineSmall!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: Text(
//                   subText,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     height: 1.5,
//                     color: Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.64),
//                   ),
//                 ),
//               ),
//               ...children,
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Forgot Password"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeText(
              title: "Forgot password",
              text:
                  "Enter your email address and we will \nsend you a reset instructions.",
            ),
            SizedBox(height: 16),
            ForgotPassForm(),
          ],
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter your email address";
              }
              return null;
            },
            onSaved: (value) {},
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email Address"),
          ),
          const SizedBox(height: 16),

          // Reset password Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22A45D),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If all data are correct then save data to out variables
                _formKey.currentState!.save();
                Navigator.pushNamed(context, '/email_sent'); // Replace with your route

              }
            },
            child: const Text("Reset password"),
          ),
        ],
      ),
    );
  }
}
