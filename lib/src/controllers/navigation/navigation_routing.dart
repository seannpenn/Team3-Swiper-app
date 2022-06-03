part of 'navigation_service.dart';

PageRoute getRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.route:
      return SlideUpRoute(page: const AuthScreen(), settings: settings);
    case ChatScreen.route:
      return SlideDownRoute(page: const ChatScreen(), settings: settings);
    case HomeScreen.route:
      return SlideDownRoute(page: const HomeScreen(), settings: settings);
    default:
      return FadeRoute(page: const AuthScreen(), settings: settings);
  }
}
