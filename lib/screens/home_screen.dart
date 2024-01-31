import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHide = false;

  @override
  Widget build(BuildContext context) {
    return TaskInherited(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Tarefas',
              style: TextStyle(color: Colors.white)),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  setState(() {
                    isHide = !isHide;
                  });
                },
                child: isHide
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off))
          ],
        ),
        body: AnimatedOpacity(
          opacity: isHide ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 800),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 70),
            child: FutureBuilder(
                future: TaskDao().findAll(),
                builder: (context, snapshot) {
                  List<Task>? itens = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.none ||
                          ConnectionState.waiting ||
                          ConnectionState.active:
                      return const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Carregando')
                          ],
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasData && itens != null) {
                        if (itens.isNotEmpty) {
                          return ListView.builder(
                              itemCount: itens.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Task tarefa = itens[index];
                                return tarefa;
                              });
                        }
                        return const Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 80,
                              ),
                              Text(
                                'Não há nenhuma tarefa',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ); //NENHUMA TAREFA ENCONTRADA
                      }
                      return const Text('Erro ao carregar Tarefas...');
                    default:
                      return const Text('Erro desconhecido...');
                  }
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: "Adicionar tarefa",
            backgroundColor: Colors.black45,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_task),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextNew) =>
                              AddTaskScreen(homeContext: context)))
                  .then((value) => setState(() {}));
            }),
      ),
    );
  }
}
