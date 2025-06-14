import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:todos_mobile/model/todo_item.dart';
import 'package:todos_mobile/services/main_service.dart';

final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(baseUrl: baseUrl)));

final todoServiceProvider = Provider<TodoService>((ref) {
  final dio = ref.watch(dioProvider);
  return TodoService(dio);
});

class TodoNotifier extends StateNotifier<AsyncValue<List<TodoItem>>> {
  final TodoService _service;

  TodoNotifier(this._service) : super(const AsyncValue.loading()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todos = await _service.fetchTodos();
      todos.sort((a, b) {
        if (a.isPriority == true &&
            (a.isCompleted == false || a.isCompleted == null)) {
          return -1;
        }
        if (b.isPriority == true &&
            (b.isCompleted == false || b.isCompleted == null)) {
          return 1;
        }
        if ((a.isCompleted == true) && (b.isCompleted != true)) return 1;
        if ((b.isCompleted == true) && (a.isCompleted != true)) return -1;
        return 0;
      });

      state = AsyncValue.data(todos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTodo(TodoItem todo) async {
    try {
      await _service.createTodo(todo);
      await loadTodos();
    } catch (e) {
      // error handling
    }
  }

  Future<void> updateTodo(TodoItem todo) async {
    try {
      await _service.updateTodo(todo);
      await loadTodos();
    } catch (e) {
      // error handling
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _service.deleteTodo(id);
      await loadTodos();
    } catch (e) {
      // error handling
    }
  }
}

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, AsyncValue<List<TodoItem>>>(
      (ref) => TodoNotifier(ref.watch(todoServiceProvider)),
    );
