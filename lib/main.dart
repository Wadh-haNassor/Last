import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/locale_provider.dart';
import 'services/location_service.dart';
import 'services/hotspot_service.dart';
import 'services/user_service.dart'; // Add missing import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MultiProvider(
            providers: [  // Move providers list inside MultiProvider
              ChangeNotifierProvider(create: (_) => UserService()),
              ChangeNotifierProvider(create: (_) => LocationService()),
              ChangeNotifierProvider(create: (_) => HotspotService()),
            ],
            child: MaterialApp(
              title: 'Fisherman Map',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: const Color(0xFFE0F7FA),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF00ACC1),
                  elevation: 2,
                ),
                navigationBarTheme: NavigationBarThemeData(
                  backgroundColor: Colors.white,
                  indicatorColor: const Color(0xFF00ACC1).withOpacity(0.2),
                  labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                    (Set<WidgetState> states) {
                      return TextStyle(
                        color: states.contains(WidgetState.selected)
                            ? const Color(0xFF00ACC1)
                            : Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              home: const LoginScreen(),
              debugShowCheckedModeBanner: false,
              locale: localeProvider.locale,
              supportedLocales: const [
                Locale('en', ''),
                Locale('sw', ''),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}