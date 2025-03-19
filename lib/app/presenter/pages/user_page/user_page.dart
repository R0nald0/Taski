import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taski_todo/app/core/mixins/baseStateTaski_loader.dart';
import 'package:taski_todo/app/presenter/commons/extensions.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_controller.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_state.dart';
import 'package:validatorless/validatorless.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends BaseStateTaski<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleTaskEC = TextEditingController();
  late UserController controller ;

  
@override
  onReady() {
     controller =context.read<UserController>();
     controller.findUser();
    return super.onReady();
  }

  @override
  void dispose() {
    _titleTaskEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<UserController, UserState>(
          listener: (context, state) {
            switch (state.status) { 
              case UserStatus.loading:
                  showLoader();
              case UserStatus.erro: {
                  hideLoader();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("${state.erro}")));
                }
              case _:  {hideLoader();}
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case UserStatus.success:{
                  _titleTaskEC.text  = state.user != null ? state.user!.name : "";
                return  CustomScrollView(
                    slivers: [
                      SliverAppBar.medium(
                        actions: [
                          IconButton(
                            color: Colors.white,
                            style: ButtonStyle(
                            backgroundColor:WidgetStatePropertyAll(Colors.grey.shade400.withAlpha(50)) ,
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))
                            )
                            ),
                            splashRadius: 30,
                              onPressed: () {
                                 controller.pickerImage(); 
                              }, 
                              icon: Icon(Icons.add_a_photo_outlined),)
                        ],
                        flexibleSpace: state.user != null 
                        ? Image.file(
                           File(state.user!.image!),
                          fit: BoxFit.cover,
                        )
                        : Image.asset("assets/images/user-profile.png",fit: BoxFit.cover,),
                        title: Text( state.user != null ? state.user!.name :"Profile"),
                        centerTitle: true,
                        leading: IconButton(
                            color: Colors.white,
                            style: ButtonStyle(
                            backgroundColor:WidgetStatePropertyAll(Colors.grey.shade400.withAlpha(50)) ,
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))
                            )
                            ),
                            splashRadius: 30,
                              onPressed: () {
                                 Navigator.of(context).pop(state.user);
                              }, 
                              icon: Icon(Icons.close),),
                        collapsedHeight: context.height() * 0.22,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 12),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _titleTaskEC ,
                              keyboardType: TextInputType.text,
                              validator: Validatorless.multiple([
                                Validatorless.min(5,
                                    "O campo precisar ter no mínimo 5 caractres"),
                                Validatorless.required("Campo requerido")
                              ]),
                              
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: "Add your Name"),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (isValid) {
                                controller.createUser(_titleTaskEC.text);
                              }
                            },
                            child: Text(
                              'Create',
                              style: context
                                  .theme()
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ))
                    ],
                  );
                
                }
                case _: {}
            }
            print(state.user?.image);
            return Center(child: Text("No User"));
          },
        ),
      ),
    );
  }
}
