import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taski_todo/app/core/exceptions/taski_exception.dart';
import 'package:taski_todo/app/data/local/sqlite/database_service.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';

class TaskRepositoryImpl implements ITaskiRepository {
  final DatbaseService _database;

  TaskRepositoryImpl({required DatbaseService database}) : _database = database;

  @override
  Future<int> createTask(Task task) async {
    try {
      final db = await _database.openConnetion();
      final result = await db.insert('task', task.toMap());
      /* .rawInsert("INSERT INTO task (title, description, isCompleted) VALUES (?, ?, ?)", 
           [{
             
             'title' : "use case",
             'description' :"criar design use case",
             'isCompleted' : 0
           }]
           ); */
      return result;
    } on DatabaseException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      throw TaskiException(message: "Erro ao salvar no banco");
    }
  }

  @override
  Future<int> updateTask(Task taskUpdate) async {
    try {
      final db = await _database.openConnetion();
      final result = await db.update(
          "task",
          where: 'id=?',
          taskUpdate.toMap(),
          whereArgs: [taskUpdate.id]);
      return result;
    } on DatabaseException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      throw TaskiException(message: "Erro ao atualizar dados");
    }
  }

  @override
  Future<int> deleteAll() async {
    try {
      final db = await _database.openConnetion();
      return await db.rawDelete("DELETE FROM task WHERE isCompleted =? ", [1]);
    } on DatabaseException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      throw TaskiException(
          message: "Erro ao deletas todas as tasks comlpletadas ");
    }
  }

  @override
  Future<int> delete(Task task) async {
    try {
      final db = await _database.openConnetion();
      return db.delete("task", where: "id = ?", whereArgs: [task.id]);
    } on DatabaseException catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      throw TaskiException(message: "Erro ao atualizar dados");
    }
  }

  @override
  Future<List<Task>> findSeracByTitle(String title) async {
    try {
      if(title.isEmpty) {throw TaskiException(message: "Campo invalido");}
      
      final db = await _database.openConnetion();
      final result =
          await db.query('task', where: 'title LIKE ?', whereArgs: ['$title%']);
      return result.map((e) => Task.fromMap(e)).toList();
    } on Exception catch (e) {
      log("Erro $e");
      throw TaskiException(message: "Erro ao buscar dados :$e");
    }
  }

  @override
  Future<List<Task>> findTasks() async {
    try {
      final db = await _database.openConnetion();
      final result = await db.rawQuery('SELECT *FROM task');
      return result.map((e) => Task.fromMap(e)).toList();
    } on Exception catch (e) {
      log("Erro $e");
      throw TaskiException(message: "Erro ao buscar dados ");
    }
  }

  @override
  Future<List<Task>> findTasksCompleted() async {
    try {
      final db = await _database.openConnetion();
      final result =
          await db.query('task', where: 'isCompleted = ?', whereArgs: [1]);
      return result.map((e) => Task.fromMap(e)).toList();
    } on Exception catch (e) {
      log("Erro $e");
      throw TaskiException(message: "Erro ao buscar dados :$e");
    }
  }
}
