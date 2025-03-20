import 'package:bookhive/models/books_model.dart';
import 'package:bookhive/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  final databaseName = "books.db";

  //Tables


  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT,
   usrName TEXT UNIQUE,
   usrPassword TEXT
   )
   ''';

  String favorites = '''
    CREATE TABLE favorites (
      id TEXT,
      usrId INTEGER,
      title TEXT,
      authors TEXT,
      thumbnail TEXT,
      description TEXT,
      PRIMARY KEY (id, usrId),
      FOREIGN KEY (usrId) REFERENCES users(usrId)
    )
  ''';

  //Create a connection to the database
  Future<Database> initDB ()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path,version: 1 , onCreate: (db,version)async{
      await db.execute(user);
      await db.execute(favorites);
    });
  }

  //Function

  //Authentication
  Future<bool> authenticate(Users usr)async{
    final Database db = await initDB();
    var result = await db.rawQuery("select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    if(result.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  //Sign up
  Future<int> createUser(Users usr)async{
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }


  //Get current User details
  Future<Users?> getUser(String usrName)async{
    final Database db = await initDB();
    var res = await db.query("users",where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty? Users.fromMap(res.first):null;
  }

  // Insert a book into favorites
  Future<int> insertFavorite(Book book, int usrId) async {
    final Database db = await initDB();
    return db.insert("favorites", {
      ...book.toMap(),
      "usrId": usrId,
    });
  }

  // Remove a book from favorites by its id
  Future<int> removeFavorite(String id, int usrId) async {
    final Database db = await initDB();
    return db.delete("favorites", where: "id = ? AND usrId = ?", whereArgs: [id, usrId],
    );
  }

  // Retrieve all favorite books
  Future<List<Book>> getFavorites(int usrId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "favorites",
      where: "usrId = ?",
      whereArgs: [usrId],
    );

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        authors: maps[i]['authors'].toString().split(', '),
        thumbnail: maps[i]['thumbnail'],
        description: maps[i]['description'],
      );
    });
  }



}