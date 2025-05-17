import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/widgets/todo_item.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ToDoService _toDoService = ToDoService();
  List<ToDo> _foundToDo = [];
  final _addTodoTitleController = TextEditingController();
  final _addTodoDescController = TextEditingController();
  final _addTodoPriorityController = TextEditingController();
  final _updateTodoTitleController = TextEditingController();
  final _updateTodoDescController = TextEditingController();
  final _updateTodoPriorityController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchTasksFromBack4App();
  }

  Future<void> _logout() async {
    final success = await _authService.logout();
    if (success) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } else {
      print("Logout failed. Please try again.");
    }
  }

  Future<void> _fetchTasksFromBack4App() async {
    final tasks = await _toDoService.fetchTasksByUser();
    setState(() {
      _foundToDo = tasks;
    });
  }

  void _toggleStatus(ToDo todo) async {
    final success = await _toDoService.toggleStatus(todo);
    if (success) {
      setState(() {
        // No need to toggle again, just refresh the UI
      });
    }
  }

  void _deleteToDoItem(String id) async {
    final success = await _toDoService.deleteToDo(id);
    if (success) {
      setState(() {
        _foundToDo.removeWhere((item) => item.id == id);
      });
    }
  }

  void _addToDoItem(ToDo todo) async {
    final newTodo = await _toDoService.addToDo(todo);
    if (newTodo != null && mounted) {
      setState(() {
        _foundToDo.add(newTodo);
        _sortToDoByPriority();
      });
    }
  }

  void _updateToDoItem(ToDo todo) async {
    todo.title = _updateTodoTitleController.text.trim();
    todo.desc = _updateTodoDescController.text.trim();
    todo.priority =
        int.tryParse(_updateTodoPriorityController.text.trim()) ??
        todo.priority;
    print('Title = ${todo.title}, \nDesc${todo.desc}, \n${todo.priority}');
    final success = await _toDoService.updateToDo(todo);
    if (success) {
      setState(() {
        // Rebuild UI to show the updated task
      });
    }
    _updateTodoTitleController.clear();
    _updateTodoDescController.clear();
    _updateTodoPriorityController.clear();
  }

  void _runFilter(String enteredKeyWord) {
    print('invoked');
    setState(() {
      _foundToDo = _toDoService.searchToDo(enteredKeyWord);
      _foundToDo.forEach((item) => print(item));
    });
  }

  void _sortToDoByPriority() {
    setState(() {
      _foundToDo.sort((a, b) => a.priority.compareTo(b.priority));
    });
  }

  void _showAddDialog() {
    _addTodoTitleController.text = '';
    _addTodoDescController.text = '';
    _addTodoPriorityController.text = '1';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Add ToDo Item',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _addTodoTitleController,
                    decoration: InputDecoration(hintText: 'Enter task title'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _addTodoDescController,
                    decoration: InputDecoration(hintText: 'Enter task desc'),
                  ),
                ),
                DropdownButtonFormField<int>(
                  value: int.tryParse(_addTodoPriorityController.text) ?? 1,
                  items: List.generate(
                    3,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged:
                      (value) => {
                        setState(() {
                          _addTodoPriorityController.text = value.toString();
                        }),
                      },
                  decoration: InputDecoration(
                    hintText: 'Select a priority (1-3)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _addTodoTitleController.clear();
                  _addTodoDescController.clear();
                  _addTodoPriorityController.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_addTodoTitleController.text.isNotEmpty &&
                      _addTodoPriorityController.text.isNotEmpty) {
                    _addToDoItem(
                      ToDo(
                        title: _addTodoTitleController.text,
                        desc: _addTodoDescController.text,
                        priority:
                            int.tryParse(_addTodoPriorityController.text) ?? 1,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showEditDialog(ToDo todo) {
    _updateTodoTitleController.text = todo.title ?? '';
    _updateTodoDescController.text = todo.desc ?? '';
    _updateTodoPriorityController.text = todo.priority.toString() ?? '1';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Edit ToDo Item',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _updateTodoTitleController,
                    decoration: InputDecoration(hintText: 'Update task title'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _updateTodoDescController,
                    decoration: InputDecoration(hintText: 'Update task desc'),
                  ),
                ),
                DropdownButtonFormField<int>(
                  value: todo.priority,
                  items: List.generate(
                    3,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _updateTodoPriorityController.text =
                          value.toString() ?? "";
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Select a number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _updateTodoTitleController.clear();
                  _updateTodoDescController.clear();
                  _updateTodoPriorityController.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateToDoItem(todo);
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'List of tasks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                      ),
                      for (ToDo todo in _foundToDo)
                        ToDoItem(
                          todo: todo,
                          changeItemStatus: _toggleStatus,
                          onDeleteItem: _deleteToDoItem,
                          onEditItem: (todo) => _showEditDialog(todo),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                _showAddDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                minimumSize: Size(40, 40),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '+',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey, fontFamily: 'JetBrains Mono'),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'To Do App',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout, color: Colors.red),
                onPressed: _logout,
                tooltip: 'Logout',
              ),
              SizedBox(
                width: 35,
                height: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/avatar.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addTodoTitleController.dispose();
    _addTodoDescController.dispose();
    _addTodoPriorityController.dispose();
    _updateTodoTitleController.dispose();
    _updateTodoDescController.dispose();
    _updateTodoPriorityController.dispose();
    super.dispose();
  }
}
