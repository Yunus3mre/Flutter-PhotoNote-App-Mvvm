// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:photo_note_app/views/detailed_note_page.dart';

import 'package:photo_note_app/views/note_view_widget.dart';

class SearchedNotesPage extends StatelessWidget {
  final String? searchText;
  final List? list;
  const SearchedNotesPage({Key? key, this.searchText, this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 11,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        title: Row(
          children: [Text("Aranan Kelime:$searchText"), Icon(Icons.search)],
        ),
      ),
      body: ListView.builder(
          itemCount: list?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedNotePage(
                      note: list?[index],
                    ),
                  ),
                );
              },
              child: NoteViewWidget(
                downloadUrl: list?[index]["url"],
                photoName: list?[index]["noteName"],
              ),
            );
          }),
    );
  }
}
