import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SortingServiceClass{
   static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<List> searchAlgo(String text) async {
    
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
}