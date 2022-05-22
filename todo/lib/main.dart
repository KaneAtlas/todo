import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo/firebase_options.dart';
import 'package:todo/auth_resolver.dart';
import 'package:todo/loading.dart';
import 'package:todo/errors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseInit());
}

class FirebaseInit extends StatelessWidget {
  const FirebaseInit({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const GenericError();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Loading();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WillDo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthResolver());
  }
}
