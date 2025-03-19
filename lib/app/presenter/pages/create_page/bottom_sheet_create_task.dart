import 'package:flutter/material.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/create_page/create_todo_page.dart';
    
void modalBottomSheetCreateTask(BuildContext context){
   showBottomSheet(
  
    context: context,
   builder: (context) {
     return SizedBox(
         width: double.infinity,
         height: context.height() *0.4,
         child: CreateTodoPage()
     );
   });
}