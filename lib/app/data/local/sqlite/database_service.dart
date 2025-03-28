
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatbaseService {
  static const _version = 1;
  static const  _databaseName ='TASKI_DB';

  static DatbaseService? _instance;
  Database? _db;

  DatbaseService._();
   
   factory DatbaseService(){
    _instance ??= DatbaseService._();
    return _instance!;
   }
  
  Future<Database> openConnetion()async{
      final databasePath = await getDatabasesPath();
      final fullPathDatabase =join(databasePath,_databaseName);
      
      _db  ??= await openDatabase(
         fullPathDatabase,
         version: _version,
        onConfigure: onConfigure,
        onCreate: onCreate,
        onUpgrade: onUpGrade,
        onDowngrade: onDownGrade,
      );
    
     return _db!;

  }

  Future<void> onUpGrade(Database db, int oldVersion, int newVersion) async {
        
    }

  FutureOr<void> onConfigure(Database db) async {
      await db.execute("PRAGMA foreign_keys=on");
    }

  FutureOr<void> onDownGrade(db, int oldVersion, int newVersion) {}

  FutureOr<void> onCreate(Database db,int version) async {
    await db.execute(
      ''' 
        CREATE TABLE task (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL CHECK (isCompleted IN (0,1))
      )
       '''
    );

  }
  Future<void> onClose()async{
    _db?.close();
    _db = null;
  }
  
}