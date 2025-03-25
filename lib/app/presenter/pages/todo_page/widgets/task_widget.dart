import 'package:flutter/material.dart';
import 'package:taski_todo/app/domain/model/task.dart';

typedef IsChecked =  Function(bool);

class TaskWidget extends StatelessWidget {
 
  final Task task;
  final IsChecked onChecked;

  final ValueNotifier<bool> _isExpandedVl;
  final ValueNotifier<bool> _isCheckdVl; 

    TaskWidget({
    super.key,
    required this.task,
    required this.onChecked,

  }) : _isExpandedVl = ValueNotifier(false),
  _isCheckdVl=ValueNotifier(task.isCompleted);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IntrinsicHeight(
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _isCheckdVl,
              builder: (_,value,__) {
                return Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Checkbox(
                      value: value,
                      splashRadius: 50,
                      shape: ContinuousRectangleBorder(
                        side: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onChanged: (valueChange) {
                           _isCheckdVl.value = !value;
                           onChecked(value);
                      }),
                );
              }
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _isExpandedVl,
                  builder: (context, value, _) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      constraints: BoxConstraints.loose(
                          Size(!value ? size.height * 0.08 : size.height * 0.19, !value ? size.height * 0.08 : size.height * 0.19)
                        ),
                      child: ListTile(
                          titleAlignment: ListTileTitleAlignment.top,
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(task.title,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          subtitle: value
                              ? FractionallySizedBox(
                                 heightFactor: 0.7,
                                child: Text(
                                    task.description,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ): SizedBox.shrink(),
                          trailing: IconButton(
                            onPressed: () {
                              _isExpandedVl.value = !value;
                            },
                            icon: Icon(Icons.more_horiz_rounded),
                          )),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
