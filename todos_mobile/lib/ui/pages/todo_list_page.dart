import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todos_mobile/model/todo_item.dart';
import 'package:todos_mobile/provider/todo_provider.dart';
import 'package:todos_mobile/ui/widget/todo_form.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  void _showAddEditTodoSheet(
    BuildContext context,
    WidgetRef ref, [
    TodoItem? todo,
  ]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: TodoForm(
            initialTodo: todo,
            onSave: (todo) async {
              if (todo.id == null) {
                await ref.read(todoNotifierProvider.notifier).addTodo(todo);
              } else {
                await ref.read(todoNotifierProvider.notifier).updateTodo(todo);
              }
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  String formatDueDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(parsed.year, parsed.month, parsed.day);

    if (date == today) return 'Today';

    return DateFormat(
      'd MMMM yyyy',
      'id_ID',
    ).format(parsed); // contoh: "3 Juni 2025"
  }

  void _toggleCompleted(WidgetRef ref, TodoItem todo, bool? value) async {
    if (todo.id == null) return; // safety check

    final updatedTodo = todo.copyWith(isCompleted: value ?? false);
    await ref.read(todoNotifierProvider.notifier).updateTodo(updatedTodo);
  }

  void _deleteTodo(BuildContext context, WidgetRef ref, TodoItem todo) async {
    if (todo.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(todoNotifierProvider.notifier).deleteTodo(todo.id!);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Todos'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: todosAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    "You're all caught up!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: todos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: todo.isCompleted!
                      ? Colors.deepPurple.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleCompleted(
                        ref,
                        todo,
                        !(todo.isCompleted ?? false),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: todo.isCompleted!
                              ? Colors.deepPurple
                              : Colors.transparent,
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                        width: 24,
                        height: 24,
                        child: todo.isCompleted!
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title ?? "-",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: todo.isCompleted == true
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isCompleted == true
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          if (todo.description != null &&
                              todo.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                todo.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          if (todo.dueDate != null && todo.dueDate!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.deepPurple.shade400,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Due: ${formatDueDate(todo.dueDate)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.deepPurple.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Tombol Edit
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      onPressed: () =>
                          _showAddEditTodoSheet(context, ref, todo),
                    ),
                    // Tombol Delete
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteTodo(context, ref, todo),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Something went wrong.\n$error',
            style: TextStyle(color: Colors.red.shade700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTodoSheet(context, ref),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, size: 28),
        elevation: 6,
      ),
    );
  }
}
