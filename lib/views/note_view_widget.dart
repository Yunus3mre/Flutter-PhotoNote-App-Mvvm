// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:photo_note_app/services/service.dart';

import 'package:provider/provider.dart';

import '../view_model/main_page_view_model.dart';

class NoteViewWidget extends StatelessWidget {
  final String? photoName;
  final String? photoDesc;
  final String? downloadUrl;
  final String? id;
  NoteViewWidget(
      {Key? key, this.photoName, this.photoDesc, this.downloadUrl, this.id});

  bool control = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.purple, Colors.yellowAccent]),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      margin: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.teal,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  photoName ?? "Photo Name",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,

                  ///headline1 değeri null olabileceği için ? koyduk sonuna.Bu null safety'nin bir
                  ///parçasıdır.Burada headline1 null olursa color ndeğeri null olacaktır.
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(downloadUrl!),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Bu İçeriği Silmek İstediğinize Emin Misiniz?"),
            //title: Text(message),
            alignment: Alignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  control = true;
                  Navigator.of(context).pop();
                },
                child: Text("Evet"),
              ),
              ElevatedButton(
                onPressed: () {
                  control = false;
                  Navigator.of(context).pop();
                },
                child: Text("Hayır"),
              ),
            ],
          );
        });
  }
}
