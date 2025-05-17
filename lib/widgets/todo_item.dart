import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/services/utils.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final changeItemStatus;
  final onDeleteItem;
  final Function(ToDo) onEditItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.changeItemStatus,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          changeItemStatus(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        tileColor: getPriorityColor(todo.priority ?? 0),
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              todo.title!,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 15,
                color: tdBlack,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w900,
                overflow: TextOverflow.clip,
              ),
            ),
            Text(
              todo.desc ?? '',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: tdBlack,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 20,
                icon: Icon(Icons.edit),
                onPressed: () {
                  onEditItem(todo);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdRed,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 20,
                icon: Icon(Icons.delete),
                onPressed: () {
                  onDeleteItem(todo.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
