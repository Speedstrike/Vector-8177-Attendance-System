// MIT License
// 
// Copyright (c) 2024 Aaryan Karlapalem
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Constants {
  static CollectionReference database = FirebaseFirestore.instance.collection('students');

  static const double appBarFontSize = 25;
  static const double headingFontSize = 20;
  static const double regularFontSize = 15;

  static const String mainTitle = 'Vector 8177 Attendance System';
  static const String viewTitle = 'View attendance data';

  static const String statisticsSwitch = 'View attendance statistics';
  static const String homeSwitch = 'Record attendance';

  static const String attendanceHeading = 'Attendance for ';
  static const List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  static const String checkInButton = 'Check in';
  static const String checkOutButton = 'Check out';

  static const String addNewMemberHeading = 'Add new student';
  static const String addNewMemberNameField = 'Name';
  static const String addNewMemberIDField = 'ID number';
  static const String addNewMemberGradeField = 'Grade level';
  static const String addNewMemberAddButton = 'Add student';
  static const List<ButtonSegment<int>> gradeOptions = [
    ButtonSegment(
      value: 9,
      label: Text('9th grade',)
    ),
    ButtonSegment(
      value: 10,
      label: Text('10th grade')
    ),
    ButtonSegment(
      value: 11,
      label: Text('11th grade')
    ),
    ButtonSegment(
      value: 12,
      label: Text('12th grade')
    ),
  ];
}

class AppTheme {
  static const Color darkA = Color(0xFF282828);
  static const Color darkB = Color(0xFF1E1E1E);
  static const Color light = Color(0xFFF1F1F1);
  static const Color primary = Color(0xFFF19941);
  static const Color secondary = Color(0xFFFFD55E);

  static const Color successGreen = Color(0xFF52d352);
  static const Color errorRed = Color(0xFFFF3126);
}
