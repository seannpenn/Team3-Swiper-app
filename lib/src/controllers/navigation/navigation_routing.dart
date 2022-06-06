part of 'navigation_service.dart';

PageRoute getRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.route:
      return SlideLeftRoute(page: const AuthScreen(), settings: settings);
    case ChatScreen.route:
      return SlideDownRoute(page: const ChatScreen(), settings: settings);
    case ResetPasswordScreen.route:
      return SlideDownRoute(
          page: const ResetPasswordScreen(), settings: settings);
    case ProfileScreen.route:
      return SlideDownRoute(page: const ProfileScreen(), settings: settings);
    case HomeScreen.route:
      return SlideDownRoute(page: const HomeScreen(), settings: settings);
    default:
      return FadeRoute(page: const AuthScreen(), settings: settings);
  }
}
