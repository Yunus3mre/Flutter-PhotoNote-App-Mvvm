import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:photo_note_app/model/photo_note_model.dart';

class FirebaseServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage _firebaseStorage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> readDocument() {
    return _firestore
        .collection(_firebaseAuth.currentUser!.uid)
        .orderBy("date", descending: true)
        .snapshots();
  }

  createDocument(String noteName, String noteDescr, String randomUid,
      String downloadUrl) async {
    CollectionReference uploads =
        _firestore.collection(_firebaseAuth.currentUser!.uid);
    await uploads
        .doc(randomUid)
        .set({
          "noteName": noteName,
          "noteDescr": noteDescr,
          "url": downloadUrl,
          "id":randomUid,
          "date": DateTime.now()
        })
        .then((value) => print("Veri başarıyla yazıldı"))
        .onError((error, stackTrace) => print("hata:$error"));
  }
  createDocument2(String randomUid,Map<String,dynamic> photoNoteAsMAp) async {
    CollectionReference uploads =
        _firestore.collection(_firebaseAuth.currentUser!.uid);
    await uploads
        .doc(randomUid)
        .set(photoNoteAsMAp)
        .then((value) => print("Veri başarıyla yazıldı"))
        .onError((error, stackTrace) => print("hata:$error"));
  }

  Future<List> searchAlgo(String text) async {
    
    List? searchlist = [];
    var documents =
        await _firestore.collection(_firebaseAuth.currentUser!.uid).get();
    var list = documents.docs;
    for (int i = 0; i < list.length; i++) {
      String ad = list[i]["noteName"].toString().toLowerCase();
      if (ad.contains(text)) {
        searchlist.add(list[i]);
        
        
      } else {
        
      }
    }
    
    return searchlist;
  }

  User? currentUser() {
    
    return _firebaseAuth.currentUser;
  }

  
  Future<void> deleteDocument(String docId,String url)async{
    await _firestore.collection(_firebaseAuth.currentUser!.uid).doc(docId).delete();
    await _firebaseStorage.refFromURL(url).delete();
  }
  

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Hata Meydana Geldi:$e");
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Bir Hata Meydana Geldi:$e");
    }
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Bir Hata Meydana Geldi:$e");
    }
  }

  Future<void> getDownloadUrls(String id) async {
    firebase_storage.ListResult a = await firebase_storage
        .FirebaseStorage.instance
        .ref("mObv9Kud2hNIYukHaQbatVDiSM42/")
        .listAll();
  }

  Future<String?> uploadImage(File imageFile, String uuid) async {
    try {
      User? user = _firebaseAuth.currentUser;
      String fileName = basename(imageFile.path);

      

      ///dosya yolunun bir değişkene atadık.
      firebase_storage.Reference firebaseStorageRef =
          _firebaseStorage.ref().child("/${user?.uid}/$uuid");

      //print(firebaseStorageRef.getDownloadURL());

      ///fotoğraf için oluşturdugumuz değişkene bir referans tanımlıyoruz.

      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.putFile(imageFile);

      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      ///fotoğraf yükleme işlemini gerçekleştiriyoruz.

      String downloadUrl = await firebase_storage.FirebaseStorage.instance
          .ref("/${user?.uid}/$uuid")
          .getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("HATA:$e");
    }
  }
}
