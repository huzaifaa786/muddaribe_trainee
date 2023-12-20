// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class VideoPlay extends StatefulWidget {
  const VideoPlay({Key? key});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: YoYoPlayer(
            aspectRatio: 16 / 9,
            url: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            videoStyle: VideoStyle(
              qualityStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              forwardAndBackwardBtSize: 30.0,
              playButtonIconSize: 40.0,
              playIcon: Icon(
                Icons.play_arrow,
                size: 40.0,
                color: Colors.white,
              ),
              pauseIcon: Icon(
                Icons.pause,
                size: 40.0,
                color: Colors.white,
              ),
              videoQualityPadding: EdgeInsets.all(5.0),
            ),
            videoLoadingStyle: VideoLoadingStyle(
              loading: Center(
                child: CircularProgressIndicator(color: borderDown,)
              ),
            ),
            allowCacheFile: true,
            onCacheFileCompleted: (files) {
              print('Cached file length ::: ${files?.length}');
              if (files != null && files.isNotEmpty) {
                for (var file in files) {
                  print('File path ::: ${file.path}');
                }
              }
            },
            onCacheFileFailed: (error) {
              print('Cache file error ::: $error');
            },
            onFullScreen: (value) {
              // Handle fullscreen changes if needed
            },
          ),
        ),
      ),
    );
  }
}
