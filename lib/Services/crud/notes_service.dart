import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:a/Services/crud/crud_exceptions.dart';

class NotesService {
  Database? _db;

  List _notes = [];

  final _notesStreamController = StreamController.broadcast();

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on UnableToFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> ensureDbIsOpen() async {
    try {
      await open();
    } on DataBaseAlreadyOpeningException {}
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenedException();
    } else {
      return db;
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ? ",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw UnableToFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: "email", whereArgs: [email.toLowerCase()]);
    if (results.isNotEmpty) {
      throw UnableToFindUserException();
    }
    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if(deletedCount != 1 ){
      throw UnableToDeleteUserException();
    }
  }

  Future<void> close() async {
    final db = _getDatabaseOrThrow();
    await db.close();
    _db = null;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpeningException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    await ensureDbIsOpen();
    // make sure owner exists in the database with the correct id
    if (dbUser != owner) {
      throw UnableToFindUserException();
    }
    final notesId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final note = DatabaseNote(
      id: notesId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw UnableToDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletion = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletion;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: "id=?",
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw UnableToFindNoteException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(note);
      return note;
    }
  }

  Future<Iterable> getAllNotes() async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
    );
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    await ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatesCount == 0) {
      throw UnableToUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(note);
      _notesStreamController.add(note);
      return updatedNote;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'DatabaseUser{id: $id, email: $email}';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() {
    return 'DatabaseNote'
        '{id: $id,'
        ' userId: $userId,'
        ' text: $text,'
        ' isSyncedWithCloud: $isSyncedWithCloud}';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const text = "";
const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "userId";
const textColumn = "text";
const isSyncedWithCloudColumn = "isSyncedWithCloud";

// create user table

const createUserTable = '''
            CREATE TABLE IF NOT EXISTS "user" (
	      "id"	INTEGER NOT NULL,
	      "email"	TEXT NOT NULL UNIQUE,
      	PRIMARY KEY("id")
      );
      ''';
// create note table

const createNoteTable = '''
            CREATE TABLE IF NOT EXISTS "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
        )''';
