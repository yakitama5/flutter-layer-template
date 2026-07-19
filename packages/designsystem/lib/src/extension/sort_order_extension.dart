import 'package:designsystem/i18n/strings.g.dart';
import 'package:domain/core.dart';
import 'package:flutter/material.dart';

extension SortOrderX on SortOrder {
  String get title => i18n.designsystem.sortOrder(context: this);
  IconData get iconData => switch (this) {
    SortOrder.asc => Icons.arrow_downward_rounded,
    SortOrder.desc => Icons.arrow_upward_rounded,
  };
}
