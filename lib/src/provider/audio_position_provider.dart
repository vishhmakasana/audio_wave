import 'package:riverpod/riverpod.dart';

/// this represents the current audio position
final audioPositionProvider = StateProvider<int>((ref) {
  return 0;
});
