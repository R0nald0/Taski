import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:taski_todo/app/core/exceptions/taski_exception.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';

class TaskController extends Cubit<TasksState> {
  final ITaskiRepository _taskiRepository;
  
  TaskController({required ITaskiRepository taskRepository})
      : _taskiRepository = taskRepository,
        super(TasksState.initial());
  
  Future<void> findAllTasks() async {
    try {
      emit(state.copyWith(state: TaskStatus.loading));

      final tasks = await _taskiRepository.findTasks();
      emit(state.copyWith(tasks: tasks, state: TaskStatus.loaded));
    } on TaskiException catch (e) {
      emit(state.copyWith(erro: e.message, state: TaskStatus.erro));
    }
  }

   Future<void> findAllTasksCompleted() async {
    try {
      emit(state.copyWith(state: TaskStatus.loading));
      
      final taskCompleteds = await _taskiRepository.findTasksCompleted();

      emit(state.copyWith(tasks: taskCompleteds, state: TaskStatus.loaded));
    } on TaskiException catch (e) {
      emit(state.copyWith(erro: e.message, state: TaskStatus.erro));
    }
  }

  Future<void> updateCheck(bool isCheck, Task task) async {
    try {
      emit(state.copyWith(state: TaskStatus.loading));
  
      await _taskiRepository.updateTask(task);
      
      final tasks = await _taskiRepository.findTasks();
      emit(state.copyWith(state: TaskStatus.loaded, tasks: tasks));

    }  on TaskiException catch (e) {
      emit(state.copyWith(state: TaskStatus.erro, erro: e.message));
    }on Exception catch(e,s){
        log("Erro $e ,$s");
        emit(state.copyWith(state: TaskStatus.erro, erro: "Erro ao atualizar"));
    } 
  }
   Future<void> delete(Task task) async {
    try {
      emit(state.copyWith(state: TaskStatus.loading));
      await _taskiRepository.delete(task);
    
      final tasks = await _taskiRepository.findTasksCompleted();
      emit(state.copyWith(state: TaskStatus.loaded, tasks: tasks));

    } on TaskiException catch (e) {
      emit(state.copyWith(state: TaskStatus.erro, erro: e.message));
    }
  }
  
  Future<void> deleteAll() async {
    try {
      emit(state.copyWith(state: TaskStatus.loading));
      await _taskiRepository.deleteAll();
      
      final tasks = await _taskiRepository.findTasksCompleted();
      emit(state.copyWith(state: TaskStatus.loaded, tasks: tasks));

    } on TaskiException catch (e) {
      emit(state.copyWith(state: TaskStatus.erro, erro: e.message));
    }
  }
  
}
