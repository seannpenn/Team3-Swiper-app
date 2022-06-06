part of 'navigation_service.dart';

PageRoute getRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.route:
      return SlideLeftRoute(page: const AuthScreen(), settings: settings);
    case ChatScreen.route:
      return SlideDownRoute(page: const ChatScreen(), settings: settings);
      case resetPasswordScreen.route:
      return SlideDownRoute(page: resetPasswordScreen(), settings: settings);
    case HomeScreen.route:
      return SlideDownRoute(page: const HomeScreen(), settings: settings);
    default:
      return FadeRoute(page: const AuthScreen(), settings: settings);
  }
}
