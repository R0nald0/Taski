import 'package:flutter/material.dart';

abstract class BaseStateTaski<T extends StatefulWidget> extends State<T> {
  var isLoading = false;
  
  @override
  void dispose() {
    disposeState();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
       onReady();
    });
  }

  void disposeState(){}


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
