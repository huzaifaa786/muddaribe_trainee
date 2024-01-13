import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:ui' as ui;
import 'package:google_translator/google_translator.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/views/trainee_profile/app_translate/translate_method.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key, this.lang});

  final String? lang;

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

enum translateMethod { English, Arabic }

class _TranslateScreenState extends State<TranslateScreen> {
  translateMethod? _site;
  toggleplan(translateMethod value) {
    setState(() {
      _site = value;
    });
  }

  @override
  void initState() {
    // print(Get.locale);
    GetStorage box = GetStorage();
    box.read('Locale') == 'ar';
    _site = box.read('Locale') != 'ar'
        ? translateMethod.English
        : translateMethod.Arabic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          title: TopBar(text: "Languages"),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              TranslateMethod(
                title: 'English',
                groupvalue: _site,
                value: translateMethod.English,
                onchaged: () async {
                  await toggleplan(translateMethod.English);
                  // Get.updateLocale(const Locale('en', 'US'));
                  GetStorage box = GetStorage();
                  await box.write('Locale', 'en');
                  GoogleTranslatorController.init(
                      'AIzaSyBOr3bXgN2bj9eECzSudyj_rgIFjyXkdn8', Locale('ur'),
                      cacheDuration: Duration(), translateTo: Locale('en'));
                  Get.offAllNamed(AppRoutes.footer);
                },
              ),
              TranslateMethod(
                title: 'Arabic',
                groupvalue: _site,
                value: translateMethod.Arabic,
                onchaged: () async {
                  await toggleplan(translateMethod.Arabic);
                  // Get.updateLocale(const Locale('ar', 'AE'));
                  GetStorage box = GetStorage();
                  await box.write('Locale', 'ar');
                  GoogleTranslatorController.init(
                      'AIzaSyBOr3bXgN2bj9eECzSudyj_rgIFjyXkdn8', Locale('en'),
                      cacheDuration: Duration(), translateTo: Locale('ar'));
                  Get.offAllNamed(AppRoutes.footer);
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
