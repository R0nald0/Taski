 import 'package:flutter/widgets.dart';

class TaskiRouter {
  final Map<String, Widget Function(BuildContext)> routes;
  
  TaskiRouter._(this.routes);

  Map<String, Widget Function(BuildContext)> get route => routes;
   //Map<String, Widget Function(BuildContext)> routes(Map<String, Widget Function(BuildContext)>) => routes = routes;
}