import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../components/task.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  static const String _tableName = 'TASK';
  static const String _image = 'image';
  static const String _difficulty = 'difficulty';
  static const String _name = 'name';

  save(Task task) async {
    print('Iniciando o save: ');
    final Database bancoDeDados = await getDatabase();
    var itemExists = await find(task.name);
    Map<String, dynamic> taskMap = toMap(task);
    if (itemExists.isEmpty) {
      print('a Tarefa não Existia.');
      return await bancoDeDados.insert(_tableName, taskMap);
    }
    print('a Tarefa existia!');
    return await bancoDeDados.update(
      _tableName,
      taskMap,
      where: '$_name = ?',
      whereArgs: [task.name],
    );
  }

  Future<List<Task>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    print('Procurando dados... encontrei: $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapList) {
    List<Task> tasks = [];
    for (Map<String, dynamic> map in mapList) {
      Task task = Task(
          name: map[_name], taskLevel: map[_difficulty], image: map[_image]);
      tasks.add(task);
    }
    return tasks;
  }

  Map<String, dynamic> toMap(Task tarefa) {
    print('Convertendo to Map: ');
    final Map<String, dynamic> mapaDeTarefas = {};
    mapaDeTarefas[_name] = tarefa.name;
    mapaDeTarefas[_difficulty] = tarefa.taskLevel;
    mapaDeTarefas[_image] = tarefa.image;
    print('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  Future<List<Task>> find(String taskName) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result =
        await db.query(_tableName, where: '$_name = ?', whereArgs: [taskName]);
    return toList(result);
  }

  delete(String taskName) async {
    print('Deletando tarefa: $taskName');
    final Database bancoDeDados = await getDatabase();
    return await bancoDeDados.delete(
      _tableName,
      where: '$_name = ?',
      whereArgs: [taskName],
    );
  }
}
