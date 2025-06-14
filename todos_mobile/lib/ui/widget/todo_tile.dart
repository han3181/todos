import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_mobile/model/todo_item.dart';
import 'package:todos_mobile/provider/todo_provider.dart';
import 'package:todos_mobile/ui/widget/todo_form.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  void _showAddTodoSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TodoForm(
          onSave: (todo) async {
            await ref.read(todoNotifierProvider.notifier).addTodo(todo);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _toggleCompleted(WidgetRef ref, TodoItem todo, bool? value) {
    final updatedTodo = TodoItem(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      dueDate: todo.dueDate,
      category: todo.category,
      isCompleted: value ?? false,
      isPriority: todo.isPriority,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
    ref.read(todoNotifierProvider.notifier).updateTodo(updatedTodo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        elevation: 4,
        shadowColor: Colors.indigoAccent.withOpacity(0.3),
      ),
      body: todosAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return Center(
              child: Text(
                'No todos yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            itemCount: todos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.indigo.withOpacity(0.15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // TODO: Edit modal here
                  },
                  splashColor: Colors.indigo.withOpacity(0.1),
                  highlightColor: Colors.indigo.withOpacity(0.05),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: todo.isCompleted == true
                          ? Colors.indigo.shade50
                          : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: todo.isPriority == true
                                ? Colors.redAccent
                                : Colors.grey.shade300,
                          ),
                          width: 36,
                          height: 36,
                          child: Icon(
                            todo.isPriority == true
                                ? Icons.priority_high
                                : Icons.check_circle_outline,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title ?? '-',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: todo.isCompleted == true
                                      ? Colors.grey.shade500
                                      : Colors.black87,
                                  decoration: todo.isCompleted == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              if (todo.description != null &&
                                  todo.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    todo.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: todo.isCompleted == true
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              if (todo.dueDate != null &&
                                  todo.dueDate!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.indigo.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Due: ${todo.dueDate}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.indigo.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (todo.category != null &&
                                  todo.category!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Chip(
                                    label: Text(
                                      todo.category!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.indigo.shade900,
                                      ),
                                    ),
                                    backgroundColor: Colors.indigo.shade100,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Animated checkbox with ripple effect
                        GestureDetector(
                          onTap: () => _toggleCompleted(
                            ref,
                            todo,
                            !(todo.isCompleted ?? false),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: todo.isCompleted == true
                                    ? Colors.indigo.shade700
                                    : Colors.grey.shade400,
                                width: 2.5,
                              ),
                              color: todo.isCompleted == true
                                  ? Colors.indigo.shade700
                                  : Colors.transparent,
                            ),
                            width: 28,
                            height: 28,
                            child: todo.isCompleted == true
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Oops, something went wrong.\n$error',
            style: TextStyle(color: Colors.red.shade700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTodoSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Todo'),
        backgroundColor: Colors.indigo.shade700,
        elevation: 6,
      ),
    );
  }
}
