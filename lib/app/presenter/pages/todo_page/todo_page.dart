import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/domain/model/user.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/create_page/bottom_sheet_create_task.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/widgets/task_widget.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_controller.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_state.dart';

part './widgets/no_task_widget.dart';

class TodoPage extends StatefulWidget {

  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends BaseStateTaski<TodoPage> {
  late TaskController controller;
  @override
  onReady() {
    controller = context.read<TaskController>();
    controller.findAllTasks();

    return super.onReady();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocSelector<UserController, UserState, User?>(
                      selector: (state) {
                        if (state.status == UserStatus.success && state.user?.name != null  ){
                            return  state.user;
                        }
                        return User(name: "");
                      },
                      builder: (context, state) {
                        return RichText(
                          text: TextSpan(
                            text: "Welcome.",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: state?.name ?? "",
                                  style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        );
                      },
                    ),
                    BlocSelector<TaskController, TasksState, List<Task>>(
                      selector: (state) => state.tasks
                          .where((task) => task.isCompleted == true)
                          .toList(),
                      builder: (context, state) {
                        return RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Yoy,ve got',
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: Colors.grey)),
                            TextSpan(
                              text: ' ${state.length}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                  color:
                                      const Color.fromARGB(255, 64, 112, 218)),
                            ),
                            TextSpan(
                              text: ' task to do',
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ]),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: BlocConsumer<TaskController, TasksState>(
                  listener: (context, state) {
                    if (state.state == TaskStatus.erro) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.erro ?? "Erro desconhecido")));
                    }
                  },
                  builder: (context, state) {
                    if (state.state == TaskStatus.loaded) {
                      return state.tasks.isEmpty
                          ? NoTaskWidget(controller: controller,)
                          : ListView.builder(
                              itemCount: state.tasks.length,
                              itemBuilder: (context, index) {
                                final task = state.tasks[index];
                                return TaskWidget(
                                  task: task,
                                  onChecked: (value) {
                                    controller.updateCheck(!value, task);
                                  },
                                );
                              },
                            );
                    }
                    return SizedBox.fromSize();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
