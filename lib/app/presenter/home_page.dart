import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/presenter/pages/create_page/create_todo_page.dart';
import 'package:taski_todo/app/presenter/pages/done_todo_page/done_todo_page.dart';
import 'package:taski_todo/app/presenter/pages/search_page/Search_page.dart';
import 'package:taski_todo/app/presenter/pages/search_page/bloc/search_page_controller.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/task_controller.dart';
import 'package:taski_todo/app/presenter/pages/todo_page/todo_page.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_controller.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_state.dart';
import 'package:taski_todo/app/presenter/pages/widgets/perfil_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseStateTaski<HomePage> {
  var indice = 0;
  final pageController = PageController();
  late UserController controller;

  @override
  onReady() {
     controller = context.read<UserController>();
     controller.findUser();

     return super.onReady();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Taski",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            BlocConsumer<UserController, UserState>(
              listener: (context, state) {
                switch (state.status) {
                  case UserStatus.erro:{
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao buscar dados do usuarios"))
                     );
                  }
                  case UserStatus.success:{
                     state.user != null  && state.user!.name.isNotEmpty ? state.user!.name : "User" ;
                  }
                       
                    break;
                  default:
                }
              },
              builder: (context, state) {
                return PerfilWidget(
                  imgUrl: state.user?.image,
                  name: state.user?.name ?? "",
                  onTap: () async {
                    navigator.pushNamed("/user");
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: indice,
          backgroundColor: Colors.blueGrey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          enableFeedback: true,
          onTap: (index) {
            setState(() {
              indice = index;
              pageController.jumpToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.list_rounded),
                label: 'Taski',),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined), label: 'Create'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outlined), label: 'Done'),
          ],),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            indice = index;
          });
        },
        children: [
           BlocProvider(
            create: (context) => TaskController(taskRepository: context.read()),
            child:TodoPage() ,
          ),
          BlocProvider(
            create: (context) => TaskController(taskRepository: context.read()),
            child: CreateTodoPage(),
          ),
          BlocProvider(
            create: (context) =>
                SearchPageController(taskiRepository: context.read()),
            child: SearchPage(),
          ),
          BlocProvider(
            create: (context) => TaskController(taskRepository: context.read()),
            child: DoneTodoPage(),
          ),
        ],
      ),
    );
  }
}
