import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:get/get.dart';

class CookHomeCell extends StatefulWidget {
  final CookListDataModel model;
  final GestureTapCallback? onTap;

  const CookHomeCell({super.key, required this.model, this.onTap});

  @override
  State<CookHomeCell> createState() => _CookHomeCellState();
}

class _CookHomeCellState extends State<CookHomeCell>
    with AutomaticKeepAliveClientMixin {
  late final Widget _imageSection;
  bool _didPrecacheImage = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _imageSection = _CookHomeImageSection(model: widget.model);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheImage) {
      return;
    }

    final imageUrl = widget.model.image?.trim();
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'null') {
      return;
    }

    _didPrecacheImage = true;
    precacheImage(NetworkImage(imageUrl), context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _imageSection,
                Expanded(child: _CookHomeTitleSection(model: widget.model)),
              ],
            ),
          ),
          _CookHomeSelectionBorder(model: widget.model),
        ],
      ),
    );
  }
}

class _CookHomeImageSection extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeImageSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(9),
        topRight: Radius.circular(9),
      ),
      child: SizedBox(
        height: 110,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: model.image),
            _CookHomeSelectionOverlay(model: model),
          ],
        ),
      ),
    );
  }
}

class _CookHomeSelectionBorder extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeSelectionBorder({required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!model.isSelected.value) {
        return const SizedBox.shrink();
      }

      return IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
      );
    });
  }
}

class _CookHomeSelectionOverlay extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeSelectionOverlay({required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!model.isSelected.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/checked.png',
            width: 18,
            height: 18,
          ),
        ),
      );
    });
  }
}

class _CookHomeTitleSection extends StatelessWidget {
  final CookListDataModel model;

  const _CookHomeTitleSection({required this.model});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = model.isSelected.value;
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withValues(alpha: isSelected ? 0.14 : 0.07),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(9),
            bottomRight: Radius.circular(9),
          ),
        ),
        child: Text(
          model.text ?? '—',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.titleSmall?.color,
              ),
        ),
      );
    });
  }
}
