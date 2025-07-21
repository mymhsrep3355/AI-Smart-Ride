// import 'package:flutter/material.dart';
// import 'package:smart_ride/src/modules/customwidget/custom_button.dart';
// import 'package:smart_ride/src/modules/LoginChoice/login_choice_view.dart';
// import 'package:smart_ride/src/modules/signup_page/sign_view.dart';
// import 'package:smart_ride/src/modules/utlis/app_fonts.dart';
// import 'package:smart_ride/src/modules/utlis/app_images.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.only(top: 60, bottom: 20),
//               child: Column(
//                 children: [
//                   // Logo
//                   Image.asset(AppImages.logo, height: 80),

//                   const SizedBox(height: 20),

//                   // Welcome Text
//                   Text(
//                     "Welcome to SmartRide",
//                     style: StyleRefer.poppinsSemiBold.copyWith(
//                       fontSize: 22,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Join SmartRide - your journey, your fare, your choice!",
//                     style: StyleRefer.poppinsRegular.copyWith(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),

//                   const SizedBox(height: 40),
// // Login Button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: CustomButton(
//                       text: "Login",
//                       onPressed: () {
//                         // Navigate to the LoginScreen
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => UserTypeSelectionView()),
//                         );
//                       },
//                       backgroundColor: Colors.blue,
//                       textColor: Colors.white,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Signup Button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: CustomButton(
//                       text: "SignUp",
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SignView()),
//                         );
//                       },
//                       backgroundColor: Colors.white,
//                       textColor: Colors.blue,
//                       borderColor: Colors.blue,
//                     ),
//                   ),
//                   // const SizedBox(height: 10),
//                   // Padding(
//                   //   padding: const EdgeInsets.symmetric(horizontal: 40),
//                   //   child: CustomButton(
//                   //     text: "Driver SignUp",
//                   //     onPressed: () {
//                   //       Navigator.push(
//                   //         context,
//                   //         MaterialPageRoute(
//                   //             builder: (context) => DriverSignView()),
//                   //       );
//                   //     },
//                   //     backgroundColor: Colors.white,
//                   //     textColor: Colors.blue,
//                   //     borderColor: Colors.blue,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.2,
//             width: double.infinity,
//             child: Image.asset(
//               AppImages.background,
//               fit: BoxFit.cover,
//               alignment: Alignment.bottomCenter,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
