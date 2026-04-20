import 'package:flutter_riverpod/flutter_riverpod.dart';

// The actual state notifier
class MainIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final mainIndexProvider = NotifierProvider<MainIndexNotifier, int>(() {
  return MainIndexNotifier();
});
