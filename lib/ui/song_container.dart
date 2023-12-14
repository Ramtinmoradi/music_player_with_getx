import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';

class SongsContainer extends StatelessWidget {
  final int index;
  final Map sObj;
  final bool isWeb;
  final VoidCallback onPressedPlay;
  final VoidCallback onPressed;
  const SongsContainer({
    super.key,
    required this.index,
    required this.sObj,
    required this.onPressed,
    required this.onPressedPlay,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressedPlay,
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
                      sObj["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansArabic(
                        color: MainColor.whiteColor,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      sObj["artists"],
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
              if (isWeb)
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  child: CachedNetworkImage(
                    width: 50.0,
                    height: 50.0,
                    imageUrl: sObj["image"],
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
                )
              else
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    child: Image.network(
                      sObj["image"],
                      fit: BoxFit.cover,
                    ),
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
