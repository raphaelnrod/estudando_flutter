import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task_level.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:nosso_primeiro_projeto/screens/add_task_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Task extends StatefulWidget {
  final String name;
  final String image;
  final int taskLevel;

  static const String defaultImage =
      'https://rafaturis.com.br/wp-content/uploads/2014/01/default-placeholder.png';

  Task(
      {Key? key,
      required this.name,
      required this.taskLevel,
      this.image = defaultImage})
      : super(key: key);

  int level = 0;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  static const int FIXED_TASK_LEVEL = 5;
  bool isDeleteEvent = false;
  bool isEditEvent = false;

  int calculatedLevel() {
    return FIXED_TASK_LEVEL * widget.taskLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TapRegion(
        onTapOutside: (tap) {
          setState(() {
            isDeleteEvent = false;
            isEditEvent = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! < 0) {
                setState(() {
                  isDeleteEvent = true;
                });
              }
            },
            onLongPress: () {
              setState(() {
                isEditEvent = true;
              });
            },
            child: Card(
              color: const Color.fromARGB(222, 248, 250, 252),
              clipBehavior: Clip.hardEdge,
              child: Table(
                children: <TableRow>[
                  TableRow(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 90,
                          child: ClipRRect(
                            child: Image(
                                image: NetworkImage(widget.image),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 32, 32),
                          child: SizedBox(
                            width: 175,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                TaskLevel(level: widget.taskLevel)
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: isDeleteEvent
                                      ? Colors.red
                                      : widget.level >= calculatedLevel()
                                          ? Colors.orange
                                          : Colors.blue,
                                  elevation: 3,
                                  padding: const EdgeInsets.all(4),
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  fixedSize: const Size(50, 50)),
                              child: isDeleteEvent
                                  ? const Icon(Icons.delete,
                                      color: Colors.white)
                                  : (isEditEvent
                                      ? const Icon(Icons.edit,
                                          color: Colors.white)
                                      : Text(
                                          widget.level >= calculatedLevel()
                                              ? 'RESET'
                                              : 'LEVEL UP',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        )),
                              onPressed: () {
                                if (isDeleteEvent) {
                                  setState(() {
                                    TaskDao().delete(widget.name);
                                  });
                                  return;
                                } else if (isEditEvent) {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (newContext) =>
                                                  AddTaskScreen(
                                                    homeContext: context,
                                                    taskName: widget.name,
                                                  )))
                                      .then((value) => setState(() {}));
                                  return;
                                }
                                setState(() {
                                  if (widget.level >= calculatedLevel()) {
                                    widget.level = 0;
                                    return;
                                  }
                                  widget.level++;
                                });
                              },
                            ),
                            const SizedBox(width: 8)
                          ],
                        )
                      ],
                    ),
                  ]),
                  //TableRow(children: []),
                  TableRow(children: [
                    Container(
                      color: widget.level >= calculatedLevel()
                          ? Colors.blueGrey
                          : Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              LinearPercentIndicator(
                                lineHeight: 5.0,
                                width: 250,
                                animation: false,
                                percent: (widget.level / calculatedLevel()),
                                backgroundColor: Colors.white70,
                                progressColor: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Nível: ${widget.level}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
