import 'package:taski_todo/app/domain/model/task.dart';

abstract interface class ITaskiRepository {
Future<List<Task>>  findTasks();
Future<List<Task>> findTasksCompleted();
 Future<int> updateTask(Task taskUpdate);

Future<int> createTask(Task task);

Future<List<Task>> findSeracByTitle(String title);

Future<int> delete(Task task);
Future<int> deleteAll();
}