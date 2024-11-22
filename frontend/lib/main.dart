import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/program_list.dart';
import 'ui/program_details.dart';
import 'ui/audio_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print("Environment variables loaded successfully.");
    print(dotenv.env); // Print all loaded environment variables.
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(const InnerBhaktiApp());
}

class InnerBhaktiApp extends StatelessWidget {
  const InnerBhaktiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inner Bhakti App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ProgramListScreen(),
        '/program_details': (context) => const ProgramDetailsScreen(),
        '/audio_player': (context) => const AudioPlayerScreen(),
      },
    );
  }
}
