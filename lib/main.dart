import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/firebase_options.dart';
import 'package:swiper_app/service_locators.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform
  );
  setupLocators();
  runApp(const MyApp());
}