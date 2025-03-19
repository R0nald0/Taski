import 'package:equatable/equatable.dart';
import 'package:taski_todo/app/domain/model/task.dart';


enum TaskStatus{
   initial,loading,loaded,erro
}
class TasksState extends Equatable {
   final TaskStatus state;
   final List<Task> tasks;
   final String? erro;
   
    TasksState({
    required this.state,
    required this.tasks,
    this.erro
  });

   
   const TasksState.initial(): 
       state =TaskStatus.initial,
       tasks = const [],
       erro = null;
  
  TasksState copyWith({
    TaskStatus? state,
    List<Task>? tasks,
    String? erro    
  }) {
    return TasksState(
          state: state ?? this.state,
      tasks: tasks ?? this.tasks,
      erro: erro ?? this.erro
    );
  }
  
  @override
  
  List<Object?> get props => [state,tasks,erro];
}
