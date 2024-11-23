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

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:attendance/constants.dart';
import 'package:attendance/screens/statistics_screen.dart';
import 'package:attendance/student.dart';
import 'package:attendance/screens/add_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> users = [];
  Map<String, DateTime?> checkInTimes = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      QuerySnapshot snapshot = await Constants.database.get();

      setState(() {
        users = snapshot.docs.map((doc) {
          return Student.fromFirestore(doc);
        }).toList();
      });
    } 
    catch (_) {}
  }

  void _toggleCheckInOut(Student student) async {
    final currentTime = DateTime.now();

    if (checkInTimes.containsKey(student.name)) {
      DateTime checkInTime = checkInTimes[student.name]!;
      int duration = currentTime.difference(checkInTime).inMinutes;

      await Constants.database.doc(student.name).update({
        'attendance.${DateFormat('MM-dd-yyyy').format(DateTime.now())}': duration
      });

      setState(() {
        checkInTimes.remove(student.name);
      });
    } 
    else {
      setState(() {
        checkInTimes[student.name] = currentTime;
      });
    }
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
            fontSize: 25.0
          )
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
              ).then((newStudent) {
                if (newStudent != null) {
                  setState(() {
                    users.add(newStudent);
                  });
                }
              });
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
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen()));
            },
            child: const Text(
              Constants.statisticsSwitch,
              style: TextStyle(
                color: AppTheme.secondary,
                fontSize: 15.0
              )
            )
          )
        ]
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "${Constants.attendanceHeading}${Constants.months[DateTime.now().month - 1]} ${DateTime.now().day}, ${DateTime.now().year}",
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: Constants.headingFontSize
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: users.isEmpty? const Center(child: CircularProgressIndicator(color: AppTheme.primary)) : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (users.length / 4).ceil(),
              itemBuilder: (context, index) {
                int startIndex = index * 4;
                List<int> buttonIndexes = List.generate(4, (i) => startIndex + i < users.length? startIndex + i : -1);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: buttonIndexes.map((buttonIndex) {
                      if (buttonIndex == -1) {
                        return const SizedBox();
                      }
                      final user = users[buttonIndex];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: checkInTimes.containsKey(user.name)? AppTheme.successGreen: AppTheme.errorRed,
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        color: AppTheme.darkA,
                                        fontSize: Constants.regularFontSize,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    Text(
                                      'Grade: ${user.grade}',
                                      style: const TextStyle(
                                        color: AppTheme.darkA,
                                        fontSize: Constants.regularFontSize
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () => _toggleCheckInOut(user),
                                  child: Text(
                                    checkInTimes.containsKey(user.name)? Constants.checkOutButton : Constants.checkInButton,
                                    style: const TextStyle(
                                      color: AppTheme.darkA,
                                      fontSize: Constants.regularFontSize
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        )
                      );
                    }).toList()

                  )
                );
              }
            )
          )
        ]
      )
    );
  }
}
