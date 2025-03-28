import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taski_todo/app/core/exceptions/taski_exception.dart';
import 'package:taski_todo/app/data/local/sqlite/database_service.dart';
import 'package:taski_todo/app/data/respository/task_repository_impl.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';

class MockDatabase extends Mock implements Database {}

class MockSqFlite extends Mock implements DatbaseService {}

class MockDatabaseConnection extends Mock {
  Future<Database> openConnetion() async => MockDatabase();
}

void main() {
  late MockSqFlite mockSqlite;
  late ITaskiRepository taskRepository;
  late MockDatabase db;

  setUp(() async {
    mockSqlite = MockSqFlite();
    db = MockDatabase();
    taskRepository = TaskRepositoryImpl(database: mockSqlite);
  });

  group('case test Find', () {
    final mockData = [
      {'id': 1, 'title': 'Estudar Flutter', 'completed': 0},
      {'id': 2, 'title': 'Fazer exercícios', 'completed': 1},
    ];

    test('When findTasks isExecute,should return list of Tasks', () async {
      when(() => mockSqlite.openConnetion()).thenAnswer((_) async => db);
      when(() => db.rawQuery('SELECT *FROM task'))
          .thenAnswer((_) async => mockData);

      final result = await taskRepository.findTasks();
      expect(result, isNotEmpty);
    });

    test('When findtasks fail,should return TaskiException ', () async {
      when(() => mockSqlite.openConnetion()).thenAnswer((_) async => db);
      when(() => db.rawQuery('SELECT *FROM task')).thenThrow(Exception());

      expect(() async => await taskRepository.findTasks(),
          throwsA(isA<TaskiException>()));
    });

    test( ' when findTasksCompleted,should return a list of task completed ', () async {
      final mockDataCompleted = [
         {'id': 2, 'title': 'Fazer exercícios', 'completed': 1},
        ];

      when(() => mockSqlite.openConnetion()).thenAnswer((_) async => db);
      when(() => db.query('task', where: 'isCompleted = ?', whereArgs: [1])).thenAnswer((_) async => mockDataCompleted);
         
          final result  = await taskRepository.findTasksCompleted();
       expect(result, isNotEmpty);
      
        });
       
       
    test(', When findTasksCompleted fail,should return TaskiException ', () async {
      when(() => mockSqlite.openConnetion()).thenAnswer((_) async => db);
      when(() => db.query('task', where: 'isCompleted = ?', whereArgs: [1])).thenThrow(Exception());

      expect(() async => await taskRepository.findTasksCompleted(),
          throwsA(isA<TaskiException>()));
    });
    
    test("Given a string valid,when findSeracByTitle ,should return a list of task with inital words", ()async{
      final mockDataFiltred = [
         {'id': 2, 'title': 'Fazer exercícios', 'completed': 1},
        ];
      when(() => mockSqlite.openConnetion()).thenAnswer((_) async=> db);
      when(() => db.query('task', where: 'title LIKE ?', whereArgs: ['F%'])).thenAnswer((_)  async=> mockDataFiltred);
   
     final result = await taskRepository.findSeracByTitle('F');
     expect(result, isNotEmpty);
     expect(result.length,1); 
     expect(result[0].title, "Fazer exercícios") ;
    });
    
     test(', When findSeracByTitle fail,should return TaskiException ', () async {
      when(() => mockSqlite.openConnetion()).thenAnswer((_) async => db);
      when(() => db.query('task', where: 'title LIKE ?', whereArgs: ['F%'])).thenThrow(Exception());

      expect(() async => await taskRepository.findSeracByTitle(""),
          throwsA(isA<TaskiException>()));
    });

  });
}
