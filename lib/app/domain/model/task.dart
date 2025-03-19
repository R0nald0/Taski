import 'dart:convert';

import 'package:flutter/widgets.dart';

class Task {
   final int? id;
   final String title;
   final String description;
   final bool isCompleted;

   Task({this.id ,required this.title,required this.description,required this.isCompleted}); 
 

  Task copyWith({
    ValueGetter<int?>? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id != null ? id() : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 :0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

@override
String toString() {
    return 'Task{id=$id, title=$title, description=$description, isCompleted=$isCompleted}';
  }
}
