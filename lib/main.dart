// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mudarribe_trainee/routes/app_pages.dart';
import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/authentication/change_password/change_password_binding.dart';
import 'package:mudarribe_trainee/views/authentication/change_password/change_password_view.dart';
import 'package:mudarribe_trainee/views/authentication/signin/signin_binding.dart';
import 'package:mudarribe_trainee/views/authentication/signin/signin_view.dart';
import 'package:mudarribe_trainee/views/chat/controller.dart';
import 'package:mudarribe_trainee/views/events/allevents/allevents_view.dart';
import 'package:mudarribe_trainee/views/events/eventsdetail/eventsDetail_view.dart';
import 'package:mudarribe_trainee/views/events/myevents/myEvents_view.dart';
import 'package:mudarribe_trainee/views/exesrcontent/exercises.dart';
import 'package:mudarribe_trainee/views/exesrcontent/exercises2.dart';
import 'package:mudarribe_trainee/views/footer/footer_view.dart';
import 'package:mudarribe_trainee/views/home/home_binding.dart';
import 'package:mudarribe_trainee/views/home/home_view.dart';
import 'package:mudarribe_trainee/views/splash/splash_binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mudarribe_trainee/views/splash/splash_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mudarribe_trainee/views/trainee_profile/edit_profile/edit_profile_view.dart';
import 'package:mudarribe_trainee/views/trainee_profile/profile/profile_view.dart';
import 'package:mudarribe_trainee/views/video/video_view.dart';
import 'package:mudarribe_trainee/views/trainee_profile/report/report_problem_binding.dart';
import 'package:mudarribe_trainee/views/trainee_profile/report/report_problem_view.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(PaymentService());
  await GetStorage.init();
  Stripe.publishableKey =
      "pk_test_51JvIZ1Ey3DjpASZjPAzcOwqhblOq2hbchp6i56BsjapvhWcooQXqh33XwCrKiULfAe7NKFwKUhn2nqURE7VZcXXf00wMDzp4YN";

  // Stripe.merchantIdentifier = 'merchant.com.ezmove';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: white,
          ),
          useMaterial3: true,
          fontFamily: 'Montserrat',
        ),
        debugShowCheckedModeBanner: false,
        title: "Mudarribe",
        initialBinding: SplashBinding(),
        home: SplashView(),
        getPages: AppPages.pages,
      ),
    );
  }
}
