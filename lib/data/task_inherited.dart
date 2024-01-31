import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task.dart';
import '../utils/utils.dart';
import '../model/task_dto.dart';

class TaskInherited extends InheritedWidget {
  TaskInherited({
    super.key,
    required Widget child,
  }) : super(child: child);

  static const String firstTaskImage =
      'https://play-lh.googleusercontent.com/5e7z5YCt7fplN4qndpYzpJjYmuzM2WSrfs35KxnEw-Ku1sClHRWHoIDSw3a3YS5WpGcI';

  final List<Task> taskList = [
    Task(
      key: UniqueKey(),
      name: 'Teste2',
      taskLevel: 5,
      image: firstTaskImage,
    ),
  ];

  void newTask(TaskDTO taskDTO) {
    taskList.add(Task(
        key: UniqueKey(),
        name: taskDTO.taskName,
        taskLevel: taskDTO.difficulty,
        image: taskDTO.imageURL));
  }

  void removeTask(Key? key){
      taskList.removeWhere((element) => element.key == key);
  }

  static TaskInherited of(BuildContext context) {
    final TaskInherited? result =
        context.dependOnInheritedWidgetOfExactType<TaskInherited>();
    assert(result != null, 'No TaskInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskInherited oldWidget) {
    return oldWidget.taskList.length != taskList.length;
  }
}
