import 'package:flutter/material.dart';
import 'package:flutter_app/i18n/strings.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(i18n.app.homePage.title)),
      body: const Center(child: Text('Hello Home!')),
    );
  }
}
