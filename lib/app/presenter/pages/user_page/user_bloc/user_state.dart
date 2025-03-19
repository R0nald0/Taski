import 'package:flutter/material.dart';
import 'package:taski_todo/app/domain/model/user.dart';

enum UserStatus { initial, loading, success, erro }

class UserState {
  final User? user;
  final String? erro;
  final UserStatus status;
  
    UserState({
    required this.status,
    this.user,
    this.erro
  });


 const UserState.initial()
      : status = UserStatus.initial,
        erro = null,
        user = null;
  UserState copyWith({
    ValueGetter<User?>? user,
    ValueGetter<String?>? erro,
    UserStatus? status    
  }) {
    return UserState(
          user: user != null ? user() : this.user,
      erro: erro != null ? erro() : this.erro,
      status: status ?? this.status
    );
  }
}
