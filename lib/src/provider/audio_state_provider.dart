import 'package:audio_wave_task/src/core/constants/constants.dart';
import 'package:riverpod/riverpod.dart';

import 'audio_position_provider.dart';

/// this represents the Audio state is playing or not : play (true) / pause (false)
final audioStateProvider = StateProvider<bool>((ref) {
  return false;
});
