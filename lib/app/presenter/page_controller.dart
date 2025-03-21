
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski_todo/app/presenter/page_state.dart';

class PageStateController extends Cubit<PageState>{
  PageStateController():super(PageState.initial());
 
  void next( int index) {
     emit(state.copyWith( index: index,status: PageStatus.next ));
  }
}