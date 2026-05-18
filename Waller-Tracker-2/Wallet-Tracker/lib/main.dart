import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/post_provider.dart';
import 'screens/post_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostProvider>(
      create: (_) => PostProvider(),
      child: MaterialApp(
        title: 'JSONPlaceholder CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00695C),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const PostListScreen(),
      ),
    );
  }
}
