import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/core/exceptions/taski_exception.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';

class SearchPageController extends Cubit<TasksState> {
  final ITaskiRepository _taskiRepository;
  var title = "";

  SearchPageController({required ITaskiRepository taskiRepository})
      : _taskiRepository = taskiRepository,
        super(TasksState.initial());
  
   Future<void> searchTaskByTitle(String title) async{
     try {
       
        emit(state.copyWith(state: TaskStatus.loading,tasks: []));
      
        final tasks  = await _taskiRepository.findSeracByTitle(title);
        title = title;
        emit(state.copyWith( state:TaskStatus.loaded ,tasks: tasks));

     }on TaskiException catch (e) {
        emit(state.copyWith(state: TaskStatus.erro,erro: e.message));
     }
  }
   Future<void> updateCheck(bool isCheck, Task task) async {
    try {
      
      await _taskiRepository.updateTask(task.copyWith(isCompleted: isCheck));
      emit(state.copyWith(state: TaskStatus.loading));
      final tasks = await _taskiRepository.findSeracByTitle(task.title);
      emit(state.copyWith(state: TaskStatus.loaded, tasks: tasks));

    } on TaskiException catch (e) {
      emit(state.copyWith(state: TaskStatus.erro, erro: e.message));
    }
  }
  Future<void> clearFiel() async {
     //state.copyWith(tasks: <Task>[]);
      print("CLEAR FIELD");
      emit(TasksState.initial());
  }

}
