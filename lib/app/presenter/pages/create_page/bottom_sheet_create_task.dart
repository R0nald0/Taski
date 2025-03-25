import 'package:flutter/material.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/create_page/create_todo_page.dart';

Future<bool?> modalBottomSheetCreateTask(BuildContext context) async {
 //final isKeyBoardOpen =  MediaQuery.of(context).viewInsets.bottom > 0.6 ? true :false;
 return  await showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      elevation: 30,
      context: context,
      builder: (modalContaxt) {
        return Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: SizedBox(
                 height: context.height() *0.7 ,
                child: CreateTodoPage()),
          ),
        );
      });
}
