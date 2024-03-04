// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  const VideoPlay({Key? key, required this.path});

  final String path;

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.path)
      ..initialize().then((_) {
        setState(() {});
      });

    // Add a listener to get the video's aspect ratio once it's initialized
    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        double aspectRatio = _controller.value.aspectRatio;
        print('Aspect Ratio: $aspectRatio');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.path);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: TopBar(
          text: "",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: YoYoPlayer(
              url: widget.path,
              videoStyle: VideoStyle(
                allowScrubbing: true,
                fullScreenIconColor: borderTop,
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
                    child: CircularProgressIndicator(
                  color: borderDown,
                )),
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
      ),
    );
  }
}
