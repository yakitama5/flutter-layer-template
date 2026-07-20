import 'package:domain/designsystem.dart';
import 'package:flutter/material.dart';

extension ViewLayoutX on ViewLayout {
  IconData get iconData => switch (this) {
    ViewLayout.grid => Icons.grid_3x3_rounded,
    ViewLayout.list => Icons.list_rounded,
  };
}
