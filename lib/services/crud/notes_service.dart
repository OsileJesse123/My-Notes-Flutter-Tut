import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class DatabaseAlreadyOpenException implements Exception{}
class UnableToGetDocumentsDirectory implements Exception{}
class DatabaseIsNotOpenException implements Exception{}

class NotesService {

  Database? _db;

  Future<void> deleteUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final deletedCount = db.delete(userTable, where: "email = ?", whereArgs: [email.toLowerCase()]);
  }

  Database _getDatabaseOrThrow(){
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async{
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async{
    if(_db != null){
      throw DatabaseAlreadyOpenException();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      
      
      await db.execute(createUserTable);

      

      await db.execute(createNoteTable);
    }
    on MissingPlatformDirectoryException catch(_){
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser{
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map) 
  : id = map[idColumn] as int,
   email = map[emailColumn] as String;

   @override
  String toString() => 'Person, ID = $id, email = $email';
  
  @override bool operator == (covariant DatabaseUser other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
}

class DatabaseNote{

  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({required this.id, required this.userId, required this.text, required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map) 
  : id = map[idColumn] as int,
   userId = map[userIdColumn] as int,
   text = map[textColumn] as String,
   isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

   @override
  String toString() => "Note, ID = $id, userID = $userId, isSyncedWithCloud = $isSyncedWithCloud";

  @override bool operator == (covariant DatabaseNote other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}
const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "userId";
const textColumn = "text";
const isSyncedWithCloudColumn = "isSyncedWithCloud";
const createNoteTable = ''' 
        CREATE TABLE IF NOT EXISTS "note"(
        "id" INTEGER NOT NULL,
        "text" TEXT
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';
      const createUserTable = '''
        CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';