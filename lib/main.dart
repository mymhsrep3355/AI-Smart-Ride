import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_ride/src/modules/ChoiceScreen/login_choice_view.dart';
import 'package:smart_ride/src/modules/DriverCreatePassword/DriverCreatePasswordView.dart';
import 'package:smart_ride/src/modules/DriverForgotPassword/driverForgotPasswordView.dart';
import 'package:smart_ride/src/modules/DriverForgotPasswordVerification/driverForgotPasswordVerificationView.dart';
import 'package:smart_ride/src/modules/DriverResetPassword/driverResetPasswordView.dart';
import 'package:smart_ride/src/modules/ForgotPasswordPassengerVerification/ForgotPaswordPassengerVerificationView.dart';
import 'package:smart_ride/src/modules/Home_Page/homepage_view.dart';
import 'package:smart_ride/src/modules/PassengerCreatePassword/PassengerCreatePasswordView.dart';
import 'package:smart_ride/src/modules/carpooling_pick_drop/carpooling_pick_drop_view.dart';
import 'package:smart_ride/src/modules/chat-bot/ai_chatbot_view.dart';

import 'package:smart_ride/src/modules/chat_page/chat_page_view.dart';
import 'package:smart_ride/src/modules/chatting_screen/chatting_screen_view.dart';
import 'package:smart_ride/src/modules/driverSignUpverification/driver_signupVerification_view.dart';
import 'package:smart_ride/src/modules/driver_Signup/driver_signup_view.dart';
import 'package:smart_ride/src/modules/driver_activerequestpage/active_request_logic.dart';
import 'package:smart_ride/src/modules/driver_activerequestpage/active_request_view.dart';

import 'package:smart_ride/src/modules/driver_homepage/driver_home_view.dart';
import 'package:smart_ride/src/modules/driver_info/driver_info_view.dart';

import 'package:smart_ride/src/modules/driver_login/driver_login_view.dart';
import 'package:smart_ride/src/modules/driver_verification/driver_verification_view.dart';
import 'package:smart_ride/src/modules/forgotPassword/forgotPassword_view.dart';
import 'package:smart_ride/src/modules/group_posting/group_posting_binding.dart';
import 'package:smart_ride/src/modules/group_posting/group_posting_view.dart';
import 'package:smart_ride/src/modules/login_page/login_view.dart';
import 'package:smart_ride/src/modules/passenger-signup/passenger_signup_view.dart';
import 'package:smart_ride/src/modules/passenger_signup_verifcation/passenger_signup_verifcation_view.dart';
import 'package:smart_ride/src/modules/passenger_verification/passenger_verification_view.dart';

import 'package:smart_ride/src/modules/resetPassword/resetPasswordView.dart';
import 'package:smart_ride/src/modules/signup_choice/signup_choice_view.dart';
import 'package:smart_ride/src/modules/signup_page/sign_view.dart';
import 'package:smart_ride/src/modules/signup_verification_page/verification_view.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'src/general_controller/GeneralController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock to portrait only
    // DeviceOrientation.portraitDown, // Optional: allow upside-down
  ]);
  await GetStorage.init();
  Get.put(GeneralController());

  runApp(const MyApp()); // or your root widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartRide',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const UserTypeSelectionView(),

        //home : DriverActiveRequestView(),
        getPages: [
          GetPage(name: '/passengerLogin', page: () => const LoginView()),
          GetPage(name: '/driverLogin', page: () => const DriverLoginView()),
          GetPage(
              name: '/driverVerification',
              page: () => const DriverVerificationView()),
          GetPage(
              name: '/passengerVerification',
              page: () => const PassengerVerificationView()),
          GetPage(name: '/signup', page: () => const SignView()),
          GetPage(
            name: '/ai-chatbot',
            page: () => const AIChatBotView(),
          ),
          GetPage(
              name: '/signupChoice',
              page: () => const SignUpTypeSelectionView()),
          GetPage(name: '/verification', page: () => const VerificationView()),
          GetPage(name: '/home', page: () => const HomePageView()),
          GetPage(name: '/group-chat', page: () => GroupChatScreen()),
          GetPage(name: '/driver-signup', page: () => const DriverSignUpView()),
          GetPage(
              name: '/passenger-signup',
              page: () => const PassengerSignUpView()),
          GetPage(
              name: '/forgot-password', page: () => const ForgotPasswordView()),
          GetPage(
              name: '/ForgotPaswordPassengerVerification',
              page: () => const ForgotPasswordVerificationView()),
          GetPage(
              name: '/DriverForgotPaswordPassengerVerification',
              page: () => const DriverForgotPasswordVerificationView()),
          GetPage(
              name: '/resetPassword', page: () => const ResetPasswordView()),
          GetPage(
              name: '/DriverResetPassword',
              page: () => const DriverResetPasswordView()),
          GetPage(
              name: '/driver-signup-verification',
              page: () => const DriverSignUpVerificationView()),
          GetPage(
              name: '/passenger-signup-verification',
              page: () => const PassengerSignUpVerificationView()),
          GetPage(name: '/doc-verification', page: () => DriverInfoView()),
          GetPage(name: '/driver-home', page: () => DriverHomePageView()),
          GetPage(
              name: '/driverForgotPassword',
              page: () => DriverForgotPasswordView()),
          GetPage(
              name: '/driverCreatePassword',
              page: () => DriverCreatePasswordView()),
          GetPage(
              name: '/passengerCreatePassword',
              page: () => PassengerCreatePasswordView()),
          GetPage(
            name: '/active-request',
            page: () => DriverActiveRequestView(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => DriverActiveRequestLogic());
            }),
          ),
          GetPage(
            name: '/group-posting',
            page: () => const GroupPostingView(),
            binding: GroupPostingBinding(),
          ),
          GetPage(
            name: '/chatting-screen',
            page: () {
              final args = Get.arguments as Map<String, dynamic>;
              return ChattingScreenView(
                groupId: args['groupId'],
                groupName: args['groupName'],
              );
            },
          ),
        ]);
  }
}
