import 'package:abdelkader_user/constants/color.dart';
import 'package:flutter/material.dart';

InputDecoration textinputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(4.0),
  fillColor: Colors.white,
  filled: true,
  hintStyle: TextStyle(
    color: Colors.grey,
  ),

  prefixIcon: Icon(
    Icons.attach_money,
    color: primaryColor,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: primaryColor,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: primaryColor,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);
