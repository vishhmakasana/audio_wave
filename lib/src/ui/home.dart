import 'dart:async';
import 'package:audio_wave_task/src/core/constants/constants.dart';
import 'package:audio_wave_task/src/core/extension/mediaquery_context.dart';
import 'package:audio_wave_task/src/provider/audio_data_provider.dart';
import 'package:audio_wave_task/src/provider/audio_state_provider.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/audio_wave_widget.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool audioState = ref.watch(audioStateProvider);
    List<double> audioData = ref.watch(audioDataProvider);

    double avatarSize = context.height / 12 > kMinAvatarHeight
        ? context.height / 12
        : kMinAvatarHeight;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          audioData.isNotEmpty
              ? Stack(
                  children: [
                    buildBubble(context, audioState, ref, avatarSize),
                    buildAvatar(avatarSize),
                  ],
                )
              : buildLoadAudioDataButton(ref)
        ],
      ),
    );
  }

  Positioned buildAvatar(double avatarSize) {
    return Positioned(
        bottom: 0,
        right: 16,
        child: Container(
          height: avatarSize,
          width: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kBackgroundColor, width: 5),
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://i.imgur.com/hVuFcaF.jpeg")),
          ),
        ));
  }

  Widget buildLoadAudioDataButton(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        color: Colors.blue,
        onPressed: () {
          ref.read(audioDataProvider.notifier).initialize();
        },
        child: const Text(
          "Load Audio Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Bubble buildBubble(
      BuildContext context, bool audioState, WidgetRef ref, double avatarSize) {
    double bubbleHeight = context.height / 8 > kMinBubbleHeight
        ? context.height / 8
        : kMinBubbleHeight;

    return Bubble(
      margin: BubbleEdges.only(right: avatarSize, bottom: 8),
      nip: BubbleNip.rightBottom,
      radius: const Radius.circular(24),
      color: kBackgroundColor,
      nipHeight: 30,
      nipWidth: 20,
      child: SizedBox(
        height: bubbleHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 8.0),
              child: Text(
                "What does sport mean to you?",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildAudioStateButton(audioState, ref),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AudioWaveWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell buildAudioStateButton(bool audioState, WidgetRef ref) {
    return InkWell(
      child: !audioState
          ? const Icon(
              Icons.play_arrow,
              color: Colors.white,
            )
          : const Icon(
              Icons.pause,
              color: Colors.white,
            ),
      onTap: () {
        ref.read(audioStateProvider.notifier).update((state) => !state);
      },
    );
  }
}
