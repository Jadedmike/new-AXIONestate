import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'models/property.dart';
import 'screens/about_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/home_screen.dart';
import 'screens/properties_screen.dart';
import 'screens/property_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AxionRealEstateApp());
}

class AxionRealEstateApp extends StatelessWidget {
  const AxionRealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axion Digital | البوابة العقارية الأولى في سوريا',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Specification 3: Global RTL Support for Arabic Platform
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },

      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const HomeScreen();
            break;
          case '/properties':
            final filters = settings.arguments as Map<String, dynamic>?;
            page = PropertiesScreen(initialFilters: filters);
            break;
          case '/properties/detail':
            final prop = settings.arguments as Property;
            page = PropertyDetailScreen(property: prop);
            break;
          case '/about':
            page = const AboutScreen();
            break;
          case '/contact':
            page = const ContactScreen();
            break;
          case '/admin/login':
            page = const AdminLoginScreen();
            break;
          case '/admin':
            page = const AdminDashboardScreen();
            break;
          default:
            page = const HomeScreen();
        }

        // Specification 4: Custom transition curve easeOutCubic with 500ms
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        );
      },
    );
  }
}
