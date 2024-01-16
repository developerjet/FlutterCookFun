import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:getwidget/getwidget.dart';
import 'package:get/get.dart';

class PlayerVideoPage extends StatefulWidget {
  PlayerVideoPage({Key? key}) : super(key: key);

  @override
  _PlayerVideoPageState createState() => _PlayerVideoPageState();
}

class _PlayerVideoPageState extends State<PlayerVideoPage> {
  late FlickVideoPlayer _player;
  late FlickManager _flickManager;
  late String _videoUrl;

  @override
  void initState() {
    super.initState();

    _videoUrl = Get.arguments['url'];
    _initializePlayer();
  }

  _initializePlayer() {
    //  加载播放资源
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(_videoUrl),
        closedCaptionFile: _loadCaptions(),
      ),
    );

    _player = FlickVideoPlayer(
      flickManager: _flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        closedCaptionTextStyle: TextStyle(fontSize: 8),
        controls: FlickPortraitControls(),
      ),
      flickVideoWithControlsFullscreen: FlickVideoWithControls(
        controls: FlickLandscapeControls(),
      ),
    );
  }

  ///If you have subtitle assets

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/bumble_bee_captions.srt');
    _flickManager.flickControlManager!.toggleSubtitle();
    return SubRipCaptionFile(fileContents);
  }

  ///If you have subtitle urls

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final url = Uri.parse('SUBTITLE URL LINK');
  //   try {
  //     final data = await http.get(url);
  //     final srtContent = data.body.toString();
  //     print(srtContent);
  //     return SubRipCaptionFile(srtContent);
  //   } catch (e) {
  //     print('Failed to get subtitles for ${e}');
  //     return SubRipCaptionFile('');
  //   }
  //}

  @override
  void dispose() {
    _flickManager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('play_video'.tr),
        backgroundColor: ThemeManager.themeColor,
      ),
      body: VisibilityDetector(
        key: ObjectKey(_flickManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && this.mounted) {
            _flickManager.flickControlManager?.autoPause();
          } else if (visibility.visibleFraction == 1) {
            _flickManager.flickControlManager?.autoResume();
          }
        },
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _player,
            )
          ],
        ),
      ),
    );
  }
}
