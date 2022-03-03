import 'dart:math';

import 'package:audio_wave_task/src/core/constants/constants.dart';
import 'package:riverpod/riverpod.dart';

class AudioDataNotifier extends StateNotifier<List<double>> {
  AudioDataNotifier() : super([]);

  ///
  void initialize() {
    var rng = Random();
    List<double> mTempList = [];
    for (var i = 0; i < kTotalAudioWaveData; i++) {
      mTempList.add(rng.nextInt(kMaxAudioWaveBarHeight).toDouble() + 1);
    }
    state = mTempList;
  }
}

final audioDataProvider =
    StateNotifierProvider<AudioDataNotifier, List<double>>((ref) {
  return AudioDataNotifier();
});
