import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:todo_app/model/todo.dart';

class ToDoService {
  List<ToDo> _toDosList = [];
  List<ToDo> get toDosList => _toDosList;

  Future<String> getLoggedInUserEmail() async {
    // Fetch the currently logged-in user from Back4App
    final currentUser = await ParseUser.currentUser();
    return currentUser?.get<String>('email') ?? '';
  }

  Future<List<ToDo>> fetchTasksByUser() async {
    final loggedInUserEmail = await getLoggedInUserEmail();
    print('Logged in user : ${loggedInUserEmail}');
    if (loggedInUserEmail.isEmpty) return [];

    final query =
        QueryBuilder<ParseObject>(ParseObject('Task'))
          ..whereEqualTo('createdBy', loggedInUserEmail)
          ..orderByAscending('priority');
    final response = await query.query();

    if (response.success && response.results != null) {
      print('Response Data: ${response.results}');
      _toDosList =
          response.results!.map((object) {
            final priorityField = object.get('priority');
            int priority = 1;

            if (priorityField is Map<String, dynamic> &&
                priorityField.containsKey('savedNumber')) {
              priority = priorityField['savedNumber'];
            }

            return ToDo(
              id: object.objectId,
              title: object.get<String>('title') ?? '',
              desc: object.get<String>('desc') ?? '',
              priority: object.get<int>('priority') ?? 1,
              isDone: object.get<bool>('isCompleted') ?? false,
            );
          }).toList();
      return _toDosList;
    } else {
      print('Error: ${response.error?.message}');
    }
    return [];
  }

  Future<ToDo?> addToDo(ToDo todo) async {
    final loggedInUserEmail = await getLoggedInUserEmail();
    final newTask =
        ParseObject('Task')
          ..set('title', todo.title)
          ..set('desc', todo.desc)
          ..set('priority', todo.priority)
          ..set('isCompleted', todo.isDone)
          ..set('createdBy', loggedInUserEmail);

    final response = await newTask.save();
    if (response.success) {
      final savedObject = response.results!.first;
      return ToDo(
        id: savedObject.objectId,
        title: savedObject.get<String>('title'),
        desc: savedObject.get<String>('desc'),
        priority: savedObject.get<int>('priority'),
        isDone: savedObject.get<bool>('isCompleted'),
      );
    }
    return null;
  }

  Future<bool> deleteToDo(String id) async {
    final taskObject = ParseObject('Task')..objectId = id;
    final response = await taskObject.delete();
    return response.success;
  }

  Future<bool> updateToDo(ToDo todo) async {
    final taskObject =
        ParseObject('Task')
          ..objectId = todo.id
          ..set('title', todo.title)
          ..set('desc', todo.desc)
          ..set('priority', todo.priority)
          ..set('isCompleted', todo.isDone);

    final response = await taskObject.save();
    return response.success;
  }

  Future<bool> toggleStatus(ToDo todo) async {
    todo.isDone = !todo.isDone;
    return await updateToDo(todo);
  }

  List<ToDo> searchToDo(String keyword) {
    print('_toDOsList length is ${toDosList}');
    _toDosList.forEach((item) => print(item));
    if (keyword.isEmpty) {
      return _toDosList;
    } else {
      return _toDosList
          .where(
            (item) => item.title!.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
  }
}
