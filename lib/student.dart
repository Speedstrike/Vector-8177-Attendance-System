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

import 'package:intl/intl.dart';

class Student {
  final String name;
  final int? grade;
  final Map<String, int> attendance;

  Student({
    required this.name,
    required this.grade,
    required this.attendance,
  });

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Map<String, int> attendanceData = {};
    if (data['attendance'] != null) {
      attendanceData = Map<String, int>.from(data['attendance'] as Map);
    }

    return Student(
      name: data['name'] ?? '',
      grade: data['grade'] ?? 0,
      attendance: attendanceData,
    );
  }

  Map<String, dynamic> calculateAttendanceStats() {
    if (attendance.isEmpty) {
      return {
        'totalHours': 0,
        'numberOfMeetings': 0,
        'medianHours': 0,
        'lastMeetingDate': null,
      };
    }

    final List<int> hoursList = attendance.values.toList();
    final List<DateTime> datesList = attendance.keys.map((dateString) => DateFormat('MM-dd-yyyy').parse(dateString)).toList();

    final totalHours = hoursList.reduce((a, b) => a + b);
    final numberOfMeetings = hoursList.length;

    hoursList.sort();
    double medianHours = 0;
    if (hoursList.isNotEmpty) {
      int middle = hoursList.length ~/ 2;
      if (hoursList.length % 2 == 0) {
        medianHours = (hoursList[middle - 1] + hoursList[middle]) / 2;
      } 
      else {
        medianHours = hoursList[middle] + 0.0;
      }
    }

    final lastMeetingDate = datesList.isNotEmpty? datesList.last : null;

    return {
      'totalHours': totalHours,
      'numberOfMeetings': numberOfMeetings,
      'medianHours': medianHours,
      'lastMeetingDate': lastMeetingDate,
    };
  }
}
