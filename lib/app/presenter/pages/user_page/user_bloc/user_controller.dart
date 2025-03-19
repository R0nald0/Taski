import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taski_todo/app/core/exceptions/user_exception.dart';
import 'package:taski_todo/app/domain/model/user.dart';
import 'package:taski_todo/app/domain/usecase/user_use_case.dart';
import 'package:taski_todo/app/presenter/pages/user_page/user_bloc/user_state.dart';

class UserController extends Cubit<UserState> {
  final UserUseCase _userUseCase;
  final ImagePicker picker = ImagePicker();

  UserController({required UserUseCase userUseCase})
      : _userUseCase = userUseCase,
        super(UserState.initial());

  Future<void> pickerImage() async {
    emit(state.copyWith(status: UserStatus.loading));
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      emit(state.copyWith(user: () => state.user, status: UserStatus.success));
      return;
    }
    
    final imagePath = image.path;

  
    final user = User(name: state.user?.name??"", image: imagePath);
    emit(state.copyWith(status: UserStatus.success, user: () => user));
  }


  Future<void> findUser() async {
    emit(state.copyWith(status: UserStatus.loading));
  
    final (erro, user) = await _userUseCase.getData();
    if (erro != null) {
      switch (erro) {
        case UserNotFound():
          emit(state.copyWith(
              erro: () => "Usuário não encontrado", status: UserStatus.erro));
        case UserRepositoryException(errorMessage: final erro):
          emit(state.copyWith(erro: () => erro, status: UserStatus.erro));
      }
    }

    if (user == null) {
      emit(state.copyWith(user: () => null, status: UserStatus.success));
      return;
    }

    emit(state.copyWith(user: () => user, status: UserStatus.success));
  }

  Future<void> createUser(String name) async {  
    final user = User(name: name, image: state.user?.image);

    emit(state.copyWith(status: UserStatus.loading));
    await _userUseCase.setData(user);
    
    emit(state.copyWith(status: UserStatus.success,user: () =>user));
  }

  Future<void> remove() async {
    emit(state.copyWith(status: UserStatus.loading));
    _userUseCase.remove("user");
    emit(state.copyWith(status: UserStatus.success));
  }
}
