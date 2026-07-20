import 'package:packages_application/core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nested/nested.dart';

class LoaderOverlay extends SingleChildStatelessWidget {
  const LoaderOverlay({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Stack(
      children: [
        child ?? const SizedBox.shrink(),
        Consumer(
          builder: (context, ref, child) {
            final loadingCount = ref.watch(appLoadingProvider);
            if (loadingCount <= 0) {
              return const SizedBox.shrink();
            }

            return const ColoredBox(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          },
        ),
      ],
    );
  }
}
