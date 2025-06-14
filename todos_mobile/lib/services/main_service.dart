import 'package:dio/dio.dart';
import 'package:todos_mobile/model/todo_item.dart';

const baseUrl = 'http://127.0.0.1:8000/api';

class TodoService {
  final Dio dio;

  TodoService(this.dio);

  Future<List<TodoItem>> fetchTodos() async {
    final response = await dio.get('/get');
    final data = response.data as List;
    return data.map((e) => TodoItem.fromJson(e)).toList();
  }

  Future<List<TodoItem>> getTodayTodos() async {
    final response = await dio.get('/get/today');
    final data = response.data as List;
    return data.map((e) => TodoItem.fromJson(e)).toList();
  }

  Future<void> createTodo(TodoItem todo) async {
    await dio.post('/add', data: todo.toJson());
  }

  Future<void> updateTodo(TodoItem todo) async {
    await dio.put('/add', data: todo.toJson());
  }

  Future<void> deleteTodo(int id) async {
    await dio.post('/delete', data: {'id': id});
  }
}
