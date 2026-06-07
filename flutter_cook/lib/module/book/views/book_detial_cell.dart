import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:getwidget/getwidget.dart';

class BookDetialCell extends StatelessWidget {
  final BookDishesListModel model;

  const BookDetialCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GFImageOverlay(
            width: 120,
            height: 90,
            image: NetworkImage(model.image ?? ''),
            boxFit: BoxFit.cover, //填充模式
            borderRadius: BorderRadius.circular(6), //圆角
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.dishesName ?? "",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(height: 6.0),
                Text(model.dishesDesc ?? "",
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          const Image(
            image: AssetImage('assets/images/play_count.png'),
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
