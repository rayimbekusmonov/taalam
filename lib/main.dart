import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
import 'models/category_model.dart';
import 'models/word_model.dart';
import 'models/user_progress_model.dart';

// Providers
import 'providers/category_provider.dart';
// import 'providers/word_provider.dart';

// Core
import 'core/theme/app_theme.dart';

// Screens
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialize
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(UserProgressAdapter());

  // Open Hive Boxes
  await Hive.openBox<Category>('categories');
  await Hive.openBox<Word>('words');
  await Hive.openBox<UserProgress>('userProgress');

  debugPrint('✅ Hive boxes opened successfully');

  runApp(const ArabLugatApp());
}

class ArabLugatApp extends StatelessWidget {
  const ArabLugatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        // ChangeNotifierProvider(create: (_) => WordProvider()),
      ],
      child: MaterialApp(
        title: 'ArabLug\'at',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}