import 'package:flutter/foundation.dart';

import 'use_effect_once.dart';

// StatefulWidgetの`dispose`のように利用
void useDispose(VoidCallback dispose) => useEffectOnce(() => dispose);
