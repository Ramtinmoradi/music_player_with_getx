import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/audio_helper/player_invoke.dart';
import 'package:music_player/constants/color.dart';
import 'package:music_player/ui/mini_player_view.dart';
import 'package:music_player/ui/player_screen.dart';
import 'package:music_player/ui/song_container.dart';

import '../data/audio_data.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final allVM = Get.put(AllSongs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 10 * 80.0,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      8.0,
                      0.0,
                      8.0,
                      50.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allVM.allList.length,
                      itemBuilder: (context, index) {
                        var sObj = allVM.allList[index];

                        return SongsContainer(
                          index: index + 1,
                          isWeb: true,
                          sObj: sObj,
                          onPressed: () {},
                          onPressedPlay: () {
                            //Get.to(() => const PlayerScreen());
                            playerPlayProcessDebounce(
                                allVM.allList
                                    .map(
                                      (sObj) => {
                                        'id': sObj["id"].toString(),
                                        'title': sObj["name"].toString(),
                                        'artist': sObj["artists"].toString(),
                                        'album': sObj["album"].toString(),
                                        'genre': sObj["language"].toString(),
                                        'image': sObj["image"].toString(),
                                        'url': sObj["downloadUrl"].toString(),
                                        'user_id': sObj["artistsId"].toString(),
                                        'user_name': sObj["artists"].toString(),
                                      },
                                    )
                                    .toList(),
                                index);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MiniPlayerView(),
                  Card(
                    color: MainColor.bottomNavigationColor,
                    shadowColor: MainColor.songsContainerBackgroundColor,
                    elevation: 0.0,
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: MainColor.bottomNavigationColor,
                      child: Center(
                        child: Text(
                          'Jelly Player',
                          style: GoogleFonts.rubik(
                            letterSpacing: 5.0,
                            color: MainColor.whiteColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
