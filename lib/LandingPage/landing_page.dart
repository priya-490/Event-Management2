// import 'package:flutter/material.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   int currentPage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const Spacer(flex: 2),
//             Expanded(
//               flex: 14,
//               child: PageView.builder(
//                 itemCount: demoData.length,
//                 onPageChanged: (value) {
//                   setState(() {
//                     currentPage = value;
//                   });
//                 },
//                 itemBuilder: (context, index) => OnboardContent(
//                   illustration: demoData[index]["illustration"],
//                   title: demoData[index]["title"],
//                   text: demoData[index]["text"],
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 demoData.length,
//                 (index) => DotIndicator(isActive: index == currentPage),
//               ),
//             ),
//             const Spacer(flex: 2),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/sign_in_sign_up');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF22A45D),
//                   foregroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 40),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text("Get Started".toUpperCase()),
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OnboardContent extends StatelessWidget {
//   const OnboardContent({
//     super.key,
//     required this.illustration,
//     required this.title,
//     required this.text,
//   });

//   final String? illustration, title, text;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Image.network(
//               illustration!,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           title!,
//           style: Theme.of(context)
//               .textTheme
//               .titleLarge!
//               .copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           text!,
//           style: Theme.of(context).textTheme.bodyMedium,
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
// }

// class DotIndicator extends StatelessWidget {
//   const DotIndicator({
//     super.key,
//     this.isActive = false,
//     this.activeColor = const Color(0xFF22A45D),
//     this.inActiveColor = const Color(0xFF868686),
//   });

//   final bool isActive;
//   final Color activeColor, inActiveColor;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       margin: const EdgeInsets.symmetric(horizontal: 16 / 2),
//       height: 5,
//       width: 8,
//       decoration: BoxDecoration(
//         color: isActive ? activeColor : inActiveColor.withOpacity(0.25),
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//       ),
//     );
//   }
// }

// // Demo data for our Onboarding screen
// List<Map<String, dynamic>> demoData = [
//   {
//     "illustration": "https://i.postimg.cc/L43CKddq/Illustrations.png",
//     "title": "All your favorites",
//     "text":
//         "Order from the best local restaurants \nwith easy, on-demand delivery.",
//   },
//   {
//     "illustration": "https://i.postimg.cc/xTjs9sY6/Illustrations-1.png",
//     "title": "Free delivery offers",
//     "text":
//         "Free delivery for new customers via Apple Pay\nand others payment methods.",
//   },
//   {
//     "illustration": "https://i.postimg.cc/6qcYdZVV/Illustrations-2.png",
//     "title": "Choose your food",
//     "text":
//         "Easily find your type of food craving and\nyou’ll get delivery in wide range.",
//   },
// ];


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < demoData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/get_notification');
    }
  }

  void skipToMainPage() {
    Navigator.pushReplacementNamed(context, '/get_notification');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: skipToMainPage,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: PageView.builder(
                controller: _pageController,
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder:
                    (context, index) => OnboardContent(
                      illustration: demoData[index]["illustration"],
                      title: demoData[index]["title"],
                      text: demoData[index]["text"],
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: nextPage,
                    backgroundColor: const Color(0xFF780000),
                    child: const Icon(Icons.arrow_right_alt, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onboarding Content
class OnboardContent extends StatelessWidget {
  final String? illustration;
  final String title;
  final String text;

  const OnboardContent({
    Key? key,
    required this.illustration,
    required this.title,
    required this.text,
  }) : super(key: key);

  Widget imageWidget(String? path) {
  if (path == null || path.isEmpty) {
    return const SizedBox(); // Return an empty widget if path is null
  }
  if (path.endsWith(".svg")) {
    return SvgPicture.asset(
      path,
      height: 250,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => const CircularProgressIndicator(), // Placeholder while loading
    );
  } else {
    return Image.asset(
      path,
      height: 250,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100, color: Colors.red),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        illustration != null && illustration!.startsWith("http")
            ? Image.network(illustration!, height: 250, fit: BoxFit.contain)
            : imageWidget(illustration!),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// Dot Indicator
class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.activeColor =const Color(0xFF780000),
    this.inActiveColor = Colors.grey,
  });

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: isActive ? 18 : 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// Onboarding Data
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/campus_events.svg", // Local SVG file

    "title": "Discover Exciting Campus Events",
    "text":
        "Stay updated with the latest tech, cultural, and sports events happening on campus.",
  },
  {
    "illustration": "assets/notify_image.svg", // Local SVG file
    // "title": "Register & Participate Easily",
    "title": "Get Notified & Stay Engaged",

    "text":
        // "Join events with just a tap. Form teams, sign up for competitions, and track your registrations hassle-free.",
        "Receive real-time updates, event schedules, and reminders, so you never miss out on any action.",
  },
  {
    "illustration": "assets/register.svg", // Local SVG file
    // "title": "Get Notified & Stay Engaged",
    "title": "Register & Participate Easily",

    "text":
        // "Receive real-time updates, event schedules, and reminders, so you never miss out on any action.",
        "Join events with just a tap. Form teams, sign up for competitions, and track your registrations hassle-free.",
  },
];
