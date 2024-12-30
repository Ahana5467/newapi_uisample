
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SavedController with ChangeNotifier {
  static late Database database;
  List<Map> savedItems = [];

  static Future<void> initDb() async {
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
    }
    database = await openDatabase("saved.db", version: 1,
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE Saved (id INTEGER PRIMARY KEY, title TEXT, image TEXT, description TEXT, publishedAt TEXT, author TEXT, content TEXT,url TEXT)',
      );
    });
  }

  addSave({
    required BuildContext context,
    required String title,
    required String image,
    required String description,
    required String publishedAt,
    required String author,
    required String content,
    required String url,
  }) async {
    await getSave();
    bool alreadySaved = false;
    for (int i = 0; i < savedItems.length; i++) {
      if (savedItems[i]["title"] == title) {
        alreadySaved = true;
        break;
      }
    }

    if (alreadySaved == false) {
      await database.rawInsert(
        'INSERT INTO Saved(title, image, description, publishedAt, author, content, url) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [title, image, description, publishedAt, author, content,url],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Article saved successfully"),
        ),
      );
      await getSave(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Article is already saved"),
        ),
      );
    }
  }

  getSave() async {
    savedItems = await database.rawQuery('SELECT * FROM Saved');
    log(savedItems.toString());
    notifyListeners();
  }

  removeSave(int id) async {
    await database.rawDelete('DELETE FROM Saved WHERE id = ?', [id]);
    await getSave();
  }
}
