class PhotoNote{
  ///Bu sınıf notlarımızın bilgisini tutacak olan şablon bir model sınıfıdır.Sayfalra arası notların transferini 
  ///yaparken mapler üzerinde değilde buradaki objeler üzerinden yapacaz.
  
  final String? id;
  final String? noteName;
  final String? noteDescr;
  final String? url;
  final DateTime?date;

  PhotoNote({this.id, this.noteName, this.noteDescr, this.url,this.date});

  ///verilerimiz firebase'den obje olarak gelmiyor.Map olarak geliyor.Firebase'e veri gönderirkende map'e çevirip yolluyoruz.
  ///Bu durumda bize objeden map oluşturan ve mapten obje oluşturan metodlar lazım.
  
  ///Objeden map oluşturan
   Map<String,dynamic> toMap()=>{
     "date":date,
     "id":id,
     "noteDescr":noteDescr,
     "noteName":noteName,
     "url":url

   };

   ///mapten obje oluşturan yapıcı
   factory PhotoNote.fromMap(Map map)=>PhotoNote(id:map["id"],noteName: map["noteName"],noteDescr:map["noteDescr"] ,url: map["url"]);
   //yapıcı da return kullanıyorsak başına factory yazmak durumundayız.


}