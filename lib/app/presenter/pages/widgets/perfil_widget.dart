import 'dart:io';

import 'package:flutter/material.dart';
    
class PerfilWidget extends StatelessWidget {
  
  final String name;
  final  String? imgUrl;
  final VoidCallback onTap;
 
   const PerfilWidget({ super.key ,
    required this.name,
    required this.imgUrl,
    required this.onTap   
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  InkWell(
      onTap: onTap,

      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 16,
            children: [
            Text(name,
            style:theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            CircleAvatar(
              backgroundImage: imgUrl != null 
                  ? FileImage( File(imgUrl!)) as ImageProvider
                : AssetImage("assets/images/user-profile.png"),
            )
          ],),
    );
  }
}