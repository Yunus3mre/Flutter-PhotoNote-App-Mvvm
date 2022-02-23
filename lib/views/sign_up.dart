// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:photo_note_app/services/service.dart';
import 'package:photo_note_app/views/sign_in_page.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Colors.purple, Colors.black])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomizableTextField(
                inputType: TextInputType.name,
                controller: nameCont,
                hintText: "İsim",
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
              CustomizableTextField(
                inputType: TextInputType.emailAddress,
                controller: emailCont,
                hintText: "e-mail",
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
              CustomizableTextField(
                visibilityControl: true,
                controller: passwordCont,
                hintText: "Şifre",
                icon: Icon(
                  Icons.password,
                  color: Colors.white,
                ),
              ),
              CustomizableButton(
                buttonText: "Kayıt Ol",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await Provider.of<FirebaseServices>(context, listen: false)
                        .createUserWithEmailAndPassword(
                            emailCont.text, passwordCont.text);
                    Navigator.pop(context);
                  }
                },
              ),
              CustomizableButton(
                buttonText: "Geri",
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
