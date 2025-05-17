class ToDo {
  String? id;
  String? title;
  String? desc;
  bool isDone;
  int priority;

  ToDo({
    this.id,
    required this.title,
    this.desc,
    this.isDone = false,
    required this.priority,
  });

  static List<ToDo> todoList = [
    ToDo(id: '01', title: 'Morning Excercise', isDone: true, priority: 2),
    ToDo(id: '02', title: 'Buy Groceries', isDone: true, priority: 1),
    ToDo(id: '03', title: 'Check Emails', priority: 3),
    ToDo(id: '04', title: 'Team Meeting', priority: 2),
    ToDo(id: '05', title: 'Work on mobile apps for 2 hours', priority: 2),
    ToDo(id: '06', title: 'Dinner with Jenny', priority: 2),
    ToDo(id: '07', title: 'Go to sleep', priority: 3),
    ToDo(id: '08', title: 'Wake up', priority: 2),
    ToDo(id: '09', title: 'Have tea', priority: 2),
  ];
}
