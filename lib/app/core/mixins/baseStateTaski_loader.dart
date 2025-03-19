import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseStateTaski<T extends StatefulWidget> extends State<T> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
       onReady();
    });
  }
  onReady(){ }
   
  showLoader() {
    isLoading = true;
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
  }

  hideLoader() {
    if(isLoading){
        Navigator.of(context).pop();
        isLoading = false;
    }
  
  }
}
