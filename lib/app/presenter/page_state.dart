enum PageStatus{
  initial,next;
}
class PageState {
  final int index;
   final PageStatus status; 

  PageState.initial():index = 0,status = PageStatus.initial;

      PageState({
    required this.index,
    required this.status
  });


  

  PageState copyWith({
    int? index,
    PageStatus? status    
  }) {
    return PageState(
          index: index ?? this.index,
      status: status ?? this.status
    );
  }
}
