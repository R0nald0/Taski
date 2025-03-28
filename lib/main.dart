import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taski_todo/app/data/local/preferences/i_local_storage.dart';
import 'package:taski_todo/app/data/local/preferences/local_storage.dart';
import 'package:taski_todo/app/data/local/sqlite/database_service.dart';
import 'package:taski_todo/app/data/respository/task_repository_impl.dart';
import 'package:taski_todo/app/data/respository/user_repository.dart';
import 'package:taski_todo/app/domain/repository/I_user_repository.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';
import 'package:taski_todo/app/presenter/pages/create_page/create_taski_controller.dart';
import 'package:taski_todo/app/domain/usecase/user_use_case.dart';
import 'package:taski_todo/app/presenter/home_page.dart';
import 'package:taski_todo/app/presenter/page_controller.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_controller.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
          Provider<ILocalStorage>(create: (context)=>LocalStorage()),
          Provider(create: (context) => DatbaseService(),lazy: false,),

          Provider<ITaskiRepository>(create: (context)=> TaskRepositoryImpl(database:context.read())),
          Provider<IUserRepository>(create: (context)=>UserRepository(localStorage: context.read())),
          
          Provider(create: (context)=> UserUseCase(userRepository: context.read())),
          BlocProvider(lazy: false,create: (context)=> TaskController(taskRepository: context.read())),
          BlocProvider(lazy: false,create: (context)=> UserController(userUseCase: context.read())),
          BlocProvider(create: (context)=> PageStateController()),
          BlocProvider(create: (context)=> CreateTaskiController(taskController: context.read<ITaskiRepository>()))
       ],
      child: MaterialApp(
          title: 'Taski App',
          initialRoute: "/",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: {
             "/" : (context) => HomePage(),
             '/user' : (context)=>UserPage()
          },
          ),
    )
    ;
  }
}