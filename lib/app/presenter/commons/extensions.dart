
import 'package:flutter/material.dart';

extension ThemeOfApp on BuildContext{
   ThemeData theme(){
     return Theme.of(this);
   }
}

extension AppMediaQuery on BuildContext{
   
   double height(){
     return  MediaQuery.of(this).size.height;
   }
   double width (){
     return MediaQuery.of(this).size.width;
   }

}