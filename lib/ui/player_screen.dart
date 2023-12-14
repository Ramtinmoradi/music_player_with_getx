import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/audio_helper/page_manager.dart';
import 'package:music_player/audio_helper/service_locator.dart';
import 'package:music_player/ui/playlist_song_container.dart';

import '../constants/color.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return Dismissible(
      key: const Key('PlayerScreen'),
      background: const ColoredBox(color: Colors.transparent),
      direction: DismissDirection.down,
      onDismissed: (DismissDirection direction) {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: MainColor.backgroundColor,
        body: SafeArea(
          child: ValueListenableBuilder<MediaItem?>(
            valueListenable: pageManager.currentSongNotifier,
            builder: (BuildContext context, MediaItem? mediaItem, __) {
              if (mediaItem == null) return const SizedBox();

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      width: MediaQuery.sizeOf(context).width,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        clipBehavior: Clip.antiAlias,
                        children: <Widget>[
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.12,
                            child: SvgPicture.asset(
                              'assets/svg/one_shape_player.svg',
                              height: MediaQuery.sizeOf(context).height * 0.3,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.12,
                            left: MediaQuery.sizeOf(context).width * 0.20,
                            child: SvgPicture.asset(
                              'assets/svg/two_shape_player.svg',
                              height: MediaQuery.sizeOf(context).height * 0.29,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.12,
                            left: MediaQuery.sizeOf(context).width * 0.18,
                            child: SvgPicture.asset(
                              'assets/svg/big_border_player.svg',
                              height: MediaQuery.sizeOf(context).height * 0.33,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.13,
                            left: MediaQuery.sizeOf(context).width * 0.2,
                            child: SvgPicture.asset(
                              'assets/svg/small_border_player.svg',
                              height: MediaQuery.sizeOf(context).height * 0.31,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.15,
                            left: MediaQuery.sizeOf(context).width * 0.24,
                            child: Hero(
                              tag: 'currentArtWork',
                              child: ValueListenableBuilder(
                                valueListenable:
                                    pageManager.currentSongNotifier,
                                builder: (context, value, child) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(75.0),
                                      bottomLeft: Radius.circular(75.0),
                                      topRight: Radius.circular(150.0),
                                      bottomRight: Radius.circular(150.0),
                                    ),
                                    child: CachedNetworkImage(
                                      width: 220.0,
                                      height: 220.0,
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
                                  );
                                },
                              ),

                              // ClipPath(
                              //   clipper: ClipTriangle(),
                              //   child: Container(
                              //     height: 240.0,
                              //     width: 240.0,
                              //     color: MainColor.whiteColor,
                              //   ),
                              // ),
                            ),
                          ),
                          Positioned(
                            top: 60.0,
                            child: Image.asset(
                              'assets/images/stage.png',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          Positioned(
                            top: 15.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                'assets/svg/player_arrow_down.svg',
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  mediaItem.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.rubik(
                                    fontSize: 18,
                                    color: MainColor.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 7.0),
                                Text(
                                  mediaItem.artist ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: MainColor.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: pageManager.progressNotifier,
                            builder: (context, valueState, child) {
                              double? dragValue;
                              bool dragging = false;

                              final value = min(
                                valueState.current.inMilliseconds.toDouble(),
                                valueState.total.inMilliseconds.toDouble(),
                              );

                              if (dragValue != null && dragging) {
                                dragValue = null;
                              }
                              return Positioned(
                                top: MediaQuery.sizeOf(context).height * 0.57,
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: MainColor.mainColor,
                                      inactiveTrackColor: MainColor.greyColor,
                                      trackHeight: 2.5,
                                      thumbColor: MainColor.mainColor,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 5.0,
                                        disabledThumbRadius: 2.5,
                                      ),
                                    ),
                                    child: Slider(
                                      value: value,
                                      min: 0.0,
                                      max: valueState.total.inMilliseconds
                                          .toDouble(),
                                      label:
                                          '${valueState.current.inMilliseconds.toDouble()}',
                                      onChanged: (double newValue) {
                                        setState(() {
                                          dragValue = value;
                                        });

                                        if (!dragging) {
                                          dragging = true;
                                        }

                                        pageManager.seek(
                                          Duration(
                                            milliseconds: value.round(),
                                          ),
                                        );
                                      },
                                      onChangeStart: (double startValue) {},
                                      onChangeEnd: (double endValue) {
                                        pageManager.seek(
                                          Duration(
                                            milliseconds: endValue.round(),
                                          ),
                                        );
                                        dragging = false;
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: pageManager.progressNotifier,
                            builder: (context, valueState, child) {
                              return Positioned(
                                top: MediaQuery.sizeOf(context).height * 0.61,
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Text>[
                                        Text(
                                          RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                                  .firstMatch(
                                                      '${valueState.current}')
                                                  ?.group(1) ??
                                              '${valueState.current}',
                                          style: GoogleFonts.rubik(
                                            color: MainColor.whiteColor,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(
                                          RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                                  .firstMatch(
                                                      '${valueState.total}')
                                                  ?.group(1) ??
                                              '${valueState.total}',
                                          style: GoogleFonts.rubik(
                                            color: MainColor.whiteColor,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: MediaQuery.sizeOf(context).height * 0.65,
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/svg/player_like.svg',
                                        width: 30.0,
                                        theme: const SvgTheme(
                                          currentColor: MainColor.greyColor,
                                        ),
                                      ),
                                    ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable:
                                          pageManager.isFirstSongNotifier,
                                      builder: (context, isFirst, child) {
                                        return IconButton(
                                          onPressed: (isFirst)
                                              ? null
                                              : pageManager.previous,
                                          icon: SvgPicture.asset(
                                            'assets/svg/player_previous.svg',
                                            width: 30.0,
                                            theme: SvgTheme(
                                              currentColor: (isFirst)
                                                  ? MainColor.greyColor
                                                  : MainColor.whiteColor,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ValueListenableBuilder<ButtonState>(
                                      valueListenable:
                                          pageManager.playButtonNotifier,
                                      builder: (context, value, child) {
                                        return SizedBox(
                                          height: 75.0,
                                          width: 75.0,
                                          child: Stack(
                                            children: [
                                              if (value == ButtonState.loading)
                                                const Center(
                                                  child: SizedBox(
                                                    height: 70.0,
                                                    width: 70.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        MainColor.mainColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              Container(
                                                width: 75.0,
                                                height: 75.0,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: MainColor.mainColor,
                                                ),
                                                child: value ==
                                                        ButtonState.playing
                                                    ? GestureDetector(
                                                        onTap:
                                                            pageManager.pause,
                                                        child: Center(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/player_pause.svg',
                                                            width: 40.0,
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: pageManager.play,
                                                        child: Center(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/player_play.svg',
                                                            width: 40.0,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable:
                                          pageManager.isLastSongNotifier,
                                      builder: (context, isLast, child) {
                                        return IconButton(
                                          onPressed: (isLast)
                                              ? null
                                              : pageManager.next,
                                          icon: SvgPicture.asset(
                                            'assets/svg/player_next.svg',
                                            width: 30.0,
                                            theme: SvgTheme(
                                              currentColor: (isLast)
                                                  ? MainColor.greyColor
                                                  : MainColor.whiteColor,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/svg/player_shuffle.svg',
                                        width: 30.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: pageManager.playlistNotifier,
                      builder: (context, queue, child) {
                        final int queueStateIndex =
                            pageManager.currentSongNotifier.value == null
                                ? 0
                                : queue.indexOf(
                                    pageManager.currentSongNotifier.value!);

                        final num queuePosition =
                            queue.length - queueStateIndex;

                        return Container(
                          height: queue.length * 90.0,
                          width: MediaQuery.sizeOf(context).width,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: MainColor.songsContainerBackgroundColor
                                .withOpacity(0.4),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Divider(
                                height: 2.0,
                                thickness: 1.0,
                                indent: MediaQuery.sizeOf(context).width * 0.35,
                                endIndent:
                                    MediaQuery.sizeOf(context).width * 0.35,
                                color: MainColor.greyColor,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ReorderableListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: queue.length,
                                  onReorder: (oldIndex, newIndex) {
                                    if (oldIndex < newIndex) {
                                      newIndex--;
                                    }
                                    pageManager.moveMediaItem(
                                        oldIndex, newIndex);
                                  },
                                  itemBuilder: (context, index) {
                                    var sObj = queue[index];

                                    return Dismissible(
                                      key: ValueKey(sObj.id),
                                      direction: index == queue
                                          ? DismissDirection.none
                                          : DismissDirection.horizontal,
                                      onDismissed:
                                          (DismissDirection direction) {
                                        pageManager.removeQueueItemAt(index);
                                      },
                                      child: PlayListSongsContainer(
                                        key: ValueKey(sObj.id),
                                        index: index + 1,
                                        sObj: sObj,
                                        onPressed: () {
                                          pageManager.skipToQueueItem(index);
                                          if (pageManager
                                                  .playButtonNotifier.value ==
                                              ButtonState.paused) {
                                            pageManager.play();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ClipTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    Path path = Path();

    //center top point
    path.lineTo(width * 0.5, 0);

    //bottom right point
    path.lineTo(width, height);

    //bottom left point
    path.lineTo(0, height);

    //close to center top point
    path.lineTo(width * 0.5, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
