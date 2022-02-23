// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_note_app/model/photo_note_model.dart';
import 'package:photo_note_app/services/service.dart';

class MainPageViewModel extends ChangeNotifier {
  ///Bu class'ın görevleri:
  ///1-mainPage'in state bilgisini tutmak.Bunun içinde buradaki değişiklikelrin bu sınıfı dinleyen view'i da anında etkilemesi için
  ///Bu sınıfı changeNotifier ile extends ettik ve mainpage'de bunu dinleyecez.
  ///2-mainPage arayüzünün ihtiyacı olan metotları ve hesaplamaları yapmak
  ///3-gerekli servislerle konuşmak
  ///
  ///NOT:Her view için bir view model sınıfı oluşturmak MVVM patterni için kullanılan bir yöntemdir.

  FirebaseServices _service = new FirebaseServices();

  Stream<List<PhotoNote>> getNotList() {
    ///stream<QuerySnapshot>-->Stream<List<DocumentSnapshot>>
    Stream<List<DocumentSnapshot>> streamListDocument =
        _service.readDocument().map((event) => event.docs);

    ///Stream<List<DocumentSnapshot>>-->Stream<List<PhotoNote>>
    ///Stream<List<DocumentSnapshot>>==bu aslında liste içinde listedir.Streame de liste diyebiliriz.
    Stream<List<PhotoNote>> streamListPhotoNote = streamListDocument.map(
        (listofDoc) => listofDoc
            .map((docSnap) =>
                PhotoNote.fromMap(docSnap.data() as Map<String, dynamic>))
            .toList());
      ///Burada firebaseden aldıgımız map'i daha önce oluşturdugumuz yapıcı sayesinde model objemize çevirdik.
      return streamListPhotoNote;
  }

  deleteDocument(PhotoNote note)async{
    await _service.deleteDocument(note.id!, note.url!);
    ///service classında delete metodu bizim oluşturdugumuz model sınıfından bir haber oldugu için silmesi gereken kayıtların id lerini parametre 
    ///olarak aldı.Ancak viewModel sınıfında ki karşılığı ise bu kayıtların idleri ile değil de parametre olarak aldıgı model sınıfının 
    ///nesnesi ile işlemlerini yapar.
  }





}
