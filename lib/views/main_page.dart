// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:photo_note_app/views/detailed_note_page.dart';
import 'package:photo_note_app/model/photo_note_model.dart';
import 'package:photo_note_app/views/note_view_widget.dart';
import 'package:photo_note_app/searchedNotes.dart';
import 'package:photo_note_app/services/service.dart';
import 'package:photo_note_app/services/sortingService.dart';
import 'package:photo_note_app/view_model/main_page_view_model.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  bool control = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainPageViewModel(),
      builder: (context, child) => Scaffold(
        ///viewModel sınıfımızda bir değişiklik oldugu zaman notifyListener çalışacak ve builder altında ki kısım kendini tekrardan çizecek.
        drawer: sideMenuDrawer(),
        appBar: AppBar(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text("FOTO NOTLAR"),
          centerTitle: true,
        ),
        body: StreamBuilder<List<PhotoNote>>(
            stream: Provider.of<MainPageViewModel>(context, listen: false)
                .getNotList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Bir Hata Meydana Geldi"),
                );
              } else {
                List<PhotoNote>? data = snapshot.data;
                return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedNotePage(
                              /* noteName: data[index].noteName,
                              noteDesc: data[index].noteDescr,
                              downloadUrl: data[index].url,*/
                              note: data[index],
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        await createAlertDialogToDelete(context);

                        if (control) {
                          await Provider.of<MainPageViewModel>(context,
                                  listen: false)
                              .deleteDocument(data[index]);
                        }
                      },
                      child: NoteViewWidget(
                        photoName: data[index].noteName,
                        photoDesc: data[index].noteDescr,
                        downloadUrl: data[index].url,
                        id: data[index].id,
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }

  Future<void> createAlertDialogToDelete(BuildContext context) async {
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

class sideMenuDrawer extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.clear();
    print("deneme");
    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sideMenuListTile(
                title: "Foto Not Ekle",
                icon: Icon(Icons.add_a_photo),
                function: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/addPage");
                },
              ),
              sideMenuListTile(
                title: "Çıkış Yap",
                icon: Icon(Icons.logout_outlined),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: () {},
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Ara-En az 3 harf girin",
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String searchText = "";
                    if (controller.text.length >= 3) {
                      searchText = controller.text;
                      var list =
                          await SortingServiceClass.searchAlgo(searchText);
                      if (list.isNotEmpty) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchedNotesPage(
                                      list: list,
                                      searchText: searchText,
                                    )));
                      } else {
                        createAlertDialog(
                            context, "Böyle Bir Not Bulunmamaktadır.");
                      }
                    } else {
                      createAlertDialog(context, "Geçerli Bir Kelime Girin");
                    }
                  },
                  child: Text("Ara"))
            ],
          ),
        ),
      ),
    );
  }

  void createAlertDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              child: Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
            ),
            title: Text(message),
            alignment: Alignment.center,
          );
        });
  }
}

class sideMenuListTile extends StatelessWidget {
  final String? title;
  final Icon? icon;
  final VoidCallback? function;
  final Text? subTitle;

  const sideMenuListTile(
      {Key? key, this.function, this.icon, this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        subtitle: subTitle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textColor: Colors.white,
        iconColor: Colors.white,
        tileColor: Colors.redAccent,
        leading: icon,
        title: Text(title ?? ""),
        onTap: function,
      ),
    );
  }
}
