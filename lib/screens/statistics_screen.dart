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

import 'package:attendance/constants.dart';
import 'package:attendance/screens/add_user_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
              );
            },
            child: const Text(Constants.addNewMemberHeading,
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
      )
    );
  }
}
