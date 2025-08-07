import 'package:app/screens/about/about.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';
import 'package:app/screens/carbon-foot-print_page/carbon_foot_print_page.dart';
import 'package:app/screens/contact/contact.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/image-Gallery/image_gallery_screen.dart';
import 'package:app/screens/pages/eco_products_page.dart';
import 'package:app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String aboutUs = '/about-us';
  static const String imageGallery = '/image-gallery';
  static const String contact = '/contact-us';
  static const String carbonFootPrint = '/carbon-foot-print';
  static const String ecoProducts = '/eco-products';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    aboutUs: (context) => const About(),
    imageGallery: (context) => ImageGalleryScreen(),
    contact: (context) => Contact(),
    carbonFootPrint: (context) => CarbonFootprintPage(),
    ecoProducts: (context) => EcoProductsPage(),

  };
}
