import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/domain/repository/i_taski_repository.dart';
import 'package:taski_todo/app/presenter/page_controller.dart';
import 'package:taski_todo/app/presenter/page_state.dart';
import 'package:taski_todo/app/presenter/pages/create_page/create_taski_controller.dart';
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
  final pageController = PageController();
  late UserController userController;
  late PageStateController pageStateController;

  @override
  onReady() {
    userController = context.read<UserController>();
    userController.findUser();

    return super.onReady();
  }

  @override
  Widget build(BuildContext context) {
    pageStateController = context.read<PageStateController>();
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
                  case UserStatus.success:
                    {
                      state.user != null && state.user!.name.isNotEmpty
                          ? state.user!.name
                          : "User";
                    }
                    break;
                  default:
                }
              },
              builder: (context, state) {
                return PerfilWidget(
                  imgUrl: state.user?.image,
                  name: state.user?.name ?? "Perfil",
                  onTap: () async {
                    navigator.pushNamed("/user");
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<PageStateController, PageState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.index,
            backgroundColor: Colors.blueGrey,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue,
            enableFeedback: true,
            onTap: (index) {
              pageController.jumpToPage(index);
              pageStateController.next(index);
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.list_rounded),
                label: 'Taski',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: 'Create'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box_outlined), label: 'Done'),
            ],
          );
        },
      ),
      body: BlocBuilder<PageStateController, PageState>(
        builder: (context, indexState) {
          return PageView(
            controller: pageController,
            onPageChanged: (index) {
              pageStateController.next(index);
            },
            children: [
              TodoPage(
                controller: context.read<TaskController>(),
              ),
              BlocProvider(
                create: (context) => CreateTaskiController(taskController: context.read<ITaskiRepository>()),
                child: CreateTodoPage(),
              ),
              BlocProvider(
                create: (context) =>
                    SearchPageController(taskiRepository: context.read()),
                child: SearchPage(),
              ),
              DoneTodoPage(),
            ],
          );
        },
      ),
    );
  }
}
