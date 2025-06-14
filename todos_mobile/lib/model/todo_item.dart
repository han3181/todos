class TodoItem {
  int? id;
  String? title;
  String? description;
  String? dueDate;
  String? category;
  bool? isCompleted;
  bool? isPriority;
  String? createdAt;
  String? updatedAt;

  TodoItem({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.category,
    this.isCompleted,
    this.isPriority,
    this.createdAt,
    this.updatedAt,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    dueDate: json['due_date'],
    category: json['category'],
    isCompleted: json['isCompleted'],
    isPriority: json['isPriority'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'due_date': dueDate,
    'category': category,
    'isCompleted': isCompleted,
    'isPriority': isPriority,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  TodoItem copyWith({
    int? id,
    String? title,
    String? description,
    String? dueDate,
    String? category,
    bool? isCompleted,
    bool? isPriority,
    String? createdAt,
    String? updatedAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      isPriority: isPriority ?? this.isPriority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
