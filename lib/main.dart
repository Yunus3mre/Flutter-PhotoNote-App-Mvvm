// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photo_note_app/views/add_new_photo_note_page.dart';

import 'package:photo_note_app/views/detailed_note_page.dart';
import 'package:photo_note_app/searchedNotes.dart';
import 'package:photo_note_app/services/service.dart';
import 'package:photo_note_app/views/sign_in_page.dart';
import 'package:photo_note_app/views/sign_up.dart';
import 'package:photo_note_app/views/state_holder_widget.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseServices>(
      create: (context) => FirebaseServices(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            textTheme: TextTheme(headline1: TextStyle(color: Colors.white)),
            bottomAppBarColor: Colors.red[800],
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: Colors.black87),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            appBarTheme: AppBarTheme(backgroundColor: Colors.redAccent),
            primarySwatch: Colors.red,
            hintColor: Colors.white),
        home: StateHolder(),
        routes: {
          "/addPage": (context) => AddNewPhotoNote(),
          "/signIn": (context) => SignInPage(),
          "/SignUp": (context) => SignUp(),
          "/DetailedPage": (context) => DetailedNotePage(),
          "/SearchedNote": (context) => SearchedNotesPage(),
        },
      ),
    );
  }
}
