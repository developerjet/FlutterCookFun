import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:getwidget/getwidget.dart';

class CookStepsCell extends StatelessWidget {
  final StepLitsModel model;

  const CookStepsCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 220,
            child: GFImageOverlay(
              image: NetworkImage(model.dishesStepImage ?? ''),
              boxFit: BoxFit.cover, //填充模式
            ),
          ),
          const SizedBox(width: 10),
          Text(
            model.dishesStepDesc ?? "--",
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
