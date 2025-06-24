// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vartaa/controllers/auth_controller.dart';
import 'package:vartaa/controllers/news_controller.dart';
import 'package:vartaa/controllers/bookmark_controller.dart';
import 'package:vartaa/models/author_news_controller.dart';
import 'package:vartaa/screens/home_screen.dart';
import 'package:vartaa/screens/splash_screen.dart';
import 'package:vartaa/utils/helper.dart';

// GlobalKey untuk Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => NewsController()),
        ChangeNotifierProvider(create: (_) => AuthorNewsController()),
        ChangeNotifierProvider(create: (_) => BookmarkController()),
      ],
      child: MaterialApp(
        title: 'Vartaa News App',
        theme: ThemeData(
          primaryColor: cPrimary,

          visualDensity: VisualDensity.adaptivePlatformDensity,

          inputDecorationTheme: InputDecorationTheme(
            hintStyle: subtitle2, // Gaya untuk hintText
            labelStyle: subtitle2, // Gaya untuk labelText
            floatingLabelStyle: subtitle2.copyWith(
              color: cPrimary,
            ), // Gaya label saat floating/focused
            filled: false, // Default: tidak diisi warna
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ), // Padding konten input
            // Border secara default untuk semua keadaan
            border:
                defaultInputBorder, // Default border saat input tidak aktif, tidak fokus, dan tidak error
            enabledBorder:
                defaultInputBorder, // Border saat enabled (tidak fokus)
            focusedBorder: focusedInputBorder, // Border saat fokus
            errorBorder: errorInputBorder, // Border saat ada error
            focusedErrorBorder:
                focusedErrorInputBorder, // Border saat fokus dan ada error
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return Colors
                    .grey[800]!; // Ganti ke warna abu-abu gelap saat fokus
              }
              return Colors.grey[600]!; // Warna ikon default saat tidak fokus
            }),
            suffixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return Colors
                    .grey[800]!; // Ganti ke warna abu-abu gelap saat fokus
              }
              return Colors.grey[600]!; // Warna ikon default saat tidak fokus
            }),
          ),
          // -------------------------------------------------------------------
        ),
        navigatorKey: navigatorKey,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (authController.isAuthenticated) {
            return const HomeScreen();
          } else {
            return const SplashScreen();
          }
        }
      },
    );
  }
}
