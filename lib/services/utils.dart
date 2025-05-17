import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

Color getPriorityColor(int priority) {
  switch (priority) {
    case 1:
      return tdPriorityOne;
    case 2:
      return tdPriorityTwo;
    case 3:
      return tdPriorityThree;
    default:
      return tdLGrey;
  }
}
