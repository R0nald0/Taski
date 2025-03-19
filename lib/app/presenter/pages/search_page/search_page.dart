import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/presenter/pages/search_page/bloc/search_page_controller.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/widgets/task_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BaseStateTaski<SearchPage> {
  final _seachEC = TextEditingController();
  late SearchPageController controller;

  @override
  onReady() {
    controller = context.read<SearchPageController>();
    return super.onReady();
  }

  @override
  void dispose() {
    _seachEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SearchBar(
            onTapOutside:(r) {
              _seachEC.clear();
              controller.clearFiel();},
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.searchTaskByTitle(value);
              }
            },
            hintText: "Design Projects",
            elevation: WidgetStatePropertyAll(0),
            trailing: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              )
            ],
            leading: Icon(
              Icons.search,
              color: Colors.blue.shade500,
            ),
            shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.blue, width: 1))),
            controller: _seachEC,
          ),
          Expanded(
            child: BlocConsumer<SearchPageController, TasksState>(
              listener: (context, state) {
                switch (state.state) {
                  case TaskStatus.loading:
                    showLoader();
                  case TaskStatus.erro:
                    {
                      hideLoader();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.erro ?? "Erro desconhecido")));
                      return;
                    }
                  case _:
                    hideLoader();
                }
              },
              builder: (context, state) {
                if (state.state == TaskStatus.loaded) {
                  return state.tasks.isEmpty
                      ? Text("No Results content")
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
                return Center(child: Text("Find your task"));
              },
            ),
          ),
        ],
      ),
    ));
  }
}
