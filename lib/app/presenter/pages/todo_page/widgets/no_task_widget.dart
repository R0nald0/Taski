part of '../todo_page.dart';

class NoTaskWidget extends StatelessWidget {
  const NoTaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text("You hava no task listed",
          style: context.theme().textTheme.bodyMedium,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 19,vertical: 12),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
            label: Text('Create Task',
             style: context.theme().textTheme.titleMedium?.copyWith(
              color: Colors.blueAccent
             ),
            ),
            icon: Icon(Icons.add,size:25,color: Colors.blueAccent,),
            iconAlignment: IconAlignment.start,
            onPressed: () {
              modalBottomSheetCreateTask(context);
            },
          )
        ],
      ),
    );
  }
}
