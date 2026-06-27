import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';

class BookHomeCell extends StatelessWidget {
  final BookListModel model;
  final GestureTapCallback? onTap;

  const BookHomeCell({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.04 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(6.0),
              ),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: AppNetworkImage(
                  url: model.sceneBackground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    model.sceneTitle ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    model.sceneDesc ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
