import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/model/task_dto.dart';

class AddTaskScreen extends StatefulWidget {

  const AddTaskScreen({super.key, required this.homeContext});

  final BuildContext homeContext;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController diffController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  static const String defaultImage =
      'https://rafaturis.com.br/wp-content/uploads/2014/01/default-placeholder.png';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const BackButton(color: Colors.white),
          title:
              const Text("Nova Tarefa", style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  color: const Color.fromARGB(222, 248, 250, 252),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.blueGrey)),
                    width: 375,
                    height: 650,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Insira o nome da tarefa';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusColor: Colors.blueGrey,
                                  hintText: 'Nome da Tarefa',
                                  filled: true,
                                  fillColor: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: diffController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Digite uma dificuldade';
                                int number = int.parse(value);
                                if (number < 1 || number > 5) {
                                  return 'Digite um valor entre 1 e ';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusColor: Colors.blueGrey,
                                  hintText: 'Dificuldade',
                                  filled: true,
                                  fillColor: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              controller: imageController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Insira uma URL de imagem';
                                }
                                return null;
                              },
                              onChanged: (txt) {
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusColor: Colors.blueGrey,
                                  hintText: 'URL da Imagem',
                                  filled: true,
                                  fillColor: Colors.white70),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 1, color: Colors.blue),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(defaultImage,
                                          fit: BoxFit.cover);
                                    },
                                    imageController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      int diff = int.parse(diffController.text);
                                      TaskInherited.of(widget.homeContext).newTask(TaskDTO(
                                          taskName: nameController.text,
                                          difficulty: diff,
                                          imageURL: imageController.text));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Tarefa sendo criada...')));
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('SALVAR')),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }
}
