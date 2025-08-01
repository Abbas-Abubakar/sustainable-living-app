import 'package:app/screens/about/about.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';
import 'package:app/screens/contact/contact.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/image-Gallery/image_gallery_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String aboutUs = '/about-us';
  static const String imageGallery = '/image-gallery';
  static const String contactUs = '/contact-us';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    aboutUs: (context) => const About(),
    imageGallery: (context) => ImageGalleryScreen(),
    contactUs: (context) => Contact()


  };
}
