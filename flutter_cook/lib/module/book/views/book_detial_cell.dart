import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';

class BookDetialCell extends StatelessWidget {
  final BookDishesListModel model;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onPlayTap;

  const BookDetialCell({
    super.key,
    required this.model,
    this.onTap,
    this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AppNetworkImage(
              url: model.image,
              width: 120,
              height: 90,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.dishesName ?? '—',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6.0),
                  Text(model.dishesDesc ?? '—',
                      maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.play_circle_fill,
                size: 32, color: Theme.of(context).colorScheme.primary),
            onPressed: onPlayTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ],
      ),
    );
  }
}
