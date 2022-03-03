import 'dart:async';
import 'package:audio_wave_task/src/core/constants/constants.dart';
import 'package:audio_wave_task/src/provider/audio_data_provider.dart';
import 'package:audio_wave_task/src/provider/audio_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/wave_bar.dart';

class Home extends ConsumerWidget {
  Home({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int audioState = ref.watch(audioStateProvider);
    List<double> audioData = ref.watch(audioDataProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          audioData.isNotEmpty
              ? Container(
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: IgnorePointer(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (_, index) {
                        return WaveBar(
                          barHeight: audioData[index],
                          barColor: index < audioState
                              ? kActiveBarColor
                              : kInActiveBarColor,
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
                  ),
                )
              : Column(
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        loadAudioData(ref);
                      },
                      child: const Text("Load Audio Data"),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  ///  We will use random audio wave data to generate playing wave animation
  void loadAudioData(WidgetRef ref) {
    ref.read(audioDataProvider.notifier).initialize();
    changeAudioState(ref);
  }

  ///  We are mocking the audio state change here,
  ///  in real scenario this can be done by listening to audio player state change
  void changeAudioState(WidgetRef ref) {
    int audioState = ref.watch(audioStateProvider);
    if (audioState < kTotalAudioWaveData) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.read(audioStateProvider.notifier).update((state) => state + 1);
        _scrollToIndex(audioState);
        changeAudioState(ref);
      });
    }
  }

  ///  this function will scroll to the very right edge of the list view
  void _scrollToIndex(index) {
    var jumpValue = (kWaveBarWidth * index) + (kWaveBarGap * (index - 1));
    debugPrint("_scrollToIndex : $index");
    debugPrint("jumpValue : $jumpValue");
    debugPrint("offset : ${_scrollController.offset}");
    debugPrint("position : ${_scrollController.position}");
    debugPrint(
        "viewportDimension : ${_scrollController.position.viewportDimension}");
    if (jumpValue > _scrollController.position.viewportDimension) {
      // _scrollController.jumpTo(jumpValue + _scrollController.position.viewportDimension);
      _scrollController.animateTo(
          jumpValue - _scrollController.position.viewportDimension,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn);
    }
  }
}
