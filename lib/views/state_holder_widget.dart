// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:photo_note_app/views/main_page.dart';
import 'package:photo_note_app/services/service.dart';
import 'package:photo_note_app/views/sign_in_page.dart';
import 'package:provider/provider.dart';

class StateHolder extends StatefulWidget {
  const StateHolder({Key? key}) : super(key: key);

  @override
  State<StateHolder> createState() => _StateHolderState();
}

class _StateHolderState extends State<StateHolder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<FirebaseServices>(context, listen: false)
            .authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            

            return snapshot.data != null ? MyHomePage() : SignInPage();
            
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
