import 'package:flutter/material.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/create_page/create_todo_page.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';
    
void modalBottomSheetCreateTask(BuildContext context,TaskController controller){
  
   showModalBottomSheet(
    elevation: 30,
    context: context,
   builder: (modalContaxt) {
     return Container(
         color: Colors.grey,
         width: double.infinity,
         height: modalContaxt.height() *0.4,
         child: CreateTodoPage(controller: controller,)
     );
   });
}