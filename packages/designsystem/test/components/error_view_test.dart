@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:designsystem/widgets.dart';
import 'package:domain/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  goldenTest(
    'ErrorView',
    fileName: 'error_view',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'AppExceptionのメッセージを表示する',
          child: SizedBox(
            width: 400,
            height: 300,
            child: MaterialApp(
              home: ErrorView(const UnknownException(), StackTrace.current),
            ),
          ),
        ),
        GoldenTestScenario(
          name: '一般的なExceptionのtoString()を表示する',
          child: SizedBox(
            width: 400,
            height: 300,
            child: MaterialApp(
              home: ErrorView(
                Exception('Something went wrong'),
                StackTrace.current,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
