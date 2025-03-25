import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/core/exceptions/taski_exception.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';

class CreateTaskiUseCase extends Cubit<TasksState> {
  final ITaskiRepository _taskiRepository;

  CreateTaskiUseCase({required ITaskiRepository taskController})
      : _taskiRepository = taskController,
        super(TasksState.initial());

  Future<void> createTask(Task task) async {
    try {
      emit(state.copyWith(state: TaskStatus.initial));
      emit(state.copyWith(state: TaskStatus.loading));
      await _taskiRepository.createTask(task);
      await _taskiRepository.findTasks();

      emit(state.copyWith(state: TaskStatus.loaded));
    } on TaskiException catch (e) {
      emit(state.copyWith(erro: e.message, state: TaskStatus.erro));
    }
  }
}
