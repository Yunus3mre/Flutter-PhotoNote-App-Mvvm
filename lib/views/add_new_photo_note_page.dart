// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_note_app/services/service.dart';
import 'package:photo_note_app/view_model/add_new_photo_note_page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewPhotoNote extends StatefulWidget {
  @override
  State<AddNewPhotoNote> createState() => _AddNewPhotoNoteState();
}

class _AddNewPhotoNoteState extends State<AddNewPhotoNote> {
  final ImagePicker _picker = ImagePicker();

  XFile? image;
  String? imagePath;
  var imageFile;
  TextEditingController baslikCont = TextEditingController();
  TextEditingController aciklamaCont = TextEditingController();

  bool disableButton = true;
  bool progressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddNewPhotoNoteViewModel>(
      create: (context) => AddNewPhotoNoteViewModel(),
      builder: (context, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Colors.purple, Colors.yellowAccent])),
          child: Center(
            child: Form(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Positioned(
                                bottom: 50,
                                child: Text(
                                  "Fotoğraf Seç",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                )),
                            IconButton(
                              onPressed: () async {},
                              icon: Icon(Icons.upload),
                              color: Colors.black,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          child: Icon(
                                            Icons.warning,
                                            color: Colors.black,
                                            size: 50,
                                          ),
                                        ),
                                        title: Text("Yükleme Yöntemi Seçiniz"),
                                        alignment: Alignment.center,
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 100);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Kamera"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 100);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Galeri"),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });

                                setState(() {
                                  imageFile = image != null
                                      ? File(image?.path ?? "")
                                      : null;
                                });
                              },
                              child: Container(
                                child: imageFile != null
                                    ? Image.file(
                                        imageFile,
                                        fit: BoxFit.cover,
                                        height: 300,
                                        width: 300,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.purple[100]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                              size: 50,
                                            ),
                                            Text("Resim Seç")
                                          ],
                                        ),
                                      ),
                                height: 300,
                                width: 300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        CustomizableTextFormField(
                          controller: baslikCont,
                          lineCount: 1,
                          hint: "Not Başlığı Ekleyin",
                          icon: Icon(Icons.info),
                        ),
                        SizedBox(height: 15),
                        CustomizableTextFormField(
                          controller: aciklamaCont,
                          lineCount: 5,
                          hint: "Not Açıklaması Ekleyin",
                          icon: Icon(Icons.info),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ActionsButtonWidget(
                              text: Text("Yükle"),
                              onPressed: disableButton
                                  ? () async {
                                      setState(() {
                                        disableButton = false;
                                        progressIndicator = true;
                                      });
                                      var uuid = Uuid();
                                      String id = uuid.v4();
                                      try {
                                        String? url =
                                            await Provider.of<FirebaseServices>(
                                                    context,
                                                    listen: false)
                                                .uploadImage(imageFile, id);
                                                
                                       await Provider.of<AddNewPhotoNoteViewModel>(
                                                context,
                                                listen: false)
                                            .addNewNote(
                                                randomUid: id,
                                                downloadUrl: url,
                                                noteName: baslikCont.text,
                                                noteDescr: aciklamaCont.text);

                                        await alertDialog(context,
                                            "Kaydetme İşlemi Başarıyla Gerçekleşti.");
                                        Navigator.pop(context);
                                      } catch (e) {
                                        alertDialog(context,
                                            "Bir Hata Meydana Geldi:$e");
                                      }
                                    }
                                  : () {
                                      ///disable işlemi için
                                    },
                            ),
                            ActionsButtonWidget(
                              text: Text("İptal Et"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    !progressIndicator
                        ? Center()
                        : Positioned(
                            top: MediaQuery.of(context).size.height / 3,
                            left: MediaQuery.of(context).size.width / 2.8,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Lütfen Bekleyin!",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> alertDialog(BuildContext context, String body) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
              child: Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ActionsButtonWidget extends StatelessWidget {
  final Function onPressed;
  final Text? text;
  ActionsButtonWidget({
    required this.onPressed,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: text,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(100, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class CustomizableTextFormField extends StatelessWidget {
  final String? hint;
  final Icon? icon;
  final int? lineCount;
  final TextEditingController? controller;
  CustomizableTextFormField({
    Key? key,
    this.controller,
    this.hint,
    this.icon,
    this.lineCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        maxLines: lineCount,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white, width: 2)),
          prefixIcon: icon,
          hintStyle:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
