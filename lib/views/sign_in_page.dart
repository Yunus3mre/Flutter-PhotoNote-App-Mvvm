// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:photo_note_app/services/service.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
                inputType: TextInputType.emailAddress,
                controller: emailController,
                hintText: "e-mail",
                icon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
              CustomizableTextField(
                visibilityControl: true,
                controller: passwordController,
                hintText: "Şifre",
                icon: Icon(
                  Icons.password,
                  color: Colors.white,
                ),
              ),
              CustomizableButton(
                buttonText: "Giriş",
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    await Provider.of<FirebaseServices>(context, listen: false)
                      .signInWithEmailAndPassword(
                          emailController.text, passwordController.text);
                  }
                  
                },
              ),
              CustomizableButton(
                buttonText: "Kayıt Ol",
                onPressed: () {
                  Navigator.pushNamed(context, "/SignUp");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomizableButton extends StatelessWidget {
  final String? buttonText;
  final Function onPressed;

  const CustomizableButton({
    Key? key,
    this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 20,
          primary: Colors.purpleAccent,
          fixedSize: Size(100, 50),
        ),
        child: Text(
          buttonText ?? "unknown",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}

class CustomizableTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Icon? icon;
  final TextInputType? inputType;
  final bool? visibilityControl;

  const CustomizableTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.icon,
      this.inputType,
      this.visibilityControl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        obscureText: visibilityControl ?? false,
        keyboardType: inputType,
        validator: (value) {
          if (value != null) {
            if (hintText == "İsim") {
              if (value.length < 5) {
                return "İsim 5 Karakterden Kısa Olamaz.";
              } else {
                return null;
              }
            } else if (hintText == "e-mail") {
              if (!value.contains("@")) {
                return "Hatalı Mail Formatı";
              } else {
                return null;
              }
            } else if (hintText == "Şifre") {
              if (value.length < 6) {
                return "Şifre 6 Haneden Kısa Olamaz.";
              } else {
                return null;
              }
            }
          }
        },
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: icon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
    );
  }
}
