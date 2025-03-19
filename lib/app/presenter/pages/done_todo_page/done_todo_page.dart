import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';

class DoneTodoPage extends StatefulWidget {
  const DoneTodoPage({super.key});

  @override
  State<DoneTodoPage> createState() => _DoneTodoPageState();
}

class _DoneTodoPageState extends BaseStateTaski<DoneTodoPage> {
   late TaskController controller;
   @override
  onReady() { 
    controller = context.read<TaskController>();
    controller.findAllTasksCompleted();    
    return super.onReady();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Completed Tasks",
                  style: context.theme().textTheme.titleLarge?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {controller.deleteAll();},
                  child: Text(
                    'Delete all',
                    style: context.theme().textTheme.labelLarge?.copyWith(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                  ),
                )
              ],
            ),
          ),
          BlocConsumer<TaskController, TasksState>(
            listener: (context, state) {
              switch (state.state) {
                case TaskStatus.loading:
                  showLoader();
                case TaskStatus.erro:{
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.erro!)));
                       hideLoader(); 
                    return;
                  }
                  case _ : hideLoader();
              }
            },
            builder: (context, state) {
              if (state.state == TaskStatus.loaded) {
                return state.tasks.isEmpty 
                ? SizedBox(height: context.height() * 0.6 
                    ,child: Center(child: Text("Nenhuma Task Foi Concluída",
                    style: context.theme().textTheme.titleMedium,
                    ))) 
                : Expanded(
                  child: ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          minVerticalPadding: 18,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 0)),
                          tileColor: const Color.fromARGB(255, 178, 188, 194),
                          leading: Checkbox(
                              activeColor: Colors.grey.shade400,
                              value: true,
                              splashRadius: 50,
                              shape: ContinuousRectangleBorder(
                                side: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onChanged: (valueChange) {}),
                          title: Text(
                            task.title,
                            style: context
                                .theme()
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: Colors.grey.shade300, fontSize: 17),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                controller.delete(task);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      );
                    },
                  ),
                );
              }
              return SizedBox(height: 50,child: Center(child: Text("Nenhuma Task Foi Concluída")));
            },
          ),
        ],
      ),
    ));
  }
}
