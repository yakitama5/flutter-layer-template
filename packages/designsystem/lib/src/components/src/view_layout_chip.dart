import 'package:designsystem/i18n/strings.g.dart';
import 'package:designsystem/src/components/src/bottom_sheet_action_chip.dart';
import 'package:designsystem/src/components/src/model/bottom_sheet_action.dart';
import 'package:designsystem/src/extension/view_layout_extension.dart';
import 'package:domain/designsystem.dart';
import 'package:flutter/material.dart';

class ViewLayoutChip extends StatelessWidget {
  const ViewLayoutChip({
    super.key,
    required this.viewLayout,
    required this.onChanged,
  });

  final ViewLayout viewLayout;
  final ValueChanged<ViewLayout> onChanged;

  @override
  Widget build(BuildContext context) {
    return BottomSheetSelectActionChip<ViewLayout>(
      label: Text(i18n.designsystem.viewLayout.typeName(context: viewLayout)),
      actions: ViewLayout.values
          .map(
            (e) => BottomSheetAction(
              title: Text(i18n.designsystem.viewLayout.typeName(context: e)),
              icon: Icon(e.iconData),
              value: e,
            ),
          )
          .toList(),
      iconData: viewLayout.iconData,
      title: Text(i18n.designsystem.viewLayout.name),
      initial: viewLayout,
      onChanged: onChanged,
    );
  }
}
