import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class PlayerVideoPage extends StatefulWidget {
  const PlayerVideoPage({Key? key}) : super(key: key);

  @override
  PlayerVideoPageState createState() => PlayerVideoPageState();
}

class PlayerVideoPageState extends State<PlayerVideoPage> {
  FlickVideoPlayer? _player;
  FlickManager? _flickManager;
  List<String> _urls = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args == null) return;
    final raw = (args['urls'] as List<dynamic>?) ?? [];
    _urls = raw.map((e) => e.toString()).where((u) => u.isNotEmpty).toList();
    _currentIndex = (args['index'] as int?) ?? 0;
    if (_currentIndex >= _urls.length) _currentIndex = 0;
    if (_urls.isNotEmpty) _initPlayer();
  }

  void _initPlayer() {
    _flickManager?.dispose();
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(_urls[_currentIndex]),
        closedCaptionFile: _loadCaptions(),
      ),
    );
    _player = FlickVideoPlayer(
      flickManager: _flickManager!,
      flickVideoWithControls: const FlickVideoWithControls(
        closedCaptionTextStyle: TextStyle(fontSize: 8),
        controls: FlickPortraitControls(),
      ),
      flickVideoWithControlsFullscreen: const FlickVideoWithControls(
        controls: FlickLandscapeControls(),
      ),
    );
    if (mounted) setState(() {});
  }

  void _switchVideo(int index) {
    if (index == _currentIndex) return;
    if (index < 0 || index >= _urls.length) return;
    _flickManager?.flickControlManager?.autoPause();
    setState(() {
      _currentIndex = index;
    });
    _initPlayer();
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/bumble_bee_captions.srt');
    _flickManager?.flickControlManager?.toggleSubtitle();
    return SubRipCaptionFile(fileContents);
  }

  @override
  void dispose() {
    _flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _urls.length;
    final title = total > 1
        ? '${'play_video'.tr} ${_currentIndex + 1}/$total'
        : 'play_video'.tr;

    return Scaffold(
      appBar: AppNavBar(title: title),
      body: SafeArea(
        top: false,
        bottom: false,
        child: _urls.isEmpty
            ? Center(
                child: Text('missing_video_url'.tr,
                    style: Theme.of(context).textTheme.bodyLarge))
            : Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VisibilityDetector(
                          key: ObjectKey(_flickManager),
                          onVisibilityChanged: (visibility) {
                            if (visibility.visibleFraction == 0 && mounted) {
                              _flickManager?.flickControlManager?.autoPause();
                            } else if (visibility.visibleFraction > 0) {
                              _flickManager?.flickControlManager?.autoResume();
                            }
                          },
                          child: _player ?? const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                  if (total > 1) _buildVideoList(context),
                ],
              ),
      ),
    );
  }

  Widget _buildVideoList(BuildContext context) {
    final labels = ['video_one'.tr, 'video_two'.tr];
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(CookTokens.dialogRadius),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
      child: Row(
        children: List.generate(_urls.length.clamp(0, 2), (index) {
          final isActive = index == _currentIndex;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 6, right: index == 0 ? 6 : 0),
              child: ElevatedButton(
                onPressed: () => _switchVideo(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).cardColor,
                  foregroundColor: isActive
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      CookTokens.controlRadius,
                    ),
                    side: isActive
                        ? BorderSide.none
                        : BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(labels[index.clamp(0, labels.length - 1)]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
