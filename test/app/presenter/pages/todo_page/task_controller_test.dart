import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taski_todo/app/core/exceptions/taski_exception.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';

class MockTaskRepository extends Mock implements ITaskiRepository {}

class MyTypeFake extends Fake implements Task {}

void main() {
  late MockTaskRepository taskRepository;
  late TaskController taskBlocController;

  setUpAll(() {
    registerFallbackValue(Task(
        title: "teste tile", description: "teste", isCompleted: false, id: 1));
  });

  setUp(() {
    taskRepository = MockTaskRepository();
    taskBlocController = TaskController(taskRepository: taskRepository);
  });

  group("BlocController finds test", () {
    final mockData = [
      Task(
          title: "Correr",
          description: "Correr 50km em 3hrs",
          isCompleted: false),
      Task(
          title: "Comer", description: "Commer mais rapido", isCompleted: true),
    ];
    blocTest<TaskController, TasksState>(
        "When findTasks called,should emit state [loading, loaded] and return list of Task",
        build: () {
          when(() => taskRepository.findTasks())
              .thenAnswer((_) async => Future.value(mockData));
          return taskBlocController;
        },
        act: (controller) => controller.findAllTasks(),
        expect: () => [
              TasksState(state: TaskStatus.loading, tasks: <Task>[]),
              TasksState(state: TaskStatus.loaded, tasks: mockData)
            ]);

    blocTest<TaskController, TasksState>(
        'When findtasks fail,should emit states [loading, error] and return TaskiException',
        build: () {
          when(() => taskRepository.findTasks())
              .thenThrow(TaskiException(message: "Erro ao buscar tasks"));
          return taskBlocController;
        },
        act: (taskBlocController) => taskBlocController.findAllTasks(),
        expect: () => [
              TasksState(state: TaskStatus.loading, tasks: List.empty()),
              TasksState(
                  state: TaskStatus.erro,
                  tasks: List.empty(),
                  erro: "Erro ao buscar tasks")
            ]);

    blocTest(
      "when findTasksCompleted,should return a list of task completed",
      build: () {
        when(() => taskRepository.findTasksCompleted())
            .thenAnswer((_) async => mockData);
        return taskBlocController;
      },
      act: (bloc) => taskBlocController.findAllTasksCompleted(),
      expect: () => [
        TasksState(state: TaskStatus.loading, tasks: List.empty()),
        TasksState(state: TaskStatus.loaded, tasks: mockData),
      ],
    );

    blocTest(
      "when findTasksCompleted,should return a list of task completed",
      build: () {
        when(() => taskRepository.findTasksCompleted())
            .thenAnswer((_) async => mockData);
        return taskBlocController;
      },
      act: (bloc) => taskBlocController.findAllTasksCompleted(),
      expect: () => [
        TasksState(state: TaskStatus.loading, tasks: List.empty()),
        TasksState(state: TaskStatus.loaded, tasks: mockData),
      ],
    );

    blocTest(
      "When findTasksCompleted fail,should emit states [loading, error] ",
      build: () {
        when(() => taskRepository.findTasksCompleted()).thenThrow(
            TaskiException(message: "Erro ao busacar tasks completeds"));
        return taskBlocController;
      },
      act: (bloc) => taskBlocController.findAllTasksCompleted(),
      expect: () => [
        TasksState(state: TaskStatus.loading, tasks: List.empty()),
        TasksState(
            state: TaskStatus.erro,
            tasks: List.empty(),
            erro: "Erro ao busacar tasks completeds"),
      ],
    );
  });
  group(
    "update test group",
    () {
      final mockData = [
        Task(
            title: "Correr",
            description: "Correr 50km em 3hrs",
            isCompleted: false),
        Task(
            title: "Comer",
            description: "Commer mais rapido",
            isCompleted: true),
      ];
      blocTest<TaskController, TasksState>(
        "when updateCheck ,should emit states [loading, loaded] and update task",
        build: () {
          //final task =
          when(() => taskRepository.updateTask(any<Task>()))
              .thenAnswer((_) async => 1);
          when(() => taskRepository.findTasks())
              .thenAnswer((_) async => mockData);

          return taskBlocController;
        },
        act: (bloc) async {
          final task = Task(
              title: "teste tile",
              description: "teste",
              isCompleted: false,
              id: 1);
          await bloc.updateCheck(true, task);
        },
        expect: () => [
          TasksState(state: TaskStatus.loading, tasks: List.empty()),
          TasksState(state: TaskStatus.loaded, tasks: mockData),
        ],
      );

      blocTest<TaskController, TasksState>(
        "when updateCheck is called failure,should emit states [loading, error] and failure update task ",
        build: () {
          when(() => taskRepository.updateTask(any<Task>()))
              .thenThrow(Exception());
          return taskBlocController;
        },
        act: (bloc) async {
          final task = Task(
              title: "teste tile",
              description: "teste",
              isCompleted: false,
              id: 1);
          await bloc.updateCheck(true, task);
        },
        expect: () => [
          TasksState(state: TaskStatus.loading, tasks: List.empty()),
          TasksState(
              state: TaskStatus.erro,
              tasks: List.empty(),
              erro: "Erro ao atualizar"),
        ],
      );
    },
  );

  group("delete test group", () {
    final mockData = [
      Task(
          title: "Correr",
          description: "Correr 50km em 3hrs",
          isCompleted: true),
      Task(
          title: "Comer", description: "Commer mais rapido", isCompleted: true),
    ];
    blocTest('when delete is called,shoudl emit [loading ,loaded]',
        build: () {
          when(() => taskRepository.delete(any())).thenAnswer((_) async => 1);
          when(() => taskRepository.findTasksCompleted())
              .thenAnswer((_) async => mockData);
          return taskBlocController;
        },
        act: (bloc) => bloc.delete(mockData[0]),
        expect: () => [
              TasksState(state: TaskStatus.loading, tasks: List.empty()),
              TasksState(state: TaskStatus.loaded, tasks: mockData)
            ]);

    blocTest('when delete is called,shoudl emit [loading ,erro]',
        build: () {
          when(() => taskRepository.delete(any()))
              .thenThrow(TaskiException(message: "Erro ao deletar"));
          return taskBlocController;
        },
        act: (bloc) => bloc.delete(mockData[0]),
        expect: () => [
              TasksState(state: TaskStatus.loading, tasks: List.empty()),
              TasksState(
                  state: TaskStatus.erro,
                  tasks: List.empty(),
                  erro: "Erro ao deletar")
            ]);

    blocTest('when deleteAll is called,should emit [loading ,loaded]',
        build: () {
          when(() => taskRepository.deleteAll()).thenAnswer((_) async => 1);
          when(() => taskRepository.findTasksCompleted())
              .thenAnswer((_) async => mockData);
          return taskBlocController;
        },
        act: (bloc) => bloc.deleteAll(),
        expect: () => [
              TasksState(state: TaskStatus.loading, tasks: List.empty()),
              TasksState(state: TaskStatus.loaded, tasks: mockData)
            ]);


        blocTest('when delete is called,shoudl emit [loading ,erro]',
        build: () {
          when(() => taskRepository.deleteAll())
              .thenThrow(TaskiException(message: "Erro ao deletar todas as tasks"));
          return taskBlocController;
        },
        act: (bloc) => bloc.deleteAll(),
        expect: () => [
              TasksState(state: TaskStatus.loading, tasks: List.empty()),
              TasksState(
                  state: TaskStatus.erro,
                  tasks: List.empty(),
                  erro: "Erro ao deletar todas as tasks")
            ]);     
  });
}
