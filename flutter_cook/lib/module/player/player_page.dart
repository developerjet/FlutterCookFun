import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';

class PlayerVideoPage extends StatefulWidget {
  PlayerVideoPage({Key? key}) : super(key: key);

  @override
  _PlayerVideoPageState createState() => _PlayerVideoPageState();
}

class _PlayerVideoPageState extends State<PlayerVideoPage> {
  late FlickManager _flickManager;
  late FlickVideoPlayer _player;

  late List<String> videoList = [];

  @override
  void initState() {
    super.initState();

    Map arguments = Get.arguments;
    for (var videoUrl in arguments.values) {
      videoList.add(videoUrl);
    }

    //  加载播放资源
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(videoList.first),
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
        title: Text("视频播放"),
        backgroundColor: CustomColors.themeColor,
      ),
      body: Column(
        children: [
          Container(
            height: 240,
            child: _player,
          ),
          // Expanded(
          //     child: Padding(
          //         padding: EdgeInsets.all(10.0),
          //         child: Row(
          //           children: [
          //             GFButton(
          //                 type: GFButtonType.solid,
          //                 child: Text("视频1"),
          //                 onPressed: () {
          //                   setState(() {
          //                     //_changePlayVideo(0);
          //                   });
          //                 }),
          //             SizedBox(
          //               width: 30,
          //             ),
          //             GFButton(
          //                 type: GFButtonType.solid,
          //                 child: Text("视频2"),
          //                 onPressed: () {
          //                   setState(() {
          //                     //_changePlayVideo(1);
          //                   });
          //                 })
          //           ],
          //         )))
        ],
      ),
    );
  }
}
