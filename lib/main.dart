import 'package:flutter/material.dart';
import 'package:taxi_app/splashPage.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi App',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary color scheme
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple[700]!,
          brightness: Brightness.light,
        ),

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[700],
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Elevated Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[700],
            foregroundColor: Colors.white,
            elevation: 3,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        // Text Button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple[700],
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

        // FloatingActionButton theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple[700],
          foregroundColor: Colors.white,
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple[700]!, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.deepPurple[700]),
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),

        // Card theme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),

        // ListTile theme
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          selectedTileColor: Colors.deepPurple[50],
          selectedColor: Colors.deepPurple[700],
          iconColor: Colors.deepPurple[400],
          textColor: Colors.black87,
        ),

        // Progress indicator theme
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.deepPurple[700],
        ),

        // Snackbar theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.deepPurple[700],
          contentTextStyle: TextStyle(color: Colors.white),
          actionTextColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),

        // Dialog theme
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titleTextStyle: TextStyle(
            color: Colors.deepPurple[700],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Divider theme
        dividerTheme: DividerThemeData(
          color: Colors.deepPurple[100],
          thickness: 1,
        ),

        // Icon theme
        iconTheme: IconThemeData(color: Colors.deepPurple[600], size: 24),

        // Primary text theme
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),

      home: SplashPage(),
    );
  }
}
