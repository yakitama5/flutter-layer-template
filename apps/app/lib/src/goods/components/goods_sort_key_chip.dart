import 'package:designsystem/extension.dart';
import 'package:designsystem/widgets.dart';
import 'package:domain/core.dart';
import 'package:domain/goods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';

/// 並び替えを行うための`ActionChip`
class GoodsSortKeyChip extends StatelessWidget {
  const GoodsSortKeyChip({
    super.key,
    required this.onChanged,
    required this.sortKey,
    required this.sortOrder,
  });

  final ValueChanged<GoodsSortKey> onChanged;
  final GoodsSortKey sortKey;
  final SortOrder sortOrder;

  @override
  Widget build(BuildContext context) {
    return BottomSheetSelectActionChip<GoodsSortKey>(
      label: Text(i18n.goods.goodsSortKey(context: sortKey)),
      actions: GoodsSortKey.values
          .map(
            (e) => BottomSheetAction(
              title: Text(i18n.goods.goodsSortKey(context: e)),
              icon: sortKey == e ? Icon(sortOrder.iconData) : null,
              value: e,
            ),
          )
          .toList(),
      iconData: Icons.sort,
      title: Text(i18n.goods.goodsSortKey(context: sortKey)),
      initial: sortKey,
      onChanged: onChanged,
    );
  }
}
