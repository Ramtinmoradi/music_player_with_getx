import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/audio_helper/page_manager.dart';
import 'package:music_player/audio_helper/service_locator.dart';
import 'package:music_player/constants/color.dart';

class ControlButtons extends StatelessWidget {
  final bool shuffle;
  final bool miniPlayer;
  final List buttons;
  const ControlButtons({
    super.key,
    this.shuffle = false,
    this.miniPlayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
  });

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((e) {
        switch (e) {
          case 'Previous':
            return ValueListenableBuilder(
              valueListenable: pageManager.isFirstSongNotifier,
              builder: (BuildContext context, bool isFirst, Widget? child) {
                return IconButton(
                  onPressed: isFirst ? null : pageManager.previous,
                  icon: SvgPicture.asset(
                    'assets/svg/player_previous.svg',
                    width: 20.0,
                    height: 20.0,
                  ),
                );
              },
            );
          case 'Play/Pause':
            return SizedBox(
              height: miniPlayer ? 40.0 : 74.0,
              width: miniPlayer ? 40.0 : 74.0,
              child: ValueListenableBuilder<ButtonState>(
                valueListenable: pageManager.playButtonNotifier,
                builder: (context, value, __) {
                  return Stack(
                    children: [
                      if (value == ButtonState.loading)
                        Center(
                          child: SizedBox(
                            height: miniPlayer ? 35.0 : 60.0,
                            width: miniPlayer ? 35.0 : 60.0,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                MainColor.mainColor,
                              ),
                            ),
                          ),
                        ),
                      if (miniPlayer)
                        value == ButtonState.playing
                            ? Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MainColor.mainColor,
                                ),
                                child: IconButton(
                                  onPressed: pageManager.pause,
                                  icon: SvgPicture.asset(
                                    'assets/svg/mini_player_pause.svg',
                                  ),
                                ),
                              )
                            : Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MainColor.mainColor,
                                ),
                                child: IconButton(
                                  onPressed: pageManager.play,
                                  icon: SvgPicture.asset(
                                    'assets/svg/player_play.svg',
                                  ),
                                ),
                              ),
                    ],
                  );
                },
              ),
            );
          case 'Next':
            return ValueListenableBuilder(
              valueListenable: pageManager.isLastSongNotifier,
              builder: (BuildContext context, bool isLast, Widget? child) {
                return IconButton(
                  onPressed: isLast ? null : pageManager.next,
                  icon: SvgPicture.asset(
                    'assets/svg/player_next.svg',
                    width: 20.0,
                    height: 20.0,
                  ),
                );
              },
            );

          default:
            return Container();
        }
      }).toList(),
    );
  }
}
