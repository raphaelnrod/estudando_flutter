import 'package:flutter/material.dart';

class TaskLevel extends StatefulWidget {
  final int level;

  const TaskLevel({super.key, required this.level});

  @override
  State<TaskLevel> createState() => _TaskLevelState();
}

class _TaskLevelState extends State<TaskLevel> {
  List<Icon> getLevelStars() {
    List<Icon> iconList = [];
    for (int i = 0; i < 5; i++) {
      iconList.add(Icon(widget.level > i ? Icons.star : Icons.star_outline,
          size: 18, color: Colors.blueAccent));
    }
    return iconList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getLevelStars(),
    );
  }
}
