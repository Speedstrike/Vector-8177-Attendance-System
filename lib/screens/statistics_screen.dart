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
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:attendance/student.dart';
import 'package:attendance/constants.dart';
import 'package:attendance/screens/add_user_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _students = fetchStudents();
  }

  Future<List<Student>> fetchStudents() async {
    final snapshot = await Constants.database.get();
    return snapshot.docs.map((doc) => Student.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkA,
      appBar: AppBar(
        title: const Text(
          Constants.mainTitle,
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: Constants.appBarFontSize
          ),
          textAlign: TextAlign.left
        ),
        leadingWidth: 0,
        backgroundColor: AppTheme.darkB,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: AppTheme.darkA.withOpacity(0.5),
                builder: (context) => const AddStudentScreen()
              ).then((_) {
                  setState(() {
                    _students = fetchStudents(); 
                  });
                }
              );
            },
            child: const Text(
              Constants.addNewMemberHeading,
              style: TextStyle(
                color: AppTheme.secondary,
                fontSize: Constants.regularFontSize
              )
            )
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              Constants.homeSwitch,
              style: TextStyle(
                color: AppTheme.secondary,
                fontSize: Constants.regularFontSize
              )
            )
          )
        ]
      ),
      body: FutureBuilder<List<Student>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!;

          students.sort((a, b) {
            final aStats = a.calculateAttendanceStats();
            final bStats = b.calculateAttendanceStats();

            final aTotalHours = aStats['totalHours'];
            final bTotalHours = bStats['totalHours'];

            return bTotalHours.compareTo(aTotalHours);
          });

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      Constants.studentStatisticsHeading,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: Constants.headingFontSize
                      ),
                      textAlign: TextAlign.center
                    ),
                    
                    const SizedBox(height: 20),
                    DataTable(
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: Constants.dataTableColumnWidthA, 
                            child: Center(
                              child: Text(
                                Constants.dataTableHeaders.elementAt(0),
                                style: const TextStyle(color: AppTheme.primary)
                              )
                            )
                          )
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Constants.dataTableColumnWidthB, 
                            child: Center(
                              child: Text(
                                Constants.dataTableHeaders.elementAt(1),
                                style: const TextStyle(color: AppTheme.primary)
                              )
                            )
                          )
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Constants.dataTableColumnWidthB,
                            child: Center(
                              child: Text(
                                Constants.dataTableHeaders.elementAt(2),
                                style: const TextStyle(color: AppTheme.primary)
                              )
                            )
                          )
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Constants.dataTableColumnWidthB,
                            child: Center(
                              child: Text(
                                Constants.dataTableHeaders.elementAt(3),
                                style: const TextStyle(color: AppTheme.primary)
                              )
                            )
                          )
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Constants.dataTableColumnWidthB,
                            child: Center(
                              child: Text(
                                Constants.dataTableHeaders.elementAt(4),
                                style: const TextStyle(color: AppTheme.primary)
                              )
                            )
                          )
                        )
                      ],
                      rows: students.map<DataRow>((student) {
                        final attendanceStats = student.calculateAttendanceStats();

                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: Constants.dataTableColumnWidthA,
                                child: Center(
                                  child: Text(
                                    student.name,
                                    style: const TextStyle(color: AppTheme.light)
                                  )
                                )
                              )
                            ),
                            DataCell(
                              SizedBox(
                                width: Constants.dataTableColumnWidthB, 
                                child: Center(
                                  child: Text(
                                    attendanceStats['totalHours'].toString(),
                                    style: const TextStyle(color: AppTheme.light)
                                  )
                                )
                              )
                            ),
                            DataCell(
                              SizedBox(
                                width: Constants.dataTableColumnWidthB,
                                child: Center(
                                  child: Text(
                                    attendanceStats['numberOfMeetings'].toString(),
                                    style: const TextStyle(color: AppTheme.light)
                                  )
                                )
                              )
                            ),
                            DataCell(
                              SizedBox(
                                width: Constants.dataTableColumnWidthB, 
                                child: Center(
                                  child: Text(
                                    attendanceStats['medianHours'].toStringAsFixed(2),
                                    style: const TextStyle(color: AppTheme.light)
                                  )
                                )
                              )
                            ),
                            DataCell(
                              SizedBox(
                                width: Constants.dataTableColumnWidthB, 
                                child: Center(
                                  child: Text(
                                    attendanceStats['lastMeetingDate'] == null? '-' : DateFormat('MM-dd-yyyy').format(attendanceStats['lastMeetingDate']),
                                    style: const TextStyle(color: AppTheme.light)
                                  )
                                )
                              )
                            )
                          ]
                        );
                      }).toList(),

                    )
                  ]
                )
              )
            )
          );
        }
      )
    );
  }
}

