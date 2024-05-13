import 'package:contacts/ui/contacts/view/contact_add_screen.dart';
import 'package:contacts/ui/contacts/view/contact_edit_screen.dart';
import 'package:contacts/ui/contacts/view/contacts_screen.dart';
import 'package:contacts/ui/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);
      case '/contacts':
        return MaterialPageRoute(builder: (_) => const ContactsScreen(), settings: settings);
      case '/contact_add':
        return MaterialPageRoute(builder: (_) => const ContactAddScreen(), settings: settings);
      case '/contact_edit':
        return MaterialPageRoute(builder: (_) => const ContactEditScreen(), settings: settings);
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen(), settings: settings);
    }
  }
}
