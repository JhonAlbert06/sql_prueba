import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sql_prueba/model/task.dart';

class DatabaseService {

  Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), 'todo.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute("CREATE TABLE task(id INTEGER PRIMARY KEY, title TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    final db = await getDatabase();
    await db.insert('task', task.toMap());
  }

  Future<List<Task>> tasks() async {
    final db = await getDatabase();
    final maps = await db.query('task');
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

  Future<void> updateTask(Task task) async {
    final db = await  getDatabase();
    await db.update('task', task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  Future<void> deleteTask(int? id) async {
    final db = await  getDatabase();
    await db.delete('task', where: "id = ?", whereArgs: [id]);
  }
}