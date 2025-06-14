import 'package:flutter/material.dart';
import 'package:todos_mobile/model/todo_item.dart';

typedef OnSaveCallback = Future<void> Function(TodoItem todo);

class TodoForm extends StatefulWidget {
  final OnSaveCallback onSave;
  final TodoItem? initialTodo;

  const TodoForm({super.key, required this.onSave, this.initialTodo});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _dueDateController;
  late TextEditingController _categoryController;

  bool _isPriority = false;
  bool _isCompleted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTodo;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _dueDateController = TextEditingController(text: t?.dueDate ?? '');
    _categoryController = TextEditingController(text: t?.category ?? '');
    _isPriority = t?.isPriority ?? false;
    _isCompleted = t?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dueDateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    DateTime? initialDate =
        DateTime.tryParse(_dueDateController.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dueDateController.text = picked.toIso8601String().split('T')[0];
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final todo = TodoItem(
      id: widget.initialTodo?.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dueDate: _dueDateController.text.trim(),
      category: _categoryController.text.trim(),
      isPriority: _isPriority,
      isCompleted: _isCompleted,
      createdAt: widget.initialTodo?.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    try {
      await widget.onSave(todo);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.initialTodo == null ? 'Add Todo' : 'Edit Todo',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                textInputAction: TextInputAction.next,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _pickDueDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dueDateController,
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                      if (!regex.hasMatch(val.trim()))
                        return 'Format should be YYYY-MM-DD';
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Priority'),
                value: _isPriority,
                activeColor: Colors.redAccent,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _isPriority = val);
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Completed'),
                value: _isCompleted,
                activeColor: Colors.deepPurple,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _isCompleted = val);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Text(
                          widget.initialTodo == null
                              ? 'Add Todo'
                              : 'Update Todo',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
