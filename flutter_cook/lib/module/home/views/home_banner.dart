import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBannerView extends StatelessWidget {
  final List<String> images;

  HomeBannerView({required this.images});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        autoPlay: true, //自动滚动
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
      itemBuilder: (context, index, realIdx) {
        return Container(
          child: Image.network(images[index], fit: BoxFit.cover, width: width),
        );
      },
    );
  }
}
