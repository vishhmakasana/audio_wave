import 'package:audio_wave_task/src/core/constants/constants.dart';
import 'package:audio_wave_task/src/provider/audio_data_provider.dart';
import 'package:audio_wave_task/src/provider/audio_position_provider.dart';
import 'package:audio_wave_task/src/provider/audio_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'wave_bar.dart';

class AudioWaveWidget extends ConsumerWidget {
  AudioWaveWidget({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int audioPosition = ref.watch(audioPositionProvider);
    List<double> audioData = ref.watch(audioDataProvider);

    ref.listen(audioStateProvider, (previous, next) {
      bool audioState = next as bool;
      if (audioState) {
        changeAudioPosition(ref);
      }
    });

    ref.listen(audioPositionProvider, (previous, next) {
      int audioPosition = next as int;
      _scrollToIndex(audioPosition);
      changeAudioPosition(ref);
    });

    return IgnorePointer(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (_, index) {
          return WaveBar(
            barHeight: audioData[index],
            barColor:
                index < audioPosition ? kActiveBarColor : kInActiveBarColor,
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: audioData.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: kWaveBarGap,
          );
        },
      ),
    );
  }

  ///  We are mocking the audio state change here,
  ///  in real scenario this can be done by listening to audio player state change
  void changeAudioPosition(WidgetRef ref) {
    bool audioState = ref.watch(audioStateProvider);
    int audioPosition = ref.watch(audioPositionProvider);
    if (audioState && audioPosition < kTotalAudioWaveData) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.read(audioPositionProvider.notifier).update((state) => state + 1);
      });
    } else if (audioPosition == kTotalAudioWaveData) {
      ref.read(audioStateProvider.notifier).update((state) => !state);
      ref.read(audioPositionProvider.notifier).update((state) => 0);
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  ///  this function will scroll to the very right/end edge of the list view
  void _scrollToIndex(index) {
    if (_scrollController.hasClients) {
      var jumpValue = (kWaveBarWidth * index) + (kWaveBarGap * (index - 1));
      if (jumpValue > _scrollController.position.viewportDimension) {
        // _scrollController.jumpTo(jumpValue + _scrollController.position.viewportDimension);
        _scrollController.animateTo(
            jumpValue - _scrollController.position.viewportDimension,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn);
      }
    }
  }
}
