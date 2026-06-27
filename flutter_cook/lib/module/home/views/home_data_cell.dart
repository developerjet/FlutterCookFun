import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';

class HomeDataCell extends StatelessWidget {
  final HomeFoodListData model;

  const HomeDataCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8.0),
          AppNetworkImage(
            url: model.image,
            width: 90,
            height: 60,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Text(
              model.text ?? '—',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 15.0),
        ],
      ),
    );
  }
}
