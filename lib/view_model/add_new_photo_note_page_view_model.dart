import 'package:flutter/cupertino.dart';
import 'package:photo_note_app/model/photo_note_model.dart';
import 'package:photo_note_app/services/service.dart';

class AddNewPhotoNoteViewModel extends ChangeNotifier {
  FirebaseServices _dbService = FirebaseServices();

  addNewNote(
      {String? noteName,
      String? noteDescr,
      String? randomUid,
      String? downloadUrl}) async {
    ///Form alanındaki verileri parametre olarak aldı ve bu verilerle bir PhotoNote nesnesi oluşturacak.
    PhotoNote newNote = PhotoNote(
        date: DateTime.now(),
        id: randomUid,
        url: downloadUrl,
        noteDescr: noteDescr,
        noteName: noteName);

    ///Bu PhotoNote bilgisini database servisi üzerinden Firestore'a yazacak.
    await _dbService.createDocument2(randomUid!, newNote.toMap());
  }
}
