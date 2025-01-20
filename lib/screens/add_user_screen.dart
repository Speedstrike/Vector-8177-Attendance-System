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

import 'package:attendance/student.dart';
import 'package:attendance/constants.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController nameFieldController = TextEditingController();
  int gradeDropdownValue = -1;

  void changeGradeSelection(int newGrade) {
    setState(() {
      gradeDropdownValue = newGrade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.darkB,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 7 / 24,
            width: MediaQuery.of(context).size.width * 5 / 12,
            decoration: BoxDecoration(
              color: AppTheme.darkB,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      Constants.addNewMemberHeading,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: Constants.headingFontSize
                      )
                    )
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Constants.studentFields.elementAt(0),
                          style: const TextStyle(
                            color: AppTheme.secondary,
                            fontSize: Constants.regularFontSize
                          )
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: nameFieldController,
                          maxLength: 20,
                          style: const TextStyle(color: AppTheme.light),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            counterText: ''
                          )
                        )
                      )
                    ]
                  ),
                  
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Constants.studentFields.elementAt(2),
                          style: const TextStyle(
                            color: AppTheme.secondary,
                            fontSize: Constants.regularFontSize
                          )
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: SegmentedButton<int>(
                          style: SegmentedButton.styleFrom(
                            foregroundColor: AppTheme.light,
                            selectedBackgroundColor: Colors.transparent,
                            selectedForegroundColor: AppTheme.successGreen,
                            animationDuration: const Duration(milliseconds: 100)
                          ),
                          segments: Constants.gradeOptions,
                          selected: {gradeDropdownValue},
                          onSelectionChanged: (Set<int> value) {
                            setState(() {
                              changeGradeSelection(value.first);
                            });
                          },
                          showSelectedIcon: false
                        )
                      )
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          if (nameFieldController.text.isNotEmpty && gradeDropdownValue != -1) {
                            final newStudent = Student(
                              name: nameFieldController.text,
                              grade: gradeDropdownValue,
                              attendance: {}
                            );

                            try {
                              Constants.database.doc(newStudent.name).set({
                                'name': newStudent.name,
                                'grade': newStudent.grade,
                                'attendance': {}
                              });

                              if (mounted) {
                                Navigator.of(context).pop(newStudent);
                              }
                            } 
                            catch (_) {}

                            nameFieldController.clear();
                            gradeDropdownValue = -1;
                          }
                        },
                        child: const Text(
                          Constants.addNewMemberAddButton,
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: Constants.regularFontSize
                          )
                        )
                      )
                    )
                  )
                ]
              )
            )
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: AppTheme.light,
                size: 30
              ),
              onPressed: () {
                Navigator.of(context).pop();
                nameFieldController.clear();
                gradeDropdownValue = -1;
              }
            )
          )
        ]
      )
    );
  }
}
