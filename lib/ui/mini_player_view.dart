import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/audio_helper/page_manager.dart';
import 'package:music_player/audio_helper/service_locator.dart';
import 'package:music_player/constants/color.dart';
import 'package:music_player/control_buttons.dart';
import 'package:music_player/ui/player_screen.dart';

class MiniPlayerView extends StatefulWidget {
  static const MiniPlayerView _instance = MiniPlayerView._internal();

  factory MiniPlayerView() {
    return _instance;
  }

  const MiniPlayerView._internal();

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return ValueListenableBuilder<AudioProcessingState>(
      valueListenable: pageManager.playbackStatNotifier,
      builder: (BuildContext context, AudioProcessingState processingState,
          Widget? child) {
        if (processingState == AudioProcessingState.idle) {
          return const SizedBox();
        }

        return ValueListenableBuilder<MediaItem?>(
          valueListenable: pageManager.currentSongNotifier,
          builder: (BuildContext context, mediaItem, child) {
            if (mediaItem == null) {
              return const SizedBox();
            }

            return Dismissible(
              key: const Key('mini_player'),
              direction: DismissDirection.down,
              onDismissed: (DismissDirection direction) {
                Feedback.forLongPress(context);
                pageManager.stop();
              },
              child: Dismissible(
                key: Key(mediaItem.id),
                confirmDismiss: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                    pageManager.previous();
                  } else {
                    pageManager.next();
                  }

                  return Future.value(false);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 2.0,
                  ),
                  elevation: 0.0,
                  color: MainColor.bottomNavigationColor,
                  child: SizedBox(
                    height: 60.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ValueListenableBuilder<ProgressBarState>(
                          valueListenable: pageManager.progressNotifier,
                          builder: (context, value, child) {
                            final position = value.current;
                            final totalDuration = value.total;

                            return position == null
                                ? const SizedBox()
                                : (position.inSeconds.toDouble() < 0.0 ||
                                        (position.inSeconds.toDouble() >
                                            totalDuration.inSeconds.toDouble()))
                                    ? const SizedBox()
                                    : SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: MainColor.mainColor,
                                          inactiveTrackColor:
                                              MainColor.greyColor,
                                          trackHeight: 0.5,
                                          thumbColor: MainColor.mainColor,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                            enabledThumbRadius: 2.5,
                                          ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                            overlayRadius: 1.0,
                                          ),
                                        ),
                                        child: Slider(
                                          inactiveColor: Colors.transparent,
                                          value: position.inSeconds.toDouble(),
                                          max: totalDuration.inSeconds
                                              .toDouble(),
                                          onChanged: (newPosition) {
                                            pageManager.seek(
                                              Duration(
                                                seconds: newPosition.round(),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const PlayerScreen();
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 1.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                const ControlButtons(
                                  miniPlayer: true,
                                  buttons: ['Play/Pause', 'Next'],
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 150.0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        mediaItem.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(
                                          color: MainColor.whiteColor,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        mediaItem.artist ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(
                                          color: MainColor.greyColor,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Hero(
                                  tag: 'currentArtWork',
                                  child: Card(
                                    elevation: 0.0,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: SizedBox.square(
                                      dimension: 40.0,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        child: CachedNetworkImage(
                                          width: 40.0,
                                          height: 40.0,
                                          imageUrl: mediaItem.artUri.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              'assets/images/cover.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          placeholder: (context, url) {
                                            return Image.asset(
                                              'assets/images/cover.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
