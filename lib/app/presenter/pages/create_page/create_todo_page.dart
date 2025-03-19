import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/domain/model/task.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/bloc/task_state.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';
import 'package:validatorless/validatorless.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends BaseStateTaski<CreateTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleTaskEC = TextEditingController();
  final _descriptionTaskEC = TextEditingController(); 
  late TaskController controller;

  @override
  onReady() {
     controller = context.read<TaskController>();
    return super.onReady();
  }
 
 
  @override
  void dispose() {
    _titleTaskEC.dispose();
    _descriptionTaskEC.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: BlocListener<TaskController, TasksState>(
        listener: (context, state) {
             switch (state.state) {
                 case TaskStatus.loading:{
                    showLoader();
                    return;
                 }
                 case TaskStatus.erro:{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.erro ?? "Erro desconhecido")));
                     return;
                 }
                 case _:hideLoader();
             
            } 
        },
        child: Padding(
            padding: const EdgeInsets.all(26),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Checkbox(
                            value: false,
                            splashRadius: 50,
                            shape: ContinuousRectangleBorder(
                              side: BorderSide(color: const Color.fromARGB(255, 96, 98, 102)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onChanged: (value) {}),
                        Expanded(
                            child: Text(
                          "What's in your mind?",
                          style: context
                              .theme()
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey),
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: _titleTaskEC,
                        keyboardType: TextInputType.text,
                        validator: Validatorless.multiple([
                          Validatorless.min(
                              5, "O campo precisar ter no mínimo 5 caractres"),
                          Validatorless.required("Campo requerido")
                        ]),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Add a note..."),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: _descriptionTaskEC,
                        keyboardType: TextInputType.text,
                        validator: Validatorless.multiple([
                          Validatorless.min(10,
                              "O campo precisar ter no mínimo 10 caractres"),
                          Validatorless.required("Campo requerido")
                        ]),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.notes_rounded,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Add a Description..."),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (isValid) {
                            final task = Task(
                              title: _titleTaskEC.text,
                              description: _descriptionTaskEC.text,
                              isCompleted: false,
                            );
                            clearTextFields();
                            controller.createTask(task);
                          }
                        },
                        child: Text(
                          'Create',
                          style: context.theme().textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ,
      ),
    );
  }

  void clearTextFields() {
    _descriptionTaskEC.text = "";
    _titleTaskEC.text = "";
  }
}
