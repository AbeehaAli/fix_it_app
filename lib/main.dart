import 'package:firebase_core/firebase_core.dart';
import 'package:final_project/core/routes/app_router.dart';
import 'package:final_project/core/theme/app_theme.dart';
import 'package:final_project/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FixIt',
      theme: AppTheme.lightTheme,
       routerConfig: AppRouter.router,
    );
  }
}

