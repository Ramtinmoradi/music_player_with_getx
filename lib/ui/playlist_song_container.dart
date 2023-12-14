import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';

class PlayListSongsContainer extends StatelessWidget {
  final int index;
  final MediaItem sObj;
  final VoidCallback onPressed;
  const PlayListSongsContainer({
    super.key,
    required this.index,
    required this.sObj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shadowColor: MainColor.backgroundColor,
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Container(
          height: 70.0,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: MainColor.songsContainerBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/svg/player_like.svg',
              ),
              const Spacer(),
              SizedBox(
                width: 150.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Text>[
                    Text(
                      sObj.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansArabic(
                        color: MainColor.whiteColor,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      sObj.artist ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansArabic(
                        color: MainColor.greyColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                child: CachedNetworkImage(
                  width: 50.0,
                  height: 50.0,
                  imageUrl: sObj.artUri.toString(),
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
              const SizedBox(width: 8.0),
              SizedBox(
                width: 30.0,
                child: Text(
                  '$index',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansArabic(
                    color: MainColor.whiteColor,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
