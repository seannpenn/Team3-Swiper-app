import 'package:get_it/get_it.dart';
import 'package:swiper_app/src/controllers/auth_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';


final locator = GetIt.instance;

void setupLocators() {
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<AuthController>(AuthController());
}