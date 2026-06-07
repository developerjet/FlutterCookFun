import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:getwidget/getwidget.dart';

class BookHomeCell extends StatelessWidget {
  final BookListModel model;
  final GestureTapCallback? onTap;

  const BookHomeCell({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                  child: GFImageOverlay(
                    image: NetworkImage(model.sceneBackground ?? ''),
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Column(
                  children: [
                    Text(
                      maxLines: 1,
                      model.sceneTitle ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Exo",
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      maxLines: 1,
                      model.sceneDesc ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Exo",
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
