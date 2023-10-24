import 'package:flutter/material.dart';
import 'package:sql_prueba/database/database_service.dart';

import 'model/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    final _db = DatabaseService();
    _db.getDatabase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: "New Task"),
                )),
                IconButton(onPressed: () {
                  if (_controller.text.isNotEmpty){
                    _db.insertTask(Task(title: _controller.text));
                    setState(() {
                      _controller.clear();
                    });
                  }
                }, icon: const Icon(Icons.add))
              ],
            ),
          ),
          Expanded(child: FutureBuilder<List<Task>>(
            future: _db.tasks(),
            builder: (context, snapshot){
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                final tasks = snapshot.data!;
                return ListView.builder(itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    trailing: IconButton(onPressed: () { setState(() { _db.deleteTask(tasks[index].id);});}, icon: const Icon(Icons.delete),),
                  );
                },itemCount: tasks.length,);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
