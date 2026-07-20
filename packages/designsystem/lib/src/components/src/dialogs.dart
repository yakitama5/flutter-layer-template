import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

/// OKボタンを押すでしか閉じることが出来ないダイアログ
///
/// [popOnOk] が true (デフォルト) の場合、OKボタン押下時にダイアログを閉じた上で
/// [onOk] を呼び出す。
/// [popOnOk] が false の場合、ダイアログは閉じずに [onOk] のみを呼び出す。
/// 強制アップデートのように、処理が完了するまでダイアログを閉じさせたくない場合に使う。
Future<void> showOkBarrierDismissibleDialog(
  BuildContext context, {
  Widget? icon,
  String? title,
  String? message,
  String? okLabel,
  bool popOnOk = true,
  required VoidCallback onOk,
}) => showAdaptiveDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => _OkDialog(
    icon: icon,
    title: title,
    message: message,
    okLabel: okLabel,
    popOnOk: popOnOk,
    onOk: onOk,
  ),
);

/// 「OK」をアクションに持つダイアログ
class _OkDialog extends StatelessWidget {
  const _OkDialog({
    this.title,
    this.message,
    this.okLabel,
    this.icon,
    required this.popOnOk,
    required this.onOk,
  });

  final Widget? icon;
  final String? title;
  final String? message;
  final String? okLabel;
  final bool popOnOk;
  final VoidCallback onOk;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      icon: icon,
      title: Text(title ?? ''),
      content: Text(message ?? ''),
      actions: [
        _AdaptiveAction(
          // TODO(yakitama5): 多言語化対応
          child: Text(okLabel ?? 'OK'),
          onPressed: () {
            if (popOnOk) {
              Navigator.pop(context);
            }
            onOk();
          },
        ),
      ],
    );
  }
}

/// アダプティブダイアログで利用するアクション
/// プラットフォームに応じたアダプティブレイアウトを提供
class _AdaptiveAction extends SingleChildStatelessWidget {
  const _AdaptiveAction({required super.child, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      switch (Theme.of(context).platform) {
        TargetPlatform.android ||
        TargetPlatform.fuchsia ||
        TargetPlatform.linux ||
        TargetPlatform.windows => TextButton(
          onPressed: onPressed,
          child: child ?? const SizedBox.shrink(),
        ),
        TargetPlatform.iOS || TargetPlatform.macOS => CupertinoDialogAction(
          onPressed: onPressed,
          child: child ?? const SizedBox.shrink(),
        ),
      };
}
