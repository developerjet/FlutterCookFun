import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

class CusotmCarouselSlider extends StatefulWidget {
  final List imageList;
  final bool autoPlay;
  final double aspectRatio;
  final int intervalDuration;
  final bool infiniteScroll;
  
  final void Function(int)? onTap;

  const CusotmCarouselSlider(
      {required this.imageList,
      this.autoPlay = true,
      this.aspectRatio = 16 / 9,
      this.intervalDuration = 5000,
      this.infiniteScroll = true,
      this.onTap});

  @override
  _CusotmCarouselSliderState createState() => _CusotmCarouselSliderState();
}

class _CusotmCarouselSliderState extends State<CusotmCarouselSlider> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
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
              return InkWell(
                child: Container(
                  child: Visibility(
                      visible: widget.imageList.length > 0,
                      child: Image.network(
                          widget.imageList.length > 0
                              ? widget.imageList[index]
                              : '',
                          fit: BoxFit.cover)),
                ),
                onTap: () {
                  widget.onTap!(index);
                },
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
                // 指示器
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? ThemeManager.themeColor
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

