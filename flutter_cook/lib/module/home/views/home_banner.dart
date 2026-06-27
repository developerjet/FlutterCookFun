import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:get/get.dart';

class CusotmCarouselSlider extends StatefulWidget {
  final List imageList;
  final bool autoPlay;
  final double aspectRatio;
  final int intervalDuration;
  final bool infiniteScroll;

  final void Function(int)? onTap;

  const CusotmCarouselSlider(
      {super.key, required this.imageList,
      this.autoPlay = true,
      this.aspectRatio = 16 / 9,
      this.intervalDuration = 5000,
      this.infiniteScroll = true,
      this.onTap});

  @override
  CusotmCarouselSliderState createState() => CusotmCarouselSliderState();
}

class CusotmCarouselSliderState extends State<CusotmCarouselSlider> {
  late CarouselSliderController _carouselController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.imageList.length,
            carouselController: _carouselController,
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1,
              initialPage: _currentIndex,
              autoPlay: widget.autoPlay,
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndex = index;
                });
              },
              enableInfiniteScroll: widget.infiniteScroll,
            ),
            itemBuilder: (context, index, realIdx) {
              final imagePath = widget.imageList[index]?.toString() ?? '';
              final isNetwork = imagePath.startsWith('http');

              return Semantics(
                label: 'semantics_banner'.tr,
                button: true,
                child: InkWell(
                  onTap: () => widget.onTap?.call(index),
                  child: isNetwork
                    ? AppNetworkImage(url: imagePath)
                    : Image.asset(
                        imagePath.isNotEmpty
                            ? imagePath
                            : 'assets/images/banner_placeholder.png',
                        fit: BoxFit.cover,
                      ),
              ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageList.map((imageUrl) {
                int index = widget.imageList.indexOf(imageUrl);
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
